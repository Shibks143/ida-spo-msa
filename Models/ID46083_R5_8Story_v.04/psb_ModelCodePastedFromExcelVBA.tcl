# 1. Shear Panel Material 																																												
	# Define Joint Shear Panel Materials																																											
		#	Elastic	matTag	Force-Defo_Slope																																							
		uniaxialMaterial	Elastic	40901	2235854999.94968																																							
		uniaxialMaterial	Elastic	40902	3043247083.26485																																							
		uniaxialMaterial	Elastic	40903	3043247083.26485																																							
		uniaxialMaterial	Elastic	40904	2235854999.94968																																							
																																												
		uniaxialMaterial	Elastic	40801	2235854999.94968																																							
		uniaxialMaterial	Elastic	40802	3043247083.26485																																							
		uniaxialMaterial	Elastic	40803	3043247083.26485																																							
		uniaxialMaterial	Elastic	40804	2235854999.94968																																							
																																												
		uniaxialMaterial	Elastic	40701	2235854999.94968																																							
		uniaxialMaterial	Elastic	40702	3043247083.26485																																							
		uniaxialMaterial	Elastic	40703	3043247083.26485																																							
		uniaxialMaterial	Elastic	40704	2235854999.94968																																							
																																												
		uniaxialMaterial	Elastic	40601	2235854999.94968																																							
		uniaxialMaterial	Elastic	40602	3043247083.26485																																							
		uniaxialMaterial	Elastic	40603	3043247083.26485																																							
		uniaxialMaterial	Elastic	40604	2235854999.94968																																							
																																												
		uniaxialMaterial	Elastic	40501	2811454575.82959																																							
		uniaxialMaterial	Elastic	40502	4542689523.70729																																							
		uniaxialMaterial	Elastic	40503	4542689523.70729																																							
		uniaxialMaterial	Elastic	40504	2811454575.82959																																							
																																												
		uniaxialMaterial	Elastic	40401	2811454575.82959																																							
		uniaxialMaterial	Elastic	40402	4542689523.70729																																							
		uniaxialMaterial	Elastic	40403	4542689523.70729																																							
		uniaxialMaterial	Elastic	40404	2811454575.82959																																							
																																												
		uniaxialMaterial	Elastic	40301	2811454575.82959																																							
		uniaxialMaterial	Elastic	40302	4542689523.70729																																							
		uniaxialMaterial	Elastic	40303	4542689523.70729																																							
		uniaxialMaterial	Elastic	40304	2811454575.82959																																							
																																												
		uniaxialMaterial	Elastic	40201	2811454575.82959																																							
		uniaxialMaterial	Elastic	40202	4542689523.70729																																							
		uniaxialMaterial	Elastic	40203	4542689523.70729																																							
		uniaxialMaterial	Elastic	40204	2811454575.82959																																							
	################################################################																																											
																																												
# 2a. Ibarra-Medina-Krawinkler Material for Column Joints																																												
	# Define the Column Plastic Hinge Materials																																											
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																												
		CreateIbarraMaterial	308011	192369496254.75	1750174.115	-1750174.115	1.193401971	0.060600045	-0.060600045	0.1	115.5490685	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	308021	224431078963.875	2019253.144	-2019253.144	1.191520785	0.055894858	-0.055894858	0.1	113.5190079	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	308031	224431078963.875	2019253.144	-2019253.144	1.191520785	0.055894858	-0.055894858	0.1	113.5190079	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	308041	192369496254.75	1750174.115	-1750174.115	1.193401971	0.060600045	-0.060600045	0.1	115.5490685	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
																																												
		CreateIbarraMaterial	307011	192369496254.75	1849186.28	-1849186.28	1.190534562	0.0587979	-0.0587979	0.1	112.4677697	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	307021	224431078963.875	2210471.461	-2210471.461	1.186784188	0.053235198	-0.053235198	0.1	108.5506327	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	307031	224431078963.875	2210471.461	-2210471.461	1.186784188	0.053235198	-0.053235198	0.1	108.5506327	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	307041	192369496254.75	1849186.28	-1849186.28	1.190534562	0.0587979	-0.0587979	0.1	112.4677697	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
																																												
		CreateIbarraMaterial	306011	192369496254.75	1947132.11	-1947132.11	1.187674044	0.057069778	-0.057069778	0.1	109.4686387	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	306021	224431078963.875	2557815.743	-2557815.743	1.182066421	0.051501686	-0.051501686	0.1	103.7997079	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	306031	224431078963.875	2557815.743	-2557815.743	1.182066421	0.051501686	-0.051501686	0.1	103.7997079	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	306041	192369496254.75	1947132.11	-1947132.11	1.187674044	0.057069778	-0.057069778	0.1	109.4686387	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
																																												
		CreateIbarraMaterial	305011	192369496254.75	2124869.901	-2124869.901	1.184820398	0.055633495	-0.055633495	0.1	106.5494842	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	305021	224431078963.875	2921703.831	-2921703.831	1.177367408	0.04981392	-0.04981392	0.091313552	99.25671643	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	305031	224431078963.875	2921703.831	-2921703.831	1.177367408	0.04981392	-0.04981392	0.091313552	99.25671643	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	305041	192369496254.75	2124869.901	-2124869.901	1.184820398	0.055633495	-0.055633495	0.1	106.5494842	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
																																												
		CreateIbarraMaterial	304011	256323240044.253	2419737.302	-2419737.302	1.183911436	0.052199398	-0.052199398	0.1	108.4766617	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	304021	382869512468.151	3655007.743	-3655007.743	1.178119317	0.045452555	-0.045452555	0.082403772	105.0422732	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	304031	382869512468.151	3655007.743	-3655007.743	1.178119317	0.045452555	-0.045452555	0.082403772	105.0422732	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	304041	256323240044.253	2419737.302	-2419737.302	1.183911436	0.052199398	-0.052199398	0.1	108.4766617	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
																																												
		CreateIbarraMaterial	303011	256323240044.253	2523408.914	-2523408.914	1.181428063	0.050877193	-0.050877193	0.1	105.9473618	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	303021	382869512468.151	3867980.243	-3867980.243	1.174477742	0.043822941	-0.043822941	0.075139649	101.4513736	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	303031	382869512468.151	3867980.243	-3867980.243	1.174477742	0.043822941	-0.043822941	0.075139649	101.4513736	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	303041	256323240044.253	2523408.914	-2523408.914	1.181428063	0.050877193	-0.050877193	0.1	105.9473618	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
																																												
		CreateIbarraMaterial	302011	256323240044.253	2626187.633	-2626187.633	1.178949898	0.049603003	-0.049603003	0.1	103.4770364	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	302021	382869512468.151	4078345.54	-4078345.54	1.170847423	0.042281064	-0.042281064	0.068515879	97.98322983	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	302031	382869512468.151	4078345.54	-4078345.54	1.170847423	0.042281064	-0.042281064	0.068515879	97.98322983	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
		CreateIbarraMaterial	302041	256323240044.253	2626187.633	-2626187.633	1.178949898	0.049603003	-0.049603003	0.1	103.4770364	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150																												
																																												
		CreateIbarraMaterial	301011	256323240044.253	2902573.626	-2902573.626	1.176432783	0.050194209	-0.050194209	0.095477171	101.0217067	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750																												
		CreateIbarraMaterial	301021	435349279449.725	4595652.86	-4595652.86	1.167184523	0.041884053	-0.041884053	0.062406163	94.59375263	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750																												
		CreateIbarraMaterial	301031	435349279449.725	4595652.86	-4595652.86	1.167184523	0.041884053	-0.041884053	0.062406163	94.59375263	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750																												
		CreateIbarraMaterial	301041	256323240044.253	2902573.626	-2902573.626	1.176432783	0.050194209	-0.050194209	0.095477171	101.0217067	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750																												
	################################################################																																											
																																												
# 2b. Ibarra-Medina-Krawinkler Material for Beam Joints																																												
	# Define the Beam Plastic Hinge Materials																																											
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																												
		CreateIbarraMaterial	209011	242239545536.327	619765.2936	-872723.1187	1.196276286	0.044560932	-0.040290934	0.1	104.4023777	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	209012	242239545536.327	872723.1187	-619765.2936	1.196276286	0.040290934	-0.044560932	0.1	104.4023777	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	209021	242239545536.327	567090.623	-1005001.26	1.196276286	0.04643523	-0.039369288	0.1	104.4023777	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	209022	242239545536.327	1005001.26	-567090.623	1.196276286	0.039369288	-0.04643523	0.1	104.4023777	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	209031	242239545536.327	619765.2936	-872723.1187	1.196276286	0.044560932	-0.040290934	0.1	104.4023777	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	209032	242239545536.327	872723.1187	-619765.2936	1.196276286	0.040290934	-0.044560932	0.1	104.4023777	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
																																												
		CreateIbarraMaterial	208011	242239545536.327	810954.496	-1543904.78	1.196276286	0.055750451	-0.047666329	0.1	111.2380968	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	208012	242239545536.327	1543904.78	-810954.496	1.196276286	0.047666329	-0.055750451	0.1	111.2380968	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	208021	242239545536.327	757847.0013	-1478120.316	1.196276286	0.053824017	-0.045603178	0.1	109.4209482	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	208022	242239545536.327	1478120.316	-757847.0013	1.196276286	0.045603178	-0.053824017	0.1	109.4209482	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	208031	242239545536.327	810954.496	-1543904.78	1.196276286	0.055750451	-0.047666329	0.1	111.2380968	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	208032	242239545536.327	1543904.78	-810954.496	1.196276286	0.047666329	-0.055750451	0.1	111.2380968	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
																																												
		CreateIbarraMaterial	207011	242239545536.327	1112470.297	-2005776.42	1.196276286	0.071885697	-0.063189664	0.1	118.8135174	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	207012	242239545536.327	2005776.42	-1112470.297	1.196276286	0.063189664	-0.071885697	0.1	118.8135174	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	207021	242239545536.327	1136465.967	-2006188.891	1.196276286	0.06569971	-0.058413738	0.1	118.8135174	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	207022	242239545536.327	2006188.891	-1136465.967	1.196276286	0.058413738	-0.06569971	0.1	118.8135174	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	207031	242239545536.327	1112470.297	-2005776.42	1.196276286	0.071885697	-0.063189664	0.1	118.8135174	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	207032	242239545536.327	2005776.42	-1112470.297	1.196276286	0.063189664	-0.071885697	0.1	118.8135174	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
																																												
		CreateIbarraMaterial	206011	242239545536.327	1500592.194	-2483532.749	1.196276286	0.081493003	-0.074439747	0.1	124.8317562	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	206012	242239545536.327	2483532.749	-1500592.194	1.196276286	0.074439747	-0.081493003	0.1	124.8317562	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	206021	242239545536.327	1433792.076	-2481341.523	1.196276286	0.078987949	-0.07160542	0.1	122.7925461	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	206022	242239545536.327	2481341.523	-1433792.076	1.196276286	0.07160542	-0.078987949	0.1	122.7925461	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	206031	242239545536.327	1500592.194	-2483532.749	1.196276286	0.081493003	-0.074439747	0.1	124.8317562	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
		CreateIbarraMaterial	206032	242239545536.327	2483532.749	-1500592.194	1.196276286	0.074439747	-0.081493003	0.1	124.8317562	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																												
																																												
		CreateIbarraMaterial	205011	239704480524.9	1803702.667	-2669763.873	1.196276286	0.085225781	-0.080173895	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	205012	239704480524.9	2669763.873	-1803702.667	1.196276286	0.080173895	-0.085225781	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	205021	238859458854.424	1803702.667	-2669763.873	1.196276286	0.08522726	-0.080176084	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	205022	238859458854.424	2669763.873	-1803702.667	1.196276286	0.080176084	-0.08522726	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	205031	239704480524.9	1803702.667	-2669763.873	1.196276286	0.085225781	-0.080173895	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	205032	239704480524.9	2669763.873	-1803702.667	1.196276286	0.080173895	-0.085225781	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
																																												
		CreateIbarraMaterial	204011	239704480524.9	1922000.87	-2786324.953	1.196276286	0.089005204	-0.084219502	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	204012	239704480524.9	2786324.953	-1922000.87	1.196276286	0.084219502	-0.089005204	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	204021	238859458854.424	1922777.284	-2850098.038	1.196276286	0.086400841	-0.08179111	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	204022	238859458854.424	2850098.038	-1922777.284	1.196276286	0.08179111	-0.086400841	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	204031	239704480524.9	1922000.87	-2786324.953	1.196276286	0.089005204	-0.084219502	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	204032	239704480524.9	2786324.953	-1922000.87	1.196276286	0.084219502	-0.089005204	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
																																												
		CreateIbarraMaterial	203011	239704480524.9	1922000.87	-2786324.953	1.196276286	0.089005204	-0.084219502	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	203012	239704480524.9	2786324.953	-1922000.87	1.196276286	0.084219502	-0.089005204	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	203021	238859458854.424	1922000.87	-2786324.953	1.196276286	0.085990921	-0.081558599	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	203022	238859458854.424	2786324.953	-1922000.87	1.196276286	0.081558599	-0.085990921	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	203031	239704480524.9	1922000.87	-2786324.953	1.196276286	0.089005204	-0.084219502	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	203032	239704480524.9	2786324.953	-1922000.87	1.196276286	0.084219502	-0.089005204	0.1	129.012334	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
																																												
		CreateIbarraMaterial	202011	239704480524.9	1736654.985	-2603761.553	1.196276286	0.084811852	-0.079378792	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	202012	239704480524.9	2603761.553	-1736654.985	1.196276286	0.079378792	-0.084811852	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	202021	238859458854.424	1618198.252	-2487267.916	1.196276286	0.081327356	-0.07555204	0.1	124.8317562	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	202022	238859458854.424	2487267.916	-1618198.252	1.196276286	0.07555204	-0.081327356	0.1	124.8317562	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																												
		CreateIbarraMaterial	202031	239704480524.9	1736654.985	-2603761.553	1.196276286	0.084811852	-0.079378792	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
		CreateIbarraMaterial	202032	239704480524.9	2603761.553	-1736654.985	1.196276286	0.079378792	-0.084811852	0.1	126.9048314	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7425																												
	################################################################																																											
																																												
# 3. Footing rotational stiffness																																												
	# Define the Elastic Footing Rotational Stiffness Materials (this is supposed to include link beam and footing-soil stiffness)																																											
		#	Elastic	matTag	Force-Defo_Slope																																							
		uniaxialMaterial	Elastic	601	17858981514.91																																				
		uniaxialMaterial	Elastic	602	64149197529.63																																							
		uniaxialMaterial	Elastic	603	64149197529.63																																							
		uniaxialMaterial	Elastic	604	17858981514.91																																							
	################################################################																																											
																																												
																																												
# 4. Define Nodes																																												
	# Define the Footing nodes																																											
		#	nodeTag	X	Y																																							
		node	201011	0	0																																							
		node	201012	0	0																																							
		node	201013	0	0																																							
																																												
		node	201021	8200	0																																							
		node	201022	8200	0																																							
		node	201023	8200	0																																							
																																												
		node	201031	16400	0																																							
		node	201032	16400	0																																							
		node	201033	16400	0																																							
																																												
		node	201041	24600	0																																							
		node	201042	24600	0																																							
		node	201043	24600	0																																							
																																												
	# Define Joint nodes																																											
		node	202011	0	3750																																							
		node	202012	375	4125																																							
		node	202013	0	4500																																							
		node	202014	-375	4125																																							
		node	202021	8200	3750																																							
		node	202022	8600	4125																																							
		node	202023	8200	4500																																							
		node	202024	7800	4125																																							
		node	202031	16400	3750																																							
		node	202032	16800	4125																																							
		node	202033	16400	4500																																							
		node	202034	16000	4125																																							
		node	202041	24600	3750																																							
		node	202042	24975	4125																																							
		node	202043	24600	4500																																							
		node	202044	24225	4125																																							
																																												
		node	203011	0	7650																																							
		node	203012	375	8025																																							
		node	203013	0	8400																																							
		node	203014	-375	8025																																							
		node	203021	8200	7650																																							
		node	203022	8600	8025																																							
		node	203023	8200	8400																																							
		node	203024	7800	8025																																							
		node	203031	16400	7650																																							
		node	203032	16800	8025																																							
		node	203033	16400	8400																																							
		node	203034	16000	8025																																							
		node	203041	24600	7650																																							
		node	203042	24975	8025																																							
		node	203043	24600	8400																																							
		node	203044	24225	8025																																							
																																												
		node	204011	0	11550																																							
		node	204012	375	11925																																							
		node	204013	0	12300																																							
		node	204014	-375	11925																																							
		node	204021	8200	11550																																							
		node	204022	8600	11925																																							
		node	204023	8200	12300																																							
		node	204024	7800	11925																																							
		node	204031	16400	11550																																							
		node	204032	16800	11925																																							
		node	204033	16400	12300																																							
		node	204034	16000	11925																																							
		node	204041	24600	11550																																							
		node	204042	24975	11925																																							
		node	204043	24600	12300																																							
		node	204044	24225	11925																																							
																																												
		node	205011	0	15450																																							
		node	205012	375	15825																																							
		node	205013	0	16200																																							
		node	205014	-375	15825																																							
		node	205021	8200	15450																																							
		node	205022	8600	15825																																							
		node	205023	8200	16200																																							
		node	205024	7800	15825																																							
		node	205031	16400	15450																																							
		node	205032	16800	15825																																							
		node	205033	16400	16200																																							
		node	205034	16000	15825																																							
		node	205041	24600	15450																																							
		node	205042	24975	15825																																							
		node	205043	24600	16200																																							
		node	205044	24225	15825																																							
																																												
		node	206011	0	19350																																							
		node	206012	350	19725																																							
		node	206013	0	20100																																							
		node	206014	-350	19725																																							
		node	206021	8200	19350																																							
		node	206022	8550	19725																																							
		node	206023	8200	20100																																							
		node	206024	7850	19725																																							
		node	206031	16400	19350																																							
		node	206032	16750	19725																																							
		node	206033	16400	20100																																							
		node	206034	16050	19725																																							
		node	206041	24600	19350																																							
		node	206042	24950	19725																																							
		node	206043	24600	20100																																							
		node	206044	24250	19725																																							
																																												
		node	207011	0	23250																																							
		node	207012	350	23625																																							
		node	207013	0	24000																																							
		node	207014	-350	23625																																							
		node	207021	8200	23250																																							
		node	207022	8550	23625																																							
		node	207023	8200	24000																																							
		node	207024	7850	23625																																							
		node	207031	16400	23250																																							
		node	207032	16750	23625																																							
		node	207033	16400	24000																																							
		node	207034	16050	23625																																							
		node	207041	24600	23250																																							
		node	207042	24950	23625																																							
		node	207043	24600	24000																																							
		node	207044	24250	23625																																							
																																												
		node	208011	0	27150																																							
		node	208012	350	27525																																							
		node	208013	0	27900																																							
		node	208014	-350	27525																																							
		node	208021	8200	27150																																							
		node	208022	8550	27525																																							
		node	208023	8200	27900																																							
		node	208024	7850	27525																																							
		node	208031	16400	27150																																							
		node	208032	16750	27525																																							
		node	208033	16400	27900																																							
		node	208034	16050	27525																																							
		node	208041	24600	27150																																							
		node	208042	24950	27525																																							
		node	208043	24600	27900																																							
		node	208044	24250	27525																																							
																																												
		node	209011	0	31050																																							
		node	209012	350	31425																																							
		node	209013	0	31800																																							
		node	209014	-350	31425																																							
		node	209021	8200	31050																																							
		node	209022	8550	31425																																							
		node	209023	8200	31800																																							
		node	209024	7850	31425																																							
		node	209031	16400	31050																																							
		node	209032	16750	31425																																							
		node	209033	16400	31800																																							
		node	209034	16050	31425																																							
		node	209041	24600	31050																																							
		node	209042	24950	31425																																							
		node	209043	24600	31800																																							
		node	209044	24250	31425																																							
																																												
	# Define the leaning column nodes																																											
		node	309	32800	31800																																							
		node	308	32800	27900																																							
		node	307	32800	24000																																							
		node	306	32800	20100																																							
		node	305	32800	16200																																							
		node	304	32800	12300																																							
		node	303	32800	8400																																							
		node	302	32800	4500																																							
		node	301	32800	0																																							
	################################################################																																											
																																												
# 5. Define the node fixities																																												
		#	nodeTag	DX	DY	RZ																																						
		fix	201011	1	1	1																																						
		fix	201021	1	1	1																																						
		fix	201031	1	1	1																																						
		fix	201041	1	1	1																																						
																																												
																																												
	# Define the leaning column node fixity																																											
		fix	301	1	1	1																																						
	################################################################																																											
																																												
# 6. DEFINE ELEMENTS																																												
# 6a. Elastic Column elements																																												
		#	#	$eleTag	$iNode	$jNode	$A	$E	$Iz	$transfTag																																		
		element	elasticBeamColumn	30801	208013	209011	420000	32.04822928	6002500000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30802	208023	209021	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30803	208033	209031	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30804	208043	209041	420000	32.04822928	6002500000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30701	207013	208011	420000	32.04822928	6002500000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30702	207023	208021	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30703	207033	208031	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30704	207043	208041	420000	32.04822928	6002500000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30601	206013	207011	420000	32.04822928	6002500000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30602	206023	207021	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30603	206033	207031	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30604	206043	207041	420000	32.04822928	6002500000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30501	205013	206011	420000	32.04822928	6002500000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30502	205023	206021	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30503	205033	206031	490000	32.04822928	7002916667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30504	205043	206041	420000	32.04822928	6002500000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30401	204013	205011	487500	32.04822928	7998046875	$primaryGeomTransT																																		
		element	elasticBeamColumn	30402	204023	205021	640000	32.04822928	11946666667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30403	204033	205031	640000	32.04822928	11946666667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30404	204043	205041	487500	32.04822928	7998046875	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30301	203013	204011	487500	32.04822928	7998046875	$primaryGeomTransT																																		
		element	elasticBeamColumn	30302	203023	204021	640000	32.04822928	11946666667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30303	203033	204031	640000	32.04822928	11946666667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30304	203043	204041	487500	32.04822928	7998046875	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30201	202013	203011	487500	32.04822928	7998046875	$primaryGeomTransT																																		
		element	elasticBeamColumn	30202	202023	203021	640000	32.04822928	11946666667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30203	202033	203031	640000	32.04822928	11946666667	$primaryGeomTransT																																		
		element	elasticBeamColumn	30204	202043	203041	487500	32.04822928	7998046875	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30101	201013	202011	487500	32.04822928	7998046875	$primaryGeomTransT																																		
		element	elasticBeamColumn	30102	201023	202021	640000	32.04822928	13584191365	$primaryGeomTransT																																		
		element	elasticBeamColumn	30103	201033	202031	640000	32.04822928	13584191365	$primaryGeomTransT																																		
		element	elasticBeamColumn	30104	201043	202041	487500	32.04822928	7998046875	$primaryGeomTransT																																		
																																												
# 6b. Elastic Beam elements																																												
		element	elasticBeamColumn	20901	209012	209024	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20902	209022	209034	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20903	209032	209044	375000	32.04822928	7558593750	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20801	208012	208024	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20802	208022	208034	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20803	208032	208044	375000	32.04822928	7558593750	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20701	207012	207024	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20702	207022	207034	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20703	207032	207044	375000	32.04822928	7558593750	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20601	206012	206024	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20602	206022	206034	375000	32.04822928	7558593750	$primaryGeomTransT																																		
		element	elasticBeamColumn	20603	206032	206044	375000	32.04822928	7558593750	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20501	205012	205024	375000	32.04822928	7479492188	$primaryGeomTransT																																		
		element	elasticBeamColumn	20502	205022	205034	375000	32.04822928	7453125000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20503	205032	205044	375000	32.04822928	7479492188	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20401	204012	204024	375000	32.04822928	7479492188	$primaryGeomTransT																																		
		element	elasticBeamColumn	20402	204022	204034	375000	32.04822928	7453125000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20403	204032	204044	375000	32.04822928	7479492188	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20301	203012	203024	375000	32.04822928	7479492188	$primaryGeomTransT																																		
		element	elasticBeamColumn	20302	203022	203034	375000	32.04822928	7453125000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20303	203032	203044	375000	32.04822928	7479492188	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20201	202012	202024	375000	32.04822928	7479492188	$primaryGeomTransT																																		
		element	elasticBeamColumn	20202	202022	202034	375000	32.04822928	7453125000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20203	202032	202044	375000	32.04822928	7479492188	$primaryGeomTransT																																		
	################################################################																																											
																																												
# 6c. Define the column base rotational spring																																												
		#	eleID	nodeLeft	nodeRight	matID																																						
		rotSpring2D	6011	201011	201012	601																																						
		rotSpring2D	6012	201012	201013	301011																																						
																																												
		rotSpring2D	6021	201021	201022	602																																						
		rotSpring2D	6022	201022	201023	301021																																						
																																												
		rotSpring2D	6031	201031	201032	603																																						
		rotSpring2D	6032	201032	201033	301031																																						
																																												
		rotSpring2D	6041	201041	201042	604																																						
		rotSpring2D	6042	201042	201043	301041																																						
	################################################################																																											
																																												
# 6d. Define the Joint elements																																												
		#	#	$eleTag	$Nd1	$Nd2	$Nd3	$Nd4	$NdC	$Mat1	$Mat2	$Mat3	$Mat4	$MatC	$LrgDspTag																													
		element	Joint2D	40901	209011	209012	209013	209014	209015	308011	209011	49999	49999	40901	$lrgDsp																													
		element	Joint2D	40902	209021	209022	209023	209024	209025	308021	209021	49999	209012	40902	$lrgDsp																													
		element	Joint2D	40903	209031	209032	209033	209034	209035	308031	209031	49999	209022	40903	$lrgDsp																													
		element	Joint2D	40904	209041	209042	209043	209044	209045	308041	49999	49999	209032	40904	$lrgDsp																													
																																												
		element	Joint2D	40801	208011	208012	208013	208014	208015	307011	208011	308011	49999	40801	$lrgDsp																													
		element	Joint2D	40802	208021	208022	208023	208024	208025	307021	208021	308021	208012	40802	$lrgDsp																													
		element	Joint2D	40803	208031	208032	208033	208034	208035	307031	208031	308031	208022	40803	$lrgDsp																													
		element	Joint2D	40804	208041	208042	208043	208044	208045	307041	49999	308041	208032	40804	$lrgDsp																													
																																												
		element	Joint2D	40701	207011	207012	207013	207014	207015	306011	207011	307011	49999	40701	$lrgDsp																													
		element	Joint2D	40702	207021	207022	207023	207024	207025	306021	207021	307021	207012	40702	$lrgDsp																													
		element	Joint2D	40703	207031	207032	207033	207034	207035	306031	207031	307031	207022	40703	$lrgDsp																													
		element	Joint2D	40704	207041	207042	207043	207044	207045	306041	49999	307041	207032	40704	$lrgDsp																													
																																												
		element	Joint2D	40601	206011	206012	206013	206014	206015	305011	206011	306011	49999	40601	$lrgDsp																													
		element	Joint2D	40602	206021	206022	206023	206024	206025	305021	206021	306021	206012	40602	$lrgDsp																													
		element	Joint2D	40603	206031	206032	206033	206034	206035	305031	206031	306031	206022	40603	$lrgDsp																													
		element	Joint2D	40604	206041	206042	206043	206044	206045	305041	49999	306041	206032	40604	$lrgDsp																													
																																												
		element	Joint2D	40501	205011	205012	205013	205014	205015	304011	205011	305011	49999	40501	$lrgDsp																													
		element	Joint2D	40502	205021	205022	205023	205024	205025	304021	205021	305021	205012	40502	$lrgDsp																													
		element	Joint2D	40503	205031	205032	205033	205034	205035	304031	205031	305031	205022	40503	$lrgDsp																													
		element	Joint2D	40504	205041	205042	205043	205044	205045	304041	49999	305041	205032	40504	$lrgDsp																													
																																												
		element	Joint2D	40401	204011	204012	204013	204014	204015	303011	204011	304011	49999	40401	$lrgDsp																													
		element	Joint2D	40402	204021	204022	204023	204024	204025	303021	204021	304021	204012	40402	$lrgDsp																													
		element	Joint2D	40403	204031	204032	204033	204034	204035	303031	204031	304031	204022	40403	$lrgDsp																													
		element	Joint2D	40404	204041	204042	204043	204044	204045	303041	49999	304041	204032	40404	$lrgDsp																													
																																												
		element	Joint2D	40301	203011	203012	203013	203014	203015	302011	203011	303011	49999	40301	$lrgDsp																													
		element	Joint2D	40302	203021	203022	203023	203024	203025	302021	203021	303021	203012	40302	$lrgDsp																													
		element	Joint2D	40303	203031	203032	203033	203034	203035	302031	203031	303031	203022	40303	$lrgDsp																													
		element	Joint2D	40304	203041	203042	203043	203044	203045	302041	49999	303041	203032	40304	$lrgDsp																													
																																												
		element	Joint2D	40201	202011	202012	202013	202014	202015	301011	202011	302011	49999	40201	$lrgDsp																													
		element	Joint2D	40202	202021	202022	202023	202024	202025	301021	202021	302021	202012	40202	$lrgDsp																													
		element	Joint2D	40203	202031	202032	202033	202034	202035	301031	202031	302031	202022	40203	$lrgDsp																													
		element	Joint2D	40204	202041	202042	202043	202044	202045	301041	49999	302041	202032	40204	$lrgDsp																													
	################################################################																																											
																																												
# 6e. Define the leaning frame elements																																												
		element	elasticBeamColumn	5081	308	309	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																		
		element	elasticBeamColumn	5071	307	308	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																		
		element	elasticBeamColumn	5061	306	307	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																		
		element	elasticBeamColumn	5051	305	306	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																		
		element	elasticBeamColumn	5041	304	305	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																		
		element	elasticBeamColumn	5031	303	304	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																		
		element	elasticBeamColumn	5021	302	303	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																		
		element	elasticBeamColumn	5011	301	302	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																		
																																												
		## consider changing nodes for connecting leaning columns from 208043 etc. to 208048 etc. This may improve the convergence.																																										
		element	truss	5092	209043	309	$A_strut	$strutMatT																																				
		element	truss	5082	208043	308	$A_strut	$strutMatT																																				
		element	truss	5072	207043	307	$A_strut	$strutMatT																																				
		element	truss	5062	206043	306	$A_strut	$strutMatT																																				
		element	truss	5052	205043	305	$A_strut	$strutMatT																																				
		element	truss	5042	204043	304	$A_strut	$strutMatT																																				
		element	truss	5032	203043	303	$A_strut	$strutMatT																																				
		element	truss	5022	202043	302	$A_strut	$strutMatT																																				
	################################################################																																											
																																												
																																												
# 7. Define Gravity Loads 																																												
																																												
	pattern Plain 1 Linear {																																											
	# 7a. udl on the beams																																											
		eleLoad -ele	20901	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20902	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20903	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20801	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20802	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20803	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20701	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20702	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20703	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20601	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20602	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20603	-type -beamUniform	-0.098873778																																							
		eleLoad -ele	20501	-type -beamUniform	-0.099872503																																							
		eleLoad -ele	20502	-type -beamUniform	-0.10020991																																							
		eleLoad -ele	20503	-type -beamUniform	-0.099872503																																							
		eleLoad -ele	20401	-type -beamUniform	-0.099872503																																							
		eleLoad -ele	20402	-type -beamUniform	-0.10020991																																							
		eleLoad -ele	20403	-type -beamUniform	-0.099872503																																							
		eleLoad -ele	20301	-type -beamUniform	-0.099872503																																							
		eleLoad -ele	20302	-type -beamUniform	-0.10020991																																							
		eleLoad -ele	20303	-type -beamUniform	-0.099872503																																							
		eleLoad -ele	20201	-type -beamUniform	-0.099872503																																							
		eleLoad -ele	20202	-type -beamUniform	-0.10020991																																							
		eleLoad -ele	20203	-type -beamUniform	-0.099872503																																							
																																												
	# 7b. Leaning Column Point Loads 																																											
		#	node	X	Y	M																																						
		load	309	0	-143.325	0																																						
		load	308	0	-143.325	0																																						
		load	307	0	-143.325	0																																						
		load	306	0	-143.325	0																																						
		load	305	0	-177.58125	0																																						
		load	304	0	-177.58125	0																																						
		load	303	0	-177.58125	0																																						
		load	302	0	-211.40625	0																																						
																																												
				}																																								
	################################################################																																											
																																												
# 8. Define Masses (kN-sec^2 / mm)																																												
																																												
	# 8a. Define small masses at all nodes as column-foundation connection																																											
		#	nodeTag	X	Y	Rotation																																						
		mass	201011	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201012	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201013	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201021	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201022	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201023	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201031	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201032	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201033	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201041	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201042	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
		mass	201043	[expr $smallMass1]	[expr $smallMass2]	[expr $smallMass3]																																						
																																												
	# 8b. Define the Building mass																																											
		#	nodeTag	X	Y	Rotation																																						
		mass	209011	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	209012	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	209013	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	209014	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	209021	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209022	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209023	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209024	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209031	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209032	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209033	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209034	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	209041	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	209042	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	209043	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	209044	0.010291837	0.010291837	[expr $smallMass3]																																						
																																												
		mass	208011	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	208012	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	208013	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	208014	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	208021	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208022	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208023	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208024	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208031	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208032	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208033	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208034	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	208041	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	208042	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	208043	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	208044	0.010291837	0.010291837	[expr $smallMass3]																																						
																																												
		mass	207011	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	207012	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	207013	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	207014	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	207021	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207022	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207023	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207024	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207031	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207032	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207033	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207034	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	207041	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	207042	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	207043	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	207044	0.010291837	0.010291837	[expr $smallMass3]																																						
																																												
		mass	206011	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	206012	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	206013	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	206014	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	206021	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206022	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206023	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206024	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206031	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206032	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206033	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206034	0.019881265	0.019881265	[expr $smallMass3]																																						
		mass	206041	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	206042	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	206043	0.010291837	0.010291837	[expr $smallMass3]																																						
		mass	206044	0.010291837	0.010291837	[expr $smallMass3]																																						
																																												
		mass	205011	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	205012	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	205013	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	205014	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	205021	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205022	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205023	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205024	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205031	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205032	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205033	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205034	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	205041	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	205042	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	205043	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	205044	0.010427301	0.010427301	[expr $smallMass3]																																						
																																												
		mass	204011	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	204012	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	204013	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	204014	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	204021	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204022	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204023	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204024	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204031	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204032	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204033	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204034	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	204041	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	204042	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	204043	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	204044	0.010427301	0.010427301	[expr $smallMass3]																																						
																																												
		mass	203011	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	203012	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	203013	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	203014	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	203021	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203022	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203023	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203024	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203031	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203032	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203033	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203034	0.020182297	0.020182297	[expr $smallMass3]																																						
		mass	203041	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	203042	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	203043	0.010427301	0.010427301	[expr $smallMass3]																																						
		mass	203044	0.010427301	0.010427301	[expr $smallMass3]																																						
																																												
		mass	202011	0.010613654	0.010613654	[expr $smallMass3]																																						
		mass	202012	0.010613654	0.010613654	[expr $smallMass3]																																						
		mass	202013	0.010613654	0.010613654	[expr $smallMass3]																																						
		mass	202014	0.010613654	0.010613654	[expr $smallMass3]																																						
		mass	202021	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202022	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202023	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202024	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202031	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202032	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202033	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202034	0.020426945	0.020426945	[expr $smallMass3]																																						
		mass	202041	0.010613654	0.010613654	[expr $smallMass3]																																						
		mass	202042	0.010613654	0.010613654	[expr $smallMass3]																																						
		mass	202043	0.010613654	0.010613654	[expr $smallMass3]																																						
		mass	202044	0.010613654	0.010613654	[expr $smallMass3]																																						
	################################################################																																											
	##################### total mass is 1.94849439347605 (kN-s^2 /mm) ##############																																											
	################################################################																																											
																																												
# 9. Define Damping																																												
																																												
	# Conventional Rayleight damping (as of now, 3-4-16, PSB)																																											
	# Define damping for all beams and all columns (i.e. elastic elements), but not on the joints b/c they have the nonlinearity in them.  This is the approach proposed by Medina.  Compute the damping paramters based on Chopra text page 457.																																											
	# Compute the circular frequencies for the fundamental period and the extended second period (which will be the two periods used for Rayleigh damping)																																											
	#    set omegaI [expr (2.0 * $pi) / $periodForRayleighDamping_1];																																											
	#    set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)];																																											
	# Compute the "a" coeffients for the matrices.  Notice that by Chopra's notation: (aZero = dampRat*alpha1Coeff)																																											
	# and (aOne = dampRat*alpha2Coeff)																																											
	# Summary: C = alpha1Coeff * dampRat * M + alpha2Coeff * dampRat * K																																											
	#    set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)];																																											
	#    set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)];																																											
	# Checks:																																											
	#    puts "alpha1Coeff is $alpha1Coeff"																																											
	#    puts "alpha2Coeff is $alpha2Coeff"																																											
	# Compute the damping coefficients from the input dampingRatio values																																											
	#   set alpha1  [expr $alpha1Coeff * $dampRat * $dampRatF]																																											
	#   set alpha2  [expr $alpha2Coeff * $dampRat * $dampRatF]																																											
		set omegaI [expr (2.0 * $pi) / $periodForRayleighDamping_1]																																										
		set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)]																																										
		set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)]																																										
		set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)]																																										
		set alpha1  [expr $alpha1Coeff * $dampRat * $dampRatF]																																										
		set alpha2  [expr $alpha2Coeff * $dampRat * $dampRatF]																																										
		set alpha2ToUse [expr 1.1 * $alpha2];   # 1.1 factor is becuase we apply to only LE elements																																										
		region 1 -eleRange  20201 30804 -rayleigh $alpha1 0 $alpha2ToUse 0;    # Initial stiffness																																										
	################################################################																																											
																																												
# 10. Define Stuffs to records etc. and few analysis options																																												
	# Define control nodes for monotonic and cyclic pushover - at top of leaning column																																											
		set poControlNodeNum 309																																										
		set poControlNodeNumCyclic 309																																										
																																												
	# Define a list of element numbers to record - record the columns or primary frame and leaning column - these are used for computing base shear and story shear																																											
		set elementNumToRecordLIST { 		30801	30802	30803	30804	5081	30701	30702	30703	30704	5071	30601	30602	30603	30604	5061	30501	30502	30503	30504	5051	30401	30402	30403	30404	5041	30301	30302	30303	30304	5031	30201	30202	30203	30204	5021	30101	30102	30103	30104	5011	}
																																												
	# Define a list of joint numbers to record - all joints of primary frame																																											
		set jointNumToRecordLIST { 		40901	40902	40903	40904	40801	40802	40803	40804	40701	40702	40703	40704	40601	40602	40603	40604	40501	40502	40503	40504	40401	40402	40403	40404	40301	40302	40303	40304	40201	40202	40203	40204	}								
																																												
	# Define a list of node numbers to record - top/bottom node of joint in left column of each floor, leaning column nodes, base spring nodes																																											
		set nodeNumToRecordLIST { 		209011	209013	309	208011	208013	308	207011	207013	307	206011	206013	306	205011	205013	305	204011	204013	304	203011	203013	303	202011	202013	302	201012	201013	201022	201023	201032	201033	201042	201043	}								
																																												
	# Define a list of hinge elements to record - these are the springs at the base of the columns (elastic foundation + column PH)																																											
		set hingeElementsToRecordLIST  { 		6011	6012	6021	6022	6031	6032	6041	6042	}																																
																																												
	# Define a list of column numbers at the base of the frame (including the leaning column); this is for base shear calculations																																											
		set columnNumsAtBaseLIST { 		30101	30102	30103	30104	5011	}																																			
																																												
	# Define a list of column numbers at each story (including the leaning column); this is for story shear calculations																																											
		 set columnNumsAtEachStoryLIST {	{	30101	30102	30103	30104	5011	}																																			
			{	30201	30202	30203	30204	5021	}																																			
			{	30301	30302	30303	30304	5031	}																																			
			{	30401	30402	30403	30404	5041	}																																			
			{	30501	30502	30503	30504	5051	}																																			
			{	30601	30602	30603	30604	5061	}																																			
			{	30701	30702	30703	30704	5071	}																																			
			{	30801	30802	30803	30804	5081	}	}																																		
																																												
	# Define a list of heights of each floor (for computing story drifts)																																											
		set floorHeightsLIST {	0	4500	8400	12300	16200	20100	24000	27900	31800	}																																
																																												
	# Define a list of the node numbers at each floor (always use node 3 of the joint because it is at the slab level and we measure all height to there)																																											
		set nodeNumsAtEachFloorLIST {	-1	202013	203013	204013	205013	206013	207013	208013	209013	}																																
																																												
																																												
	#####################################################################################																																											
	#####################################################################################																																											
	###### END OF THE CODE WRITTEN BY VBA USING THE DEISGN DATA #########################																																											
	#####################################################################################																																											
	#####################################################################################																																											
