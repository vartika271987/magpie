*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de


pc13_land(i) = sum(cell(i,j),pcm_land(j,"crop"));

if (sum(sameas(t_past,t),1) = 1 AND s13_ignore_tau_historical = 0,
	vm_tau.lo(i) =    f13_tau_historical(t,i);
else
	vm_tau.lo(i) =    pcm_tau(i);
);

	vm_tau.up(i) =  2*pcm_tau(i);

* educated guess for vm_tau.l:
	vm_tau.l(i) = pcm_tau(i)*(1+pc13_tcguess(i))**m_yeardiff(t);

	vm_tech_cost.up(i) = 10e9;
