*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations

*------------------
****** Costs ******
*------------------

*' The direct costs of Timber production and afforestation `vm_cost_fore` include
*' maintenance and monitoring costs for newly established plantations as well as
*' standing plantations '[@sathaye_ghg_2005]. In addition, this type of forest management
*' (including afforestation) may cause costs in other parts of the model such as costs
*' for technological change [13_tc] or land expansion [39_landconversion]. Also included
*' are additional costs for producing timber from extremely highly managed plantations
*' which are analogous to intensification using technological change from [13_tc] but
*' in a parametrized form.

q32_cost_total(i2) .. vm_cost_fore(i2) =e=
								   v32_cost_recur(i2)
								   + v32_cost_establishment(i2)
								   + sum(cell(i2,j2), v32_land_missing(j2)) * s32_free_land_cost
									 + sum(cell(i2,j2), v32_cost_extra_investment(j2))
								   ;

*-----------------------------------------------
****** Carbon price induced afforestation ******
*-----------------------------------------------
*' The interface `vm_cdr_aff` provides the projected bgc (CDR) and local bph effects of an afforestation
*' activity for a planning horizon of 30 years `s32_planing_horizon` to the [56_ghg_policy] module.

q32_cdr_aff(j2,ac) ..
vm_cdr_aff(j2,ac,"bgc") =e=
sum(ac_est, v32_land(j2,"aff",ac_est)) * sum(ct, p32_cdr_ac(ct,j2,ac))
+ sum(ac_est, v32_land(j2,"plant",ac_est)) * sum(ct, p32_cdr_ac_plant(ct,j2,ac))
;

q32_bgp_aff(j2,ac) ..
vm_cdr_aff(j2,ac,"bph") =e=
v32_land(j2,"aff","ac0") * p32_aff_bgp(j2,ac);

*' ac_est can only increase if total afforested land increases
q32_aff_est(j2) ..
sum(ac_est, v32_land(j2,"aff",ac_est)) =l= sum(ac, v32_land(j2,"aff",ac)) - sum((ct,ac), p32_land(ct,j2,"aff",ac));

*-----------------------------------------------
****************** Land ************************
*-----------------------------------------------

*' The interface `vm_land` provides aggregated forestry land pools (`type32`) to other modules.

 q32_land(j2) ..
 vm_land(j2,"forestry") =e= sum((type32,ac), v32_land(j2,type32,ac));

*' The constraint `q32_aff_pol` accounts for the exogenous afforestation prescribed by NPI/NDC policies.

 q32_aff_pol(j2) ..
 sum(ac_est, v32_land(j2,"ndc",ac_est)) =e= sum(ct, p32_aff_pol_timestep(ct,j2));

*' The constraint `q32_max_aff` accounts for the allowed maximum global
*' afforestation defined in `p32_max_aff_area`. Note that NPI/NDC afforestation
*' policies are counted towards the maximum defined in `p32_max_aff_area`.
*' Therefore, the right-hand side of the constraint is tightened by the value of
*' the exogenously prescribed afforestation that has to be realized in later
*' time steps (`p32_aff_togo`).

 q32_max_aff .. sum((j2,type32,ac)$(not sameas(type32,"plant")), v32_land(j2,type32,ac))
                =l= p32_max_aff_area - sum(ct, p32_aff_togo(ct));

*-----------------------------------------------
************** Carbon stock ********************
*-----------------------------------------------
*' Forestry above ground carbon stocks are calculated as the product of forestry land (`v32_land`) and the area
*' weighted mean of carbon density for carbon pools (`p32_carbon_density_ac`).

 q32_carbon(j2,ag_pools)  .. vm_carbon_stock(j2,"forestry",ag_pools) =e=
                         sum((type32,ac), v32_land(j2,type32,ac)*
                         sum(ct, p32_carbon_density_ac(ct,j2,type32,ac,ag_pools)));

*' Forestry land expansion and reduction is calculated as follows:

 q32_land_diff .. vm_landdiff_forestry =e= sum((j2,type32,ac),
 					  v32_land_expansion(j2,type32,ac)
 					+ v32_land_reduction(j2,type32,ac));

 q32_land_expansion(j2,type32,ac_est) ..
	 	v32_land_expansion(j2,type32,ac_est) =e= v32_land(j2,type32,ac_est) - pc32_land(j2,type32,ac_est);

 q32_land_reduction(j2,type32,ac_sub) ..
 	v32_land_reduction(j2,type32,ac_sub) =e= pc32_land(j2,type32,ac_sub) - v32_land(j2,type32,ac_sub);

*----------------------------------------------------
********** Timber for prodcution purposes ************
*----------------------------------------------------

**** Cost calculations
*---------------------

*' Cost of new plantations establishment `v32_cost_establishment` is the investment
*' made in setting up new plantations but also accounts for the expected value of
*' future harvesting costs. This makes sure that the model sticks to reasonable plantation
*' patterns over time. Present value of harvesting costs is (1+`pm_interest`)^`p32_rotation_regional`
*' and annuity factor of `pm_interest`/(1+`pm_interest`) averages the cost of this
*' investment over time.

q32_cost_establishment(i2)..
						v32_cost_establishment(i2)
						=e=
            (sum((cell(i2,j2),type32), v32_land(j2,type32,"ac0") * s32_reESTBcost)
*            +sum(cell(i2,j2), v32_land(j2,"plant","ac0") * s32_harvesting_cost)
*              /((1+sum(ct,pm_interest(ct,i2)))**sum(ct,(p32_rotation_regional(ct,i2))))
              )
            * sum(ct,pm_interest(ct,i2)/(1+pm_interest(ct,i2)));


*' Recurring costs are paid for plantations where the trees have to be regularly monitored
*' and maintained. These costs are only calculated becuase we see active human intervention
*' in commercial plantations. These costs are paid for trees used for timber production or
*' trees established for afforestation purposes.

q32_cost_recur(i2) .. v32_cost_recur(i2) =e=
                    sum((cell(i2,j2),type32,ac_sub), v32_land(j2,type32,ac_sub)) * s32_recurring_cost;


**** New establishment decision
*------------------------------
*' New plantations are already established in the optimization step based on a certain
*' percentage (`pc32_plant_prod_share_future`) of future demand (`pm_demand_forestry_future`)
*' This is based on the expected future yield (`pc32_yield_forestry_future`) at
*' harvest (year in time step are accounted for).
*' Here we define three constraints for establishing new plantation in simulation step

*' Fix plantation area at cell level if s32_fix_plant=1. In case of s32_fix_plant=0, the RHS is just 0.
*' This makes sure that if plantation area is constrained when the switch is activated.
q32_fix_plant_area(j2) ..
							sum(ac, v32_land(j2,"plant",ac))
							=g=
							sum((ct,ac), p32_land(ct,j2,"plant",ac)) * sum(ct,p32_fix_plant(ct));

*' Global maximum constraint based on meeting all the future timber demand (`pm_demand_forestry_future`).
q32_establishment_max_glo ..
              sum(j2, (sum(ac_est, v32_land(j2,"plant",ac_est)) + v32_land_missing(j2)) / m_timestep_length_forestry * pc32_yield_forestry_future(j2))
              =l=
              sum(i2, pm_demand_forestry_future(i2,"wood"))
              ;

*' Global minimum constraint based on a proportion (`pc32_plant_prod_share_future`) of future timber demand (`pm_demand_forestry_future`).
q32_establishment_min_glo ..
              sum(j2, (sum(ac_est, v32_land(j2,"plant",ac_est)) + v32_land_missing(j2)) / m_timestep_length_forestry * pc32_yield_forestry_future(j2))
              =g=
              sum((i2,ct), pm_demand_forestry_future(i2,"wood") * s32_plant_share) * (1-sum(ct,p32_fix_plant(ct)))
              ;

*' Regional minimum constraint for maintaining current forestry area patterns,
*' while accounting for regional self sufficiency in (`pm_selfsuff_ext`) timber production.
q32_establishment_min_reg(i2) ..
              sum(cell(i2,j2), ((sum(ac_est, v32_land(j2,"plant",ac_est)) + v32_land_missing(j2)) / m_timestep_length_forestry) * pc32_yield_forestry_future(j2))
              =g=
              pm_demand_forestry_future(i2,"wood") * s32_plant_share * sum(ct, pm_selfsuff_ext(ct,i2,"wood")) * (1-sum(ct,p32_fix_plant(ct)))
              ;

*' Extra investment costs
q32_cost_extra_investment(j2).. v32_cost_extra_investment(j2) =e= sum(ac_est, v32_land(j2,"plant",ac_est)) * sum(ct,pm_investment_layer(ct,j2)) * s32_investment_cost;

*' This constraint distributes additions to forestry land over ac_est,
*' which depends on the time step length (e.g. ac0 and ac5 for a 10 year time step).

q32_forestry_est(j2,type32,ac_est) ..
v32_land(j2,type32,ac_est) =e= sum(ac_est2, v32_land(j2,type32,ac_est2))/card(ac_est2);

*' Change in forestry area is the difference between plantation area from previous time
*' step ('pc32_land') and optimized plantation area from current time step ('v32_land')

q32_hvarea_forestry(j2,ac_sub) ..
                          vm_hvarea_forestry(j2,ac_sub)
                          =l=
                          v32_land_reduction(j2,"plant",ac_sub);

*** EOF equations.gms ***
