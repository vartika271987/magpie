*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de


*' @equations

*** Calculate emissions for the core

*' Total regional GHG emissions `vm_emissions_reg` are the sum of emissions from different regional and cellular sources less
*' the fraction `im_maccs_mitigation` that can be abated by technicial mitigation measures (see  module [57_maccs]). The emisssions before technical mitigation
*' are calculated in the respective modules ([51_nitrogen], [52_carbon], [53_methane]) and delivered to this module through the 
*' interface variables `vm_btm_reg` and `vm_btm_cell`.

q56_technical_mitigation_reg(i2,pollutants,emis_source) ..
 vm_emissions_reg(i2,emis_source,pollutants)
                 =e=
                 vm_btm_reg(i2,emis_source,pollutants)
                 * (1 - sum(ct, im_maccs_mitigation(ct,i2,emis_source,pollutants)))
                 ;

q56_technical_mitigation_cell(j2,pollutants,emis_source)  ..
 v56_emis_cell(j2,emis_source,pollutants)
                =e=
                sum(cell(i2,j2),
                  vm_btm_cell(j2,emis_source,pollutants)
                  * (1 - sum(ct, im_maccs_mitigation(ct,i2,emis_source,pollutants)))
                );

q56_cell_to_reg(i2,pollutants,emis_source) ..
 vm_emissions_reg(i2,emis_source,pollutants)
                =e=
                sum(cell(i2,j2),v56_emis_cell(j2,emis_source,pollutants));


*** Emission Costs

*' Emission costs are calculated by multiplying regional and cellular emissions by the emission price `im_pollutant_prices` 
*' taking into account the price policy that was defined above in `f56_emis_policy`. 
*' Total emissions costs consist of costs for annual emissions (n2o and ch4, e.g. from soil or animal waste management), and
*' costs for emissions that are released only once (carbon emission from land use change). Benefits from carbon removal
*' (from afforestation) are also calculated in this module taking into account the policy that was defined above in `f56_aff_policy`.
*' Cost and benefits are however not summed here but in [11_costs]. 

*' Since one-off emissions are delivered by the [52_carbon] module as annual emissions they are
*' multiplied here by the timestep length `m_timestep_length` to obtain emissions for the entire timestep and are then
*' transformed back into annual costs by multiplying by the emission price and a discount factor `p56_ghg_price_growth_rate` 
*' that is equal to the growth rate of the emissions price.

 q56_emission_costs(i2) ..
                 vm_emission_costs(i2)
                 =e=
                 sum(emis_reg_yearly56, v56_emission_costs_reg_yearly(i2,emis_reg_yearly56))
               + sum(emis_reg_oneoff56, v56_emission_costs_reg_oneoff(i2,emis_reg_oneoff56))
               + sum((emis_cell_yearly56, cell(i2,j2)), v56_emission_costs_cell_yearly(j2,emis_cell_yearly56))
               + sum((emis_cell_oneoff56, cell(i2,j2)), v56_emission_costs_cell_oneoff(j2,emis_cell_oneoff56))
                 ;

* regional calcs
 q56_emission_costs_reg_yearly(i2,emis_reg_yearly56) ..
                 v56_emission_costs_reg_yearly(i2,emis_reg_yearly56)
                 =e=
                 sum(pollutants,
                     vm_emissions_reg(i2,emis_reg_yearly56,pollutants) *
                     f56_emis_policy("%c56_emis_policy%",pollutants,emis_reg_yearly56) *
                     sum(ct, im_pollutant_prices(ct,i2,pollutants))
                 );

 q56_emission_costs_reg_oneoff(i2,emis_reg_oneoff56) ..
                 v56_emission_costs_reg_oneoff(i2,emis_reg_oneoff56)
                 =g=
                 sum(pollutants,
                     vm_emissions_reg(i2,emis_reg_oneoff56,pollutants)
                     * m_timestep_length
                     * f56_emis_policy("%c56_emis_policy%",pollutants,emis_reg_oneoff56)
                     * sum(ct, 
                           im_pollutant_prices(ct,i2,pollutants) * p56_ghg_price_growth_rate(ct,i2,pollutants))
                 );


* cellular calcs
 q56_emission_costs_cell_yearly(j2,emis_cell_yearly56) ..
                 v56_emission_costs_cell_yearly(j2,emis_cell_yearly56)
                 =e=
                 sum(pollutants,
                     v56_emis_cell(j2,emis_cell_yearly56,pollutants) *
                     f56_emis_policy("%c56_emis_policy%",pollutants,emis_cell_yearly56) *
                     sum((ct,cell(i2,j2)),im_pollutant_prices(ct,i2,pollutants))
                 );

 q56_emission_costs_cell_oneoff(j2,emis_cell_oneoff56) ..
                 v56_emission_costs_cell_oneoff(j2,emis_cell_oneoff56)
                 =g=
                 sum(pollutants,
                     v56_emis_cell(j2,emis_cell_oneoff56,pollutants)
                     * m_timestep_length
                     * f56_emis_policy("%c56_emis_policy%",pollutants,emis_cell_oneoff56)
                     * sum((ct,cell(i2,j2)),
                         im_pollutant_prices(ct,i2,pollutants)
                         * p56_ghg_price_growth_rate(ct,i2,pollutants))
                 );

* expected revenue for CDR from afforestation
 q56_reward_cdr_aff_reg(i2) ..
                 vm_reward_cdr_aff(i2)
                 =e=
                 sum((co2_forestry,cell(i2,j2)),
                 v56_reward_cdr_aff(j2,co2_forestry)
                 );

 q56_reward_cdr_aff(j2,co2_forestry) ..
                 v56_reward_cdr_aff(j2,co2_forestry)
                 =e=
                 vm_cdr_aff(j2,co2_forestry) *
                 f56_aff_policy(co2_forestry,"%c56_aff_policy%") *
                 sum((ct,cell(i2,j2)),
                 im_pollutant_prices(ct,i2,"co2_c")*p56_ghg_price_growth_rate(ct,i2,"co2_c"));