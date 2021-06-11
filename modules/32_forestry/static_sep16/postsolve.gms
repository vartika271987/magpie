*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 ov_cost_fore(t,i,"marginal")                  = vm_cost_fore.m(i);
 ov_landdiff_forestry(t,"marginal")            = vm_landdiff_forestry.m;
 ov32_land(t,j,type32,ac,"marginal")           = v32_land.m(j,type32,ac);
 ov_cdr_aff(t,j,ac,aff_effect,"marginal")      = vm_cdr_aff.m(j,ac,aff_effect);
 ov32_land_reduction(t,j,type32,ac,"marginal") = v32_land_reduction.m(j,type32,ac);
 ov32_hvarea_forestry(t,j,ac,"marginal")       = v32_hvarea_forestry.m(j,ac);
 ov_cost_fore(t,i,"level")                     = vm_cost_fore.l(i);
 ov_landdiff_forestry(t,"level")               = vm_landdiff_forestry.l;
 ov32_land(t,j,type32,ac,"level")              = v32_land.l(j,type32,ac);
 ov_cdr_aff(t,j,ac,aff_effect,"level")         = vm_cdr_aff.l(j,ac,aff_effect);
 ov32_land_reduction(t,j,type32,ac,"level")    = v32_land_reduction.l(j,type32,ac);
 ov32_hvarea_forestry(t,j,ac,"level")          = v32_hvarea_forestry.l(j,ac);
 ov_cost_fore(t,i,"upper")                     = vm_cost_fore.up(i);
 ov_landdiff_forestry(t,"upper")               = vm_landdiff_forestry.up;
 ov32_land(t,j,type32,ac,"upper")              = v32_land.up(j,type32,ac);
 ov_cdr_aff(t,j,ac,aff_effect,"upper")         = vm_cdr_aff.up(j,ac,aff_effect);
 ov32_land_reduction(t,j,type32,ac,"upper")    = v32_land_reduction.up(j,type32,ac);
 ov32_hvarea_forestry(t,j,ac,"upper")          = v32_hvarea_forestry.up(j,ac);
 ov_cost_fore(t,i,"lower")                     = vm_cost_fore.lo(i);
 ov_landdiff_forestry(t,"lower")               = vm_landdiff_forestry.lo;
 ov32_land(t,j,type32,ac,"lower")              = v32_land.lo(j,type32,ac);
 ov_cdr_aff(t,j,ac,aff_effect,"lower")         = vm_cdr_aff.lo(j,ac,aff_effect);
 ov32_land_reduction(t,j,type32,ac,"lower")    = v32_land_reduction.lo(j,type32,ac);
 ov32_hvarea_forestry(t,j,ac,"lower")          = v32_hvarea_forestry.lo(j,ac);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################
