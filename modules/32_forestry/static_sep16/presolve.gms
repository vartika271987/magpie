*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*define ac_est and ac_sub
ac_est(ac) = no;
ac_est(ac) = yes$(ord(ac) <= (m_yeardiff_forestry(t)/5));

ac_sub(ac) = no;
ac_sub(ac) = yes$(ord(ac) > (m_yeardiff_forestry(t)/5));

*' @code
*' Forestry above ground carbon stocks are calculated by multiplying plantations in 1995
*' with the forestry above ground carbon density of the current time step (`pc32_carbon_density`).
pc32_carbon_density(j,ag_pools) = fm_carbon_density(t,j,"forestry",ag_pools);
vm_carbon_stock.fx(j,"forestry",ag_pools) =
	sum((type32,ac), v32_land.l(j,type32,ac)*pm_carbon_density_ac(t,j,ac,ag_pools));

*' Biodiversity value

vm_bv.fx(j,"aff_co2p",potnatveg) =
          v32_land.l(j,"aff",ac_mature) * fm_bii_coeff("secd_mature",potnatveg) * fm_luh2_side_layers(j,potnatveg)
        + v32_land.l(j,"aff",ac_young) * fm_bii_coeff("secd_young",potnatveg) * fm_luh2_side_layers(j,potnatveg);

vm_bv.fx(j,"aff_ndc",potnatveg) =
          v32_land.l(j,"ndc",ac_mature) * fm_bii_coeff("secd_mature",potnatveg) * fm_luh2_side_layers(j,potnatveg)
        + v32_land.l(j,"ndc",ac_young) * fm_bii_coeff("secd_young",potnatveg) * fm_luh2_side_layers(j,potnatveg);

vm_bv.fx(j,"plant",potnatveg) =
          v32_land.l(j,"plant",ac) * fm_bii_coeff("timber",potnatveg) * fm_luh2_side_layers(j,potnatveg);


*' Wood demand is also set to zero because forestry is not modeled in this realization.
vm_supply.fx(i2,kforestry) = 0;
*' @stop

*** EOF presolve.gms ***
