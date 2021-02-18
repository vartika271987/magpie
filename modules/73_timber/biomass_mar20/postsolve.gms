*** |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*#################### R SECTION START (OUTPUT DEFINITIONS) #####################
 ov73_cost_hvarea(t,i,"marginal")                          = v73_cost_hvarea.m(i);
 ov73_prod_forestry(t,j,ac,kforestry,"marginal")           = v73_prod_forestry.m(j,ac,kforestry);
 ov73_prod_natveg(t,j,land_natveg,ac,kforestry,"marginal") = v73_prod_natveg.m(j,land_natveg,ac,kforestry);
 ov73_prod_heaven_timber(t,j,kforestry,"marginal")         = v73_prod_heaven_timber.m(j,kforestry);
 ov_cost_timber(t,i,"marginal")                            = vm_cost_timber.m(i);
 oq73_cost_timber(t,i,"marginal")                          = q73_cost_timber.m(i);
 oq73_cost_hvarea(t,i,"marginal")                          = q73_cost_hvarea.m(i);
 oq73_prod_timber(t,j,kforestry,"marginal")                = q73_prod_timber.m(j,kforestry);
 oq73_prod_forestry(t,j,ac,"marginal")                     = q73_prod_forestry.m(j,ac);
 oq73_prod_secdforest(t,j,ac,"marginal")                   = q73_prod_secdforest.m(j,ac);
 oq73_prod_primforest(t,j,"marginal")                      = q73_prod_primforest.m(j);
 oq73_prod_other(t,j,ac,"marginal")                        = q73_prod_other.m(j,ac);
 ov73_cost_hvarea(t,i,"level")                             = v73_cost_hvarea.l(i);
 ov73_prod_forestry(t,j,ac,kforestry,"level")              = v73_prod_forestry.l(j,ac,kforestry);
 ov73_prod_natveg(t,j,land_natveg,ac,kforestry,"level")    = v73_prod_natveg.l(j,land_natveg,ac,kforestry);
 ov73_prod_heaven_timber(t,j,kforestry,"level")            = v73_prod_heaven_timber.l(j,kforestry);
 ov_cost_timber(t,i,"level")                               = vm_cost_timber.l(i);
 oq73_cost_timber(t,i,"level")                             = q73_cost_timber.l(i);
 oq73_cost_hvarea(t,i,"level")                             = q73_cost_hvarea.l(i);
 oq73_prod_timber(t,j,kforestry,"level")                   = q73_prod_timber.l(j,kforestry);
 oq73_prod_forestry(t,j,ac,"level")                        = q73_prod_forestry.l(j,ac);
 oq73_prod_secdforest(t,j,ac,"level")                      = q73_prod_secdforest.l(j,ac);
 oq73_prod_primforest(t,j,"level")                         = q73_prod_primforest.l(j);
 oq73_prod_other(t,j,ac,"level")                           = q73_prod_other.l(j,ac);
 ov73_cost_hvarea(t,i,"upper")                             = v73_cost_hvarea.up(i);
 ov73_prod_forestry(t,j,ac,kforestry,"upper")              = v73_prod_forestry.up(j,ac,kforestry);
 ov73_prod_natveg(t,j,land_natveg,ac,kforestry,"upper")    = v73_prod_natveg.up(j,land_natveg,ac,kforestry);
 ov73_prod_heaven_timber(t,j,kforestry,"upper")            = v73_prod_heaven_timber.up(j,kforestry);
 ov_cost_timber(t,i,"upper")                               = vm_cost_timber.up(i);
 oq73_cost_timber(t,i,"upper")                             = q73_cost_timber.up(i);
 oq73_cost_hvarea(t,i,"upper")                             = q73_cost_hvarea.up(i);
 oq73_prod_timber(t,j,kforestry,"upper")                   = q73_prod_timber.up(j,kforestry);
 oq73_prod_forestry(t,j,ac,"upper")                        = q73_prod_forestry.up(j,ac);
 oq73_prod_secdforest(t,j,ac,"upper")                      = q73_prod_secdforest.up(j,ac);
 oq73_prod_primforest(t,j,"upper")                         = q73_prod_primforest.up(j);
 oq73_prod_other(t,j,ac,"upper")                           = q73_prod_other.up(j,ac);
 ov73_cost_hvarea(t,i,"lower")                             = v73_cost_hvarea.lo(i);
 ov73_prod_forestry(t,j,ac,kforestry,"lower")              = v73_prod_forestry.lo(j,ac,kforestry);
 ov73_prod_natveg(t,j,land_natveg,ac,kforestry,"lower")    = v73_prod_natveg.lo(j,land_natveg,ac,kforestry);
 ov73_prod_heaven_timber(t,j,kforestry,"lower")            = v73_prod_heaven_timber.lo(j,kforestry);
 ov_cost_timber(t,i,"lower")                               = vm_cost_timber.lo(i);
 oq73_cost_timber(t,i,"lower")                             = q73_cost_timber.lo(i);
 oq73_cost_hvarea(t,i,"lower")                             = q73_cost_hvarea.lo(i);
 oq73_prod_timber(t,j,kforestry,"lower")                   = q73_prod_timber.lo(j,kforestry);
 oq73_prod_forestry(t,j,ac,"lower")                        = q73_prod_forestry.lo(j,ac);
 oq73_prod_secdforest(t,j,ac,"lower")                      = q73_prod_secdforest.lo(j,ac);
 oq73_prod_primforest(t,j,"lower")                         = q73_prod_primforest.lo(j);
 oq73_prod_other(t,j,ac,"lower")                           = q73_prod_other.lo(j,ac);
*##################### R SECTION END (OUTPUT DEFINITIONS) ######################
