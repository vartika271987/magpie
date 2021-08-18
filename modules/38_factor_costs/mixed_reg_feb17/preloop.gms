*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

vm_cost_inv.fx(i)=0;

*p38_fac_req("IND",kcr,"irrigated") = f38_fac_req("IND",kcr,"irrigated") * s38_factor;
loop(t,
  if (m_year(t)>2010,
    p38_fac_req("IND",kcr,"irrigated") = f38_fac_req("IND",kcr,"irrigated") * s38_factor;
);
);
