*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 ov35_secdforest(t,j,ac,"marginal")        = v35_secdforest.m(j,ac);
 ov35_other(t,j,ac,"marginal")             = v35_other.m(j,ac);
 ov_landdiff_natveg(t,"marginal")          = vm_landdiff_natveg.m;
 ov35_hvarea_secdforest(t,j,ac,"marginal") = v35_hvarea_secdforest.m(j,ac);
 ov35_hvarea_other(t,j,ac,"marginal")      = v35_hvarea_other.m(j,ac);
 ov35_hvarea_primforest(t,j,"marginal")    = v35_hvarea_primforest.m(j);
 ov_cost_hvarea_natveg(t,i,"marginal")     = vm_cost_hvarea_natveg.m(i);
 ov35_secdforest(t,j,ac,"level")           = v35_secdforest.l(j,ac);
 ov35_other(t,j,ac,"level")                = v35_other.l(j,ac);
 ov_landdiff_natveg(t,"level")             = vm_landdiff_natveg.l;
 ov35_hvarea_secdforest(t,j,ac,"level")    = v35_hvarea_secdforest.l(j,ac);
 ov35_hvarea_other(t,j,ac,"level")         = v35_hvarea_other.l(j,ac);
 ov35_hvarea_primforest(t,j,"level")       = v35_hvarea_primforest.l(j);
 ov_cost_hvarea_natveg(t,i,"level")        = vm_cost_hvarea_natveg.l(i);
 ov35_secdforest(t,j,ac,"upper")           = v35_secdforest.up(j,ac);
 ov35_other(t,j,ac,"upper")                = v35_other.up(j,ac);
 ov_landdiff_natveg(t,"upper")             = vm_landdiff_natveg.up;
 ov35_hvarea_secdforest(t,j,ac,"upper")    = v35_hvarea_secdforest.up(j,ac);
 ov35_hvarea_other(t,j,ac,"upper")         = v35_hvarea_other.up(j,ac);
 ov35_hvarea_primforest(t,j,"upper")       = v35_hvarea_primforest.up(j);
 ov_cost_hvarea_natveg(t,i,"upper")        = vm_cost_hvarea_natveg.up(i);
 ov35_secdforest(t,j,ac,"lower")           = v35_secdforest.lo(j,ac);
 ov35_other(t,j,ac,"lower")                = v35_other.lo(j,ac);
 ov_landdiff_natveg(t,"lower")             = vm_landdiff_natveg.lo;
 ov35_hvarea_secdforest(t,j,ac,"lower")    = v35_hvarea_secdforest.lo(j,ac);
 ov35_hvarea_other(t,j,ac,"lower")         = v35_hvarea_other.lo(j,ac);
 ov35_hvarea_primforest(t,j,"lower")       = v35_hvarea_primforest.lo(j);
 ov_cost_hvarea_natveg(t,i,"lower")        = vm_cost_hvarea_natveg.lo(i);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################

