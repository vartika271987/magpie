*** (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK),
*** authors, and contributors see AUTHORS file
*** This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** Contact: magpie@pik-potsdam.de

parameters
 pc44_bv_weighted(j,landcover44)		        Current range rarity weighted bii (Mha)
 p44_price_bv_loss(t)			                biodiversity value loss price factor (US$ per ha of bv loss)
 pc44_price_bv_loss			                    biodiversity value loss price factor (US$ per ha of bv loss)
;

variables
 v44_bv_loss(j)                                 total biodiversity value loss (Mha per time step)
 v44_diff_bv_landcover(j,landcover44)	 		difference of biodiversity value per land class (Mha per time step)
 vm_cost_bv_loss(j)					            biodiversity value loss cost (mio US$)
;

positive variables
 vm_bv(j,landcover44,potnatveg)		            biodiversity value for all land cover classes (unweighted) (Mha)
 v44_bv_weighted(j,landcover44) 			    range rarity weighted biodiversity value (Mha)
;

equations
 q44_bv_loss(j)                                 zotal biodiversity value loss constraint (Mha)
 q44_diff_bv_landcover(j,landcover44)			biodiversity value loss constraint per land class (Mha)
 q44_bv_weighted(j,landcover44)		            biodiversity value stock constraint (Mha)
 q44_cost_bv_loss(j)			                biodiversity value loss cost constraint (mio US$)
;


*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 ov44_bv_loss(t,j,type)                       total biodiversity value loss (Mha per time step)
 ov44_diff_bv_landcover(t,j,landcover44,type) difference of biodiversity value per land class (Mha per time step)
 ov_cost_bv_loss(t,j,type)                    biodiversity value loss cost (mio US$)
 ov_bv(t,j,landcover44,potnatveg,type)        biodiversity value for all land cover classes (unweighted) (Mha)
 ov44_bv_weighted(t,j,landcover44,type)       range rarity weighted biodiversity value (Mha)
 oq44_bv_loss(t,j,type)                       zotal biodiversity value loss constraint (Mha)
 oq44_diff_bv_landcover(t,j,landcover44,type) biodiversity value loss constraint per land class (Mha)
 oq44_bv_weighted(t,j,landcover44,type)       biodiversity value stock constraint (Mha)
 oq44_cost_bv_loss(t,j,type)                  biodiversity value loss cost constraint (mio US$)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################

