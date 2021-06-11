*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*fix primforest
vm_land.fx(j,"primforest") = pcm_land(j,"primforest");

*fix secdforest
v35_secdforest.fx(j,ac) = 0;
v35_secdforest.fx(j,"acx") = pcm_land(j,"secdforest");
vm_land.fx(j,"secdforest") = sum(ac, v35_secdforest.l(j,ac));

*fix other land
v35_other.fx(j,ac) = 0;
v35_other.fx(j,"acx") = pcm_land(j,"other");
vm_land.fx(j,"other") = sum(ac, v35_other.l(j,ac));

vm_landdiff_natveg.fx = 0;

*Fix natveg harvest
v35_hvarea_secdforest.fx(j,ac)  = 0;
v35_hvarea_other.fx(j,ac)       = 0;
v35_hvarea_primforest.fx(j)     = 0;

vm_cost_hvarea_natveg.fx(i) = 0;
