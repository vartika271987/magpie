*** |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @code
*' Minimum semi-natural vegetation (SNV) share is fading in after 2020
p29_snv_shr(t,j) = p29_snv_scenario_fader(t) *
  (s29_snv_shr * sum(cell(i,j), p29_country_snv_weight(i))
  + s29_snv_shr_noselect * sum(cell(i,j), 1-p29_country_snv_weight(i)));

*' Cropland relocation in response to SNV policy is based on exogeneous land
*' cover information from the Copernicus Global Land Service (@buchhorn_copernicus_2020).
*' The rate of the policy implementation is derived based
*' on the difference of scenario fader values in consecutive time steps
p29_snv_relocation(t,j) = (p29_snv_scenario_fader(t) - p29_snv_scenario_fader(t-1)) *
  (i29_snv_relocation_target(j) * sum(cell(i,j), p29_country_snv_weight(i))
  + s29_snv_shr_noselect * sum(cell(i,j), 1-p29_country_snv_weight(i)));
*' The following lines take care of mismatches in the input
*' data (derived from satellite imagery from the Copernicus
*' Global Land Service (@buchhorn_copernicus_2020)) and in
*' cases of cropland reduction
p29_max_snv_relocation(t,j) = p29_snv_shr(t,j) * (p29_snv_scenario_fader(t) - p29_snv_scenario_fader(t-1)) * pcm_land(j,"crop");
p29_snv_relocation(t,j)$(p29_snv_relocation(t, j) > p29_max_snv_relocation(t,j)) = p29_max_snv_relocation(t,j);

*' Area potentially available for cropping
p29_avl_cropland(t,j) = f29_avl_cropland(j,"%c29_marginal_land%") * (1 - p29_snv_shr(t,j));
*' @stop


* Growth of trees on cropland is modelled by shifting age-classes according to time step length.
s29_shift = m_timestep_length_forestry/5;
* example: ac10 in t = ac5 (ac10-1) in t-1 for a 5 yr time step (s29_shift = 1)
    p29_treecover(t,j,ac)$(ord(ac) > s29_shift) = pc29_treecover(j,ac-s29_shift);
* account for cases at the end of the age class set (s29_shift > 1) which are not shifted by the above calculation
    p29_treecover(t,j,"acx") = p29_treecover(t,j,"acx")
                  + sum(ac$(ord(ac) > card(ac)-s29_shift), pc29_treecover(j,ac));

pc29_treecover(j,ac) = p29_treecover(t,j,ac);
v29_treecover.l(j,ac) = p29_treecover(t,j,ac);

if(m_year(t) <= s29_treecover_scenario_start,
 v29_treecover.fx(j,ac) = pc29_treecover(j,ac);
else
 v29_treecover.lo(j,ac_est) = 0;
 v29_treecover.up(j,ac_est) = Inf;
 if(s29_treecover_decrease = 1,
  v29_treecover.lo(j,ac_sub) = 0;
  v29_treecover.up(j,ac_sub) = pc29_treecover(j,ac_sub);
 else
  v29_treecover.fx(j,ac_sub) = pc29_treecover(j,ac_sub);  
 );
);

p29_treecover_min_shr(t,j) = 
 ((1-p29_treecover_scenario_fader(t)) * sum(ac, pc29_treecover(j,ac))/pcm_land(j,"crop"))$(pcm_land(j,"crop") > 1e-10) +
 (p29_treecover_scenario_fader(t) * s29_treecover_min_shr);

p29_fallow_min_shr(t,j) = p29_fallow_scenario_fader(t) * s29_fallow_min_shr;


