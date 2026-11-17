# 1. Shear Panel Material 																																																																
	# Define Joint Shear Panel Materials																																																															
		#	Elastic	matTag	Force-Defo_Slope																																																											
		uniaxialMaterial	Elastic	41301	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41302	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41303	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41304	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	41201	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41202	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41203	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41204	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	41101	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41102	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41103	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41104	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	41001	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41002	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41003	2811454575.82959																																																											
		uniaxialMaterial	Elastic	41004	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	40901	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40902	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40903	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40904	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	40801	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40802	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40803	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40804	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	40701	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40702	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40703	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40704	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	40601	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40602	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40603	2811454575.82959																																																											
		uniaxialMaterial	Elastic	40604	2811454575.82959																																																											
																																																																
		uniaxialMaterial	Elastic	40501	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40502	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40503	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40504	4242135602.58311																																																											
																																																																
		uniaxialMaterial	Elastic	40401	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40402	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40403	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40404	4242135602.58311																																																											
																																																																
		uniaxialMaterial	Elastic	40301	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40302	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40303	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40304	4242135602.58311																																																											
																																																																
		uniaxialMaterial	Elastic	40201	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40202	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40203	4242135602.58311																																																											
		uniaxialMaterial	Elastic	40204	4242135602.58311																																																											
	################################################################																																																															
																																																																
# 2a. Ibarra-Medina-Krawinkler Material for Column Joints																																																																
	# Define the Column Plastic Hinge Materials																																																															
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																																																
		CreateIbarraMaterial	312011	256323240044.253	1700639.039	-1700639.039	1.193734079	0.056943695	-0.056943695	0.1	119.029349	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	312021	256323240044.253	1803440.833	-1803440.833	1.191428257	0.055548238	-0.055548238	0.1	116.4714615	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	312031	256323240044.253	1803440.833	-1803440.833	1.191428257	0.055548238	-0.055548238	0.1	116.4714615	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	312041	256323240044.253	1166522.611	-1166522.611	1.193734079	0.020617318	-0.020617318	0.013192391	119.029349	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	311011	256323240044.253	1813685.68	-1813685.68	1.191197274	0.055410843	-0.055410843	0.1	116.2180076	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	311021	256323240044.253	2015705.17	-2015705.17	1.186599876	0.05276458	-0.05276458	0.1	111.2767312	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	311031	256323240044.253	2015705.17	-2015705.17	1.186599876	0.05276458	-0.05276458	0.1	111.2767312	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	311041	256323240044.253	1267908.233	-1267908.233	1.191197274	0.020220712	-0.020220712	0.012381774	116.2180076	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	310011	256323240044.253	1925355.788	-1925355.788	1.188665861	0.053933146	-0.053933146	0.1	113.473067	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	310021	256323240044.253	2223472.293	-2223472.293	1.181791063	0.050170532	-0.050170532	0.1	106.3136905	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	310031	256323240044.253	2223472.293	-2223472.293	1.181791063	0.050170532	-0.050170532	0.1	106.3136905	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	310041	256323240044.253	1368281.318	-1368281.318	1.188665861	0.019841837	-0.019841837	0.011620965	113.473067	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	309011	256323240044.253	2035731.679	-2035731.679	1.186139827	0.052508863	-0.052508863	0.1	110.7929589	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	309021	256323240044.253	2427202.884	-2427202.884	1.177001737	0.047754733	-0.047754733	0.096863248	101.5720057	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	309031	256323240044.253	2427202.884	-2427202.884	1.177001737	0.047754733	-0.047754733	0.096863248	101.5720057	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	309041	256323240044.253	1467673.063	-1467673.063	1.186139827	0.019480106	-0.019480106	0.010906905	110.7929589	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	308011	256323240044.253	2233985.368	-2233985.368	1.183619161	0.051315894	-0.051315894	0.1	108.1761519	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	308021	256323240044.253	2709759.073	-2709759.073	1.172231821	0.045672675	-0.045672675	0.085819855	97.04180434	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	308031	256323240044.253	2709759.073	-2709759.073	1.172231821	0.045672675	-0.045672675	0.085819855	97.04180434	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	308041	256323240044.253	1650651.322	-1650651.322	1.183619161	0.019305351	-0.019305351	0.010236721	108.1761519	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	307011	256323240044.253	2340399.76	-2340399.76	1.181103852	0.049990204	-0.049990204	0.1	105.621151	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	307021	271628895310.517	2904126.051	-2904126.051	1.167481236	0.043247044	-0.043247044	0.076035521	92.71365394	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	307031	271628895310.517	2904126.051	-2904126.051	1.167481236	0.043247044	-0.043247044	0.076035521	92.71365394	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	307041	256323240044.253	1746866.372	-1746866.372	1.181103852	0.018973594	-0.018973594	0.009607717	105.621151	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	306011	256323240044.253	2445805.069	-2445805.069	1.178593888	0.048713154	-0.048713154	0.1	103.1264964	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	306021	296638636030.2	3095631.565	-3095631.565	1.162749902	0.040781193	-0.040781193	0.067366701	88.57854288	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	306031	296638636030.2	3095631.565	-3095631.565	1.162749902	0.040781193	-0.040781193	0.067366701	88.57854288	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	306041	256323240044.253	1842265.219	-1842265.219	1.178593888	0.018657487	-0.018657487	0.009017363	103.1264964	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	305011	256323240044.253	2633905.083	-2633905.083	1.176089258	0.047651796	-0.047651796	0.094649585	100.6907628	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	305021	321648376749.883	3359815.51	-3359815.51	1.158037743	0.03859701	-0.03859701	0.059686213	84.62786143	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	305031	321648376749.883	3359815.51	-3359815.51	1.158037743	0.03859701	-0.03859701	0.059686213	84.62786143	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	305041	256323240044.253	2016875.878	-2016875.878	1.176089258	0.018517774	-0.018517774	0.008463283	100.6907628	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	304011	430535411397.406	3197075.024	-3197075.024	1.17883512	0.04484034	-0.04484034	0.088973694	107.8988244	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	304021	466863822603.522	4146624.421	-4146624.421	1.163252463	0.037850502	-0.037850502	0.059840098	92.91480637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	304031	466863822603.522	4146624.421	-4146624.421	1.163252463	0.037850502	-0.037850502	0.059840098	92.91480637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	304041	430535411397.406	2499208.026	-2499208.026	1.17883512	0.017991426	-0.017991426	0.009072542	107.8988244	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	303011	430535411397.406	3319478.642	-3319478.642	1.176865252	0.043922885	-0.043922885	0.084646792	105.8902492	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	303021	499459377965.908	4364143.006	-4364143.006	1.159592865	0.036168047	-0.036168047	0.054475364	89.68287887	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	303031	499459377965.908	4364143.006	-4364143.006	1.159592865	0.036168047	-0.036168047	0.054475364	89.68287887	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	303041	430535411397.406	2612132.087	-2612132.087	1.176865252	0.017737783	-0.017737783	0.008631333	105.8902492	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	302011	430535411397.406	3440933.41	-3440933.41	1.174898676	0.04303192	-0.04303192	0.080530314	103.9190644	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	302021	532054933328.294	4579216.645	-4579216.645	1.15594478	0.034570079	-0.034570079	0.049591586	86.56337	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	302031	532054933328.294	4579216.645	-4579216.645	1.15594478	0.034570079	-0.034570079	0.049591586	86.56337	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
		CreateIbarraMaterial	302041	430535411397.406	2724246.758	-2724246.758	1.174898676	0.01749327	-0.01749327	0.008211581	103.9190644	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3100																																																
																																																																
		CreateIbarraMaterial	301011	430535411397.406	4534534.335	-4534534.335	1.172891371	0.045312957	-0.045312957	0.076528368	101.9415822	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3700																																																
		CreateIbarraMaterial	301021	604112493551.818	5665909.611	-5665909.611	1.15226493	0.035150653	-0.035150653	0.045095169	83.51714781	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3700																																																
		CreateIbarraMaterial	301031	604112493551.818	5665909.611	-5665909.611	1.15226493	0.035150653	-0.035150653	0.045095169	83.51714781	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3700																																																
		CreateIbarraMaterial	301041	430535411397.406	3369874.413	-3369874.413	1.172891371	0.018673385	-0.018673385	0.007803507	101.9415822	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3700																																																
	################################################################																																																															
																																																																
# 2b. Ibarra-Medina-Krawinkler Material for Beam Joints																																																																
	# Define the Beam Plastic Hinge Materials																																																															
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																																																
		CreateIbarraMaterial	213011	272837258605.932	608485.1052	-881053.3398	1.196276286	0.039169978	-0.035078493	0.1	101.4658505	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	213012	272837258605.932	881053.3398	-608485.1052	1.196276286	0.035078493	-0.039169978	0.1	101.4658505	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	213021	272837258605.932	608485.1052	-881053.3398	1.196276286	0.039169978	-0.035078493	0.1	101.4658505	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	213022	272837258605.932	881053.3398	-608485.1052	1.196276286	0.035078493	-0.039169978	0.1	101.4658505	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	213031	272837258605.932	608485.1052	-881053.3398	1.196276286	0.039169978	-0.035078493	0.1	101.4658505	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	213032	272837258605.932	881053.3398	-608485.1052	1.196276286	0.035078493	-0.039169978	0.1	101.4658505	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	212011	272837258605.932	740261.1853	-1394142.536	1.196276286	0.050875642	-0.042791086	0.1	110.9986338	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	212012	272837258605.932	1394142.536	-740261.1853	1.196276286	0.042791086	-0.050875642	0.1	110.9986338	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	212021	272837258605.932	740261.1853	-1394142.536	1.196276286	0.050875642	-0.042791086	0.1	110.9986338	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	212022	272837258605.932	1394142.536	-740261.1853	1.196276286	0.042791086	-0.050875642	0.1	110.9986338	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	212031	272837258605.932	740261.1853	-1394142.536	1.196276286	0.050875642	-0.042791086	0.1	110.9986338	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	212032	272837258605.932	1394142.536	-740261.1853	1.196276286	0.042791086	-0.050875642	0.1	110.9986338	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	211011	272837258605.932	994677.9775	-1907393.619	1.196276286	0.066443582	-0.056482949	0.1	118.0374729	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	211012	272837258605.932	1907393.619	-994677.9775	1.196276286	0.056482949	-0.066443582	0.1	118.0374729	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	211021	272837258605.932	994677.9775	-1907393.619	1.196276286	0.066443582	-0.056482949	0.1	118.0374729	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	211022	272837258605.932	1907393.619	-994677.9775	1.196276286	0.056482949	-0.066443582	0.1	118.0374729	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	211031	272837258605.932	994677.9775	-1907393.619	1.196276286	0.066443582	-0.056482949	0.1	118.0374729	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	211032	272837258605.932	1907393.619	-994677.9775	1.196276286	0.056482949	-0.066443582	0.1	118.0374729	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	210011	272837258605.932	1284948.836	-2349095.07	1.196276286	0.077049209	-0.067299627	0.1	125.5226712	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	210012	272837258605.932	2349095.07	-1284948.836	1.196276286	0.067299627	-0.077049209	0.1	125.5226712	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	210021	272837258605.932	1284948.836	-2349095.07	1.196276286	0.077049209	-0.067299627	0.1	125.5226712	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	210022	272837258605.932	2349095.07	-1284948.836	1.196276286	0.067299627	-0.077049209	0.1	125.5226712	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	210031	272837258605.932	1284948.836	-2349095.07	1.196276286	0.077049209	-0.067299627	0.1	125.5226712	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	210032	272837258605.932	2349095.07	-1284948.836	1.196276286	0.067299627	-0.077049209	0.1	125.5226712	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	209011	272837258605.932	1613361.897	-2670105.63	1.196276286	0.083509176	-0.075558919	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	209012	272837258605.932	2670105.63	-1613361.897	1.196276286	0.075558919	-0.083509176	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	209021	272837258605.932	1613361.897	-2670105.63	1.196276286	0.083509176	-0.075558919	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	209022	272837258605.932	2670105.63	-1613361.897	1.196276286	0.075558919	-0.083509176	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	209031	272837258605.932	1613361.897	-2670105.63	1.196276286	0.083509176	-0.075558919	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	209032	272837258605.932	2670105.63	-1613361.897	1.196276286	0.075558919	-0.083509176	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	208011	272837258605.932	1940706.63	-2991403.004	1.196276286	0.084997509	-0.079147403	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	208012	272837258605.932	2991403.004	-1940706.63	1.196276286	0.079147403	-0.084997509	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	208021	272837258605.932	1940706.63	-2991403.004	1.196276286	0.084997509	-0.079147403	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	208022	272837258605.932	2991403.004	-1940706.63	1.196276286	0.079147403	-0.084997509	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	208031	272837258605.932	1940706.63	-2991403.004	1.196276286	0.084997509	-0.079147403	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	208032	272837258605.932	2991403.004	-1940706.63	1.196276286	0.079147403	-0.084997509	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	207011	272837258605.932	2068867.233	-3185086.459	1.196276286	0.075811254	-0.071846466	0.1	121.7225488	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	207012	272837258605.932	3185086.459	-2068867.233	1.196276286	0.071846466	-0.075811254	0.1	121.7225488	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	207021	272837258605.932	2068867.233	-3185086.459	1.196276286	0.075811254	-0.071846466	0.1	121.7225488	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	207022	272837258605.932	3185086.459	-2068867.233	1.196276286	0.071846466	-0.075811254	0.1	121.7225488	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	207031	272837258605.932	2068867.233	-3185086.459	1.196276286	0.075811254	-0.071846466	0.1	121.7225488	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	207032	272837258605.932	3185086.459	-2068867.233	1.196276286	0.071846466	-0.075811254	0.1	121.7225488	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	206011	272837258605.932	2194608.621	-3189618.808	1.196276286	0.092355664	-0.087167346	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	206012	272837258605.932	3189618.808	-2194608.621	1.196276286	0.087167346	-0.092355664	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	206021	272837258605.932	2194608.621	-3189618.808	1.196276286	0.092355664	-0.087167346	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	206022	272837258605.932	3189618.808	-2194608.621	1.196276286	0.087167346	-0.092355664	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	206031	272837258605.932	2194608.621	-3189618.808	1.196276286	0.092355664	-0.087167346	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
		CreateIbarraMaterial	206032	272837258605.932	3189618.808	-2194608.621	1.196276286	0.087167346	-0.092355664	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7450																																																
																																																																
		CreateIbarraMaterial	205011	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	205012	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	205021	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	205022	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	205031	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	205032	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
																																																																
		CreateIbarraMaterial	204011	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	204012	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	204021	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	204022	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	204031	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	204032	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
																																																																
		CreateIbarraMaterial	203011	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	203012	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	203021	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	203022	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	203031	268991471092.301	2319988.406	-3193977.304	1.196276286	0.092402749	-0.088139381	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	203032	268991471092.301	3193977.304	-2319988.406	1.196276286	0.088139381	-0.092402749	0.1	133.4825339	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
																																																																
		CreateIbarraMaterial	202011	268991471092.301	1937859.134	-2748951.441	1.196276286	0.083492244	-0.078514429	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	202012	268991471092.301	2748951.441	-1937859.134	1.196276286	0.078514429	-0.083492244	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	202021	268991471092.301	1937859.134	-2748951.441	1.196276286	0.083492244	-0.078514429	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	202022	268991471092.301	2748951.441	-1937859.134	1.196276286	0.078514429	-0.083492244	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	202031	268991471092.301	1937859.134	-2748951.441	1.196276286	0.083492244	-0.078514429	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
		CreateIbarraMaterial	202032	268991471092.301	2748951.441	-1937859.134	1.196276286	0.078514429	-0.083492244	0.1	129.4414316	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7350																																																
	################################################################																																																															
																																																																
# 3. Footing rotational stiffness																																																																
	# Define the Elastic Footing Rotational Stiffness Materials (this is supposed to include link beam and footing-soil stiffness)																																																															
		#	Elastic	matTag	Force-Defo_Slope																																																											
		uniaxialMaterial	Elastic	601	42181642577.39																																																											
		uniaxialMaterial	Elastic	602	144250059919.73																																																											
		uniaxialMaterial	Elastic	603	144250059919.73																																																											
		uniaxialMaterial	Elastic	604	42181642577.39																																																										
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
		node	202011	0	3700																																																											
		node	202012	425	4100																																																											
		node	202013	0	4500																																																											
		node	202014	-425	4100																																																											
		node	202021	8200	3700																																																											
		node	202022	8625	4100																																																											
		node	202023	8200	4500																																																											
		node	202024	7775	4100																																																											
		node	202031	16400	3700																																																											
		node	202032	16825	4100																																																											
		node	202033	16400	4500																																																											
		node	202034	15975	4100																																																											
		node	202041	24600	3700																																																											
		node	202042	25025	4100																																																											
		node	202043	24600	4500																																																											
		node	202044	24175	4100																																																											
																																																																
		node	203011	0	7600																																																											
		node	203012	425	8000																																																											
		node	203013	0	8400																																																											
		node	203014	-425	8000																																																											
		node	203021	8200	7600																																																											
		node	203022	8625	8000																																																											
		node	203023	8200	8400																																																											
		node	203024	7775	8000																																																											
		node	203031	16400	7600																																																											
		node	203032	16825	8000																																																											
		node	203033	16400	8400																																																											
		node	203034	15975	8000																																																											
		node	203041	24600	7600																																																											
		node	203042	25025	8000																																																											
		node	203043	24600	8400																																																											
		node	203044	24175	8000																																																											
																																																																
		node	204011	0	11500																																																											
		node	204012	425	11900																																																											
		node	204013	0	12300																																																											
		node	204014	-425	11900																																																											
		node	204021	8200	11500																																																											
		node	204022	8625	11900																																																											
		node	204023	8200	12300																																																											
		node	204024	7775	11900																																																											
		node	204031	16400	11500																																																											
		node	204032	16825	11900																																																											
		node	204033	16400	12300																																																											
		node	204034	15975	11900																																																											
		node	204041	24600	11500																																																											
		node	204042	25025	11900																																																											
		node	204043	24600	12300																																																											
		node	204044	24175	11900																																																											
																																																																
		node	205011	0	15400																																																											
		node	205012	425	15800																																																											
		node	205013	0	16200																																																											
		node	205014	-425	15800																																																											
		node	205021	8200	15400																																																											
		node	205022	8625	15800																																																											
		node	205023	8200	16200																																																											
		node	205024	7775	15800																																																											
		node	205031	16400	15400																																																											
		node	205032	16825	15800																																																											
		node	205033	16400	16200																																																											
		node	205034	15975	15800																																																											
		node	205041	24600	15400																																																											
		node	205042	25025	15800																																																											
		node	205043	24600	16200																																																											
		node	205044	24175	15800																																																											
																																																																
		node	206011	0	19300																																																											
		node	206012	375	19700																																																											
		node	206013	0	20100																																																											
		node	206014	-375	19700																																																											
		node	206021	8200	19300																																																											
		node	206022	8575	19700																																																											
		node	206023	8200	20100																																																											
		node	206024	7825	19700																																																											
		node	206031	16400	19300																																																											
		node	206032	16775	19700																																																											
		node	206033	16400	20100																																																											
		node	206034	16025	19700																																																											
		node	206041	24600	19300																																																											
		node	206042	24975	19700																																																											
		node	206043	24600	20100																																																											
		node	206044	24225	19700																																																											
																																																																
		node	207011	0	23200																																																											
		node	207012	375	23600																																																											
		node	207013	0	24000																																																											
		node	207014	-375	23600																																																											
		node	207021	8200	23200																																																											
		node	207022	8575	23600																																																											
		node	207023	8200	24000																																																											
		node	207024	7825	23600																																																											
		node	207031	16400	23200																																																											
		node	207032	16775	23600																																																											
		node	207033	16400	24000																																																											
		node	207034	16025	23600																																																											
		node	207041	24600	23200																																																											
		node	207042	24975	23600																																																											
		node	207043	24600	24000																																																											
		node	207044	24225	23600																																																											
																																																																
		node	208011	0	27100																																																											
		node	208012	375	27500																																																											
		node	208013	0	27900																																																											
		node	208014	-375	27500																																																											
		node	208021	8200	27100																																																											
		node	208022	8575	27500																																																											
		node	208023	8200	27900																																																											
		node	208024	7825	27500																																																											
		node	208031	16400	27100																																																											
		node	208032	16775	27500																																																											
		node	208033	16400	27900																																																											
		node	208034	16025	27500																																																											
		node	208041	24600	27100																																																											
		node	208042	24975	27500																																																											
		node	208043	24600	27900																																																											
		node	208044	24225	27500																																																											
																																																																
		node	209011	0	31000																																																											
		node	209012	375	31400																																																											
		node	209013	0	31800																																																											
		node	209014	-375	31400																																																											
		node	209021	8200	31000																																																											
		node	209022	8575	31400																																																											
		node	209023	8200	31800																																																											
		node	209024	7825	31400																																																											
		node	209031	16400	31000																																																											
		node	209032	16775	31400																																																											
		node	209033	16400	31800																																																											
		node	209034	16025	31400																																																											
		node	209041	24600	31000																																																											
		node	209042	24975	31400																																																											
		node	209043	24600	31800																																																											
		node	209044	24225	31400																																																											
																																																																
		node	210011	0	34900																																																											
		node	210012	375	35300																																																											
		node	210013	0	35700																																																											
		node	210014	-375	35300																																																											
		node	210021	8200	34900																																																											
		node	210022	8575	35300																																																											
		node	210023	8200	35700																																																											
		node	210024	7825	35300																																																											
		node	210031	16400	34900																																																											
		node	210032	16775	35300																																																											
		node	210033	16400	35700																																																											
		node	210034	16025	35300																																																											
		node	210041	24600	34900																																																											
		node	210042	24975	35300																																																											
		node	210043	24600	35700																																																											
		node	210044	24225	35300																																																											
																																																																
		node	211011	0	38800																																																											
		node	211012	375	39200																																																											
		node	211013	0	39600																																																											
		node	211014	-375	39200																																																											
		node	211021	8200	38800																																																											
		node	211022	8575	39200																																																											
		node	211023	8200	39600																																																											
		node	211024	7825	39200																																																											
		node	211031	16400	38800																																																											
		node	211032	16775	39200																																																											
		node	211033	16400	39600																																																											
		node	211034	16025	39200																																																											
		node	211041	24600	38800																																																											
		node	211042	24975	39200																																																											
		node	211043	24600	39600																																																											
		node	211044	24225	39200																																																											
																																																																
		node	212011	0	42700																																																											
		node	212012	375	43100																																																											
		node	212013	0	43500																																																											
		node	212014	-375	43100																																																											
		node	212021	8200	42700																																																											
		node	212022	8575	43100																																																											
		node	212023	8200	43500																																																											
		node	212024	7825	43100																																																											
		node	212031	16400	42700																																																											
		node	212032	16775	43100																																																											
		node	212033	16400	43500																																																											
		node	212034	16025	43100																																																											
		node	212041	24600	42700																																																											
		node	212042	24975	43100																																																											
		node	212043	24600	43500																																																											
		node	212044	24225	43100																																																											
																																																																
		node	213011	0	46600																																																											
		node	213012	375	47000																																																											
		node	213013	0	47400																																																											
		node	213014	-375	47000																																																											
		node	213021	8200	46600																																																											
		node	213022	8575	47000																																																											
		node	213023	8200	47400																																																											
		node	213024	7825	47000																																																											
		node	213031	16400	46600																																																											
		node	213032	16775	47000																																																											
		node	213033	16400	47400																																																											
		node	213034	16025	47000																																																											
		node	213041	24600	46600																																																											
		node	213042	24975	47000																																																											
		node	213043	24600	47400																																																											
		node	213044	24225	47000																																																											
																																																																
	# Define the leaning column nodes																																																															
		node	313	32800	47400																																																											
		node	312	32800	43500																																																											
		node	311	32800	39600																																																											
		node	310	32800	35700																																																											
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
		element	elasticBeamColumn	31201	212013	213011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31202	212023	213021	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31203	212033	213031	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31204	212043	213041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	31101	211013	212011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31102	211023	212021	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31103	211033	212031	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31104	211043	212041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	31001	210013	211011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31002	210023	211021	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31003	210033	211031	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31004	210043	211041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30901	209013	210011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30902	209023	210021	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30903	209033	210031	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30904	209043	210041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30801	208013	209011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30802	208023	209021	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30803	208033	209031	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30804	208043	209041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30701	207013	208011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30702	207023	208021	487500	32.04822928	8475628807	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30703	207033	208031	487500	32.04822928	8475628807	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30704	207043	208041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30601	206013	207011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30602	206023	207021	487500	32.04822928	9256007046	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30603	206033	207031	487500	32.04822928	9256007046	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30604	206043	207041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30501	205013	206011	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30502	205023	206021	487500	32.04822928	10036385285	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30503	205033	206031	487500	32.04822928	10036385285	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30504	205043	206041	487500	32.04822928	7998046875	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30401	204013	205011	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30402	204023	205021	637500	32.04822928	14567538772	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30403	204033	205031	637500	32.04822928	14567538772	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30404	204043	205041	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30301	203013	204011	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30302	203023	204021	637500	32.04822928	15584616972	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30303	203033	204031	637500	32.04822928	15584616972	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30304	203043	204041	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30201	202013	203011	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30202	202023	203021	637500	32.04822928	16601695172	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30203	202033	203031	637500	32.04822928	16601695172	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30204	202043	203041	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30101	201013	202011	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30102	201023	202021	637500	32.04822928	18850105205	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30103	201033	202031	637500	32.04822928	18850105205	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30104	201043	202041	637500	32.04822928	13433984375	$primaryGeomTransT																																																						
																																																																
# 6b. Elastic Beam elements																																																																
		element	elasticBeamColumn	21301	213012	213024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21302	213022	213034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21303	213032	213044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	21201	212012	212024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21202	212022	212034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21203	212032	212044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	21101	211012	211024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21102	211022	211034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21103	211032	211044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	21001	210012	210024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21002	210022	210034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21003	210032	210044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20901	209012	209024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20902	209022	209034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20903	209032	209044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20801	208012	208024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20802	208022	208034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20803	208032	208044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20701	207012	207024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20702	207022	207034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20703	207032	207044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20601	206012	206024	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20602	206022	206034	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20603	206032	206044	400000	32.04822928	8513333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20501	205012	205024	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20502	205022	205034	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20503	205032	205044	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20401	204012	204024	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20402	204022	204034	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20403	204032	204044	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20301	203012	203024	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20302	203022	203034	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20303	203032	203044	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20201	202012	202024	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20202	202022	202034	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20203	202032	202044	400000	32.04822928	8393333333	$primaryGeomTransT																																																						
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
		element	Joint2D	41301	213011	213012	213013	213014	213015	312011	213011	49999	49999	41301	$lrgDsp																																																	
		element	Joint2D	41302	213021	213022	213023	213024	213025	312021	213021	49999	213012	41302	$lrgDsp																																																	
		element	Joint2D	41303	213031	213032	213033	213034	213035	312031	213031	49999	213022	41303	$lrgDsp																																																	
		element	Joint2D	41304	213041	213042	213043	213044	213045	312041	49999	49999	213032	41304	$lrgDsp																																																	
																																																																
		element	Joint2D	41201	212011	212012	212013	212014	212015	311011	212011	312011	49999	41201	$lrgDsp																																																	
		element	Joint2D	41202	212021	212022	212023	212024	212025	311021	212021	312021	212012	41202	$lrgDsp																																																	
		element	Joint2D	41203	212031	212032	212033	212034	212035	311031	212031	312031	212022	41203	$lrgDsp																																																	
		element	Joint2D	41204	212041	212042	212043	212044	212045	311041	49999	312041	212032	41204	$lrgDsp																																																	
																																																																
		element	Joint2D	41101	211011	211012	211013	211014	211015	310011	211011	311011	49999	41101	$lrgDsp																																																	
		element	Joint2D	41102	211021	211022	211023	211024	211025	310021	211021	311021	211012	41102	$lrgDsp																																																	
		element	Joint2D	41103	211031	211032	211033	211034	211035	310031	211031	311031	211022	41103	$lrgDsp																																																	
		element	Joint2D	41104	211041	211042	211043	211044	211045	310041	49999	311041	211032	41104	$lrgDsp																																																	
																																																																
		element	Joint2D	41001	210011	210012	210013	210014	210015	309011	210011	310011	49999	41001	$lrgDsp																																																	
		element	Joint2D	41002	210021	210022	210023	210024	210025	309021	210021	310021	210012	41002	$lrgDsp																																																	
		element	Joint2D	41003	210031	210032	210033	210034	210035	309031	210031	310031	210022	41003	$lrgDsp																																																	
		element	Joint2D	41004	210041	210042	210043	210044	210045	309041	49999	310041	210032	41004	$lrgDsp																																																	
																																																																
		element	Joint2D	40901	209011	209012	209013	209014	209015	308011	209011	309011	49999	40901	$lrgDsp																																																	
		element	Joint2D	40902	209021	209022	209023	209024	209025	308021	209021	309021	209012	40902	$lrgDsp																																																	
		element	Joint2D	40903	209031	209032	209033	209034	209035	308031	209031	309031	209022	40903	$lrgDsp																																																	
		element	Joint2D	40904	209041	209042	209043	209044	209045	308041	49999	309041	209032	40904	$lrgDsp																																																	
																																																																
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
		element	elasticBeamColumn	5121	312	313	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5111	311	312	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5101	310	311	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5091	309	310	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5081	308	309	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5071	307	308	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5061	306	307	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5051	305	306	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5041	304	305	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5031	303	304	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5021	302	303	$A_strut	$E_strut	$I_strut	$primaryGeomTransT																																																						
		element	elasticBeamColumn	5011	301	302	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT																																																						
																																																																
		## consider changing nodes for connecting leaning columns from 208043 etc. to 208048 etc. This may improve the convergence.																																																														
		element	truss	5132	213043	313	$A_strut	$strutMatT																																																								
		element	truss	5122	212043	312	$A_strut	$strutMatT																																																								
		element	truss	5112	211043	311	$A_strut	$strutMatT																																																								
		element	truss	5102	210043	310	$A_strut	$strutMatT																																																								
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
		eleLoad -ele	21301	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21302	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21303	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21201	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21202	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21203	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21101	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21102	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21103	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21001	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21002	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	21003	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20901	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20902	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20903	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20801	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20802	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20803	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20701	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20702	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20703	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20601	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20602	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20603	-type -beamUniform	-0.101142506																																																											
		eleLoad -ele	20501	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20502	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20503	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20401	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20402	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20403	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20301	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20302	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20303	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20201	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20202	-type -beamUniform	-0.102518594																																																											
		eleLoad -ele	20203	-type -beamUniform	-0.102518594																																																											
																																																																
	# 7b. Leaning Column Point Loads 																																																															
		#	node	X	Y	M																																																										
		load	313	0	-151.125	0																																																										
		load	312	0	-151.125	0																																																										
		load	311	0	-151.125	0																																																										
		load	310	0	-151.125	0																																																										
		load	309	0	-151.125	0																																																										
		load	308	0	-151.125	0																																																										
		load	307	0	-151.125	0																																																										
		load	306	0	-151.125	0																																																										
		load	305	0	-197.625	0																																																										
		load	304	0	-197.625	0																																																										
		load	303	0	-197.625	0																																																										
		load	302	0	-235.875	0																																																										
																																																																
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
		mass	213011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	213012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	213013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	213014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	213021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	213041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	213042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	213043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	213044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	212011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	212012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	212013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	212014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	212021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	212041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	212042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	212043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	212044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	211011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	211012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	211013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	211014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	211021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	211041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	211042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	211043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	211044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	210011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	210012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	210013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	210014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	210021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	210041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	210042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	210043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	210044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	209011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	209012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	209013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	209014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	209021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	209041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	209042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	209043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	209044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	208011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	208012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	208013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	208014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	208021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	208041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	208042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	208043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	208044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	207011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	207012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	207013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	207014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	207021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	207041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	207042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	207043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	207044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	206011	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	206012	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	206013	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	206014	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	206021	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206022	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206023	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206024	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206031	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206032	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206033	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206034	0.020165467	0.020165467	[expr $smallMass3]																																																										
		mass	206041	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	206042	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	206043	0.010564146	0.010564146	[expr $smallMass3]																																																										
		mass	206044	0.010564146	0.010564146	[expr $smallMass3]																																																										
																																																																
		mass	205011	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	205012	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	205013	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	205014	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	205021	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205022	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205023	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205024	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205031	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205032	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205033	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205034	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	205041	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	205042	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	205043	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	205044	0.0108604	0.0108604	[expr $smallMass3]																																																										
																																																																
		mass	204011	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	204012	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	204013	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	204014	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	204021	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204022	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204023	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204024	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204031	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204032	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204033	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204034	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	204041	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	204042	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	204043	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	204044	0.0108604	0.0108604	[expr $smallMass3]																																																										
																																																																
		mass	203011	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	203012	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	203013	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	203014	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	203021	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203022	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203023	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203024	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203031	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203032	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203033	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203034	0.020461721	0.020461721	[expr $smallMass3]																																																										
		mass	203041	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	203042	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	203043	0.0108604	0.0108604	[expr $smallMass3]																																																										
		mass	203044	0.0108604	0.0108604	[expr $smallMass3]																																																										
																																																																
		mass	202011	0.011104092	0.011104092	[expr $smallMass3]																																																										
		mass	202012	0.011104092	0.011104092	[expr $smallMass3]																																																										
		mass	202013	0.011104092	0.011104092	[expr $smallMass3]																																																										
		mass	202014	0.011104092	0.011104092	[expr $smallMass3]																																																										
		mass	202021	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202022	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202023	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202024	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202031	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202032	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202033	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202034	0.020705413	0.020705413	[expr $smallMass3]																																																										
		mass	202041	0.011104092	0.011104092	[expr $smallMass3]																																																										
		mass	202042	0.011104092	0.011104092	[expr $smallMass3]																																																										
		mass	202043	0.011104092	0.011104092	[expr $smallMass3]																																																										
		mass	202044	0.011104092	0.011104092	[expr $smallMass3]																																																										
	################################################################																																																															
	##################### total mass is 2.97290214067279 (kN-s^2 /mm) ##############																																																															
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
		region 1 -eleRange  20201 31204 -rayleigh $alpha1 0 $alpha2ToUse 0;    # Initial stiffness																																																														
	################################################################																																																															
																																																																
# 10. Define Stuffs to records etc. and few analysis options																																																																
	# Define control nodes for monotonic and cyclic pushover - at top of leaning column																																																															
		set poControlNodeNum 313																																																														
		set poControlNodeNumCyclic 313																																																														
																																																																
	# Define a list of element numbers to record - record the columns or primary frame and leaning column - these are used for computing base shear and story shear																																																															
		set elementNumToRecordLIST { 		31201	31202	31203	31204	5121	31101	31102	31103	31104	5111	31001	31002	31003	31004	5101	30901	30902	30903	30904	5091	30801	30802	30803	30804	5081	30701	30702	30703	30704	5071	30601	30602	30603	30604	5061	30501	30502	30503	30504	5051	30401	30402	30403	30404	5041	30301	30302	30303	30304	5031	30201	30202	30203	30204	5021	30101	30102	30103	30104	5011	}
																																																																
	# Define a list of joint numbers to record - all joints of primary frame																																																															
		set jointNumToRecordLIST { 		41301	41302	41303	41304	41201	41202	41203	41204	41101	41102	41103	41104	41001	41002	41003	41004	40901	40902	40903	40904	40801	40802	40803	40804	40701	40702	40703	40704	40601	40602	40603	40604	40501	40502	40503	40504	40401	40402	40403	40404	40301	40302	40303	40304	40201	40202	40203	40204	}												
																																																																
	# Define a list of node numbers to record - top/bottom node of joint in left column of each floor, leaning column nodes, base spring nodes																																																															
		set nodeNumToRecordLIST { 		213011	213013	313	212011	212013	312	211011	211013	311	210011	210013	310	209011	209013	309	208011	208013	308	207011	207013	307	206011	206013	306	205011	205013	305	204011	204013	304	203011	203013	303	202011	202013	302	201012	201013	201022	201023	201032	201033	201042	201043	}																
																																																																
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
			{	30801	30802	30803	30804	5081	}																																																							
			{	30901	30902	30903	30904	5091	}																																																							
			{	31001	31002	31003	31004	5101	}																																																							
			{	31101	31102	31103	31104	5111	}																																																							
			{	31201	31202	31203	31204	5121	}	}																																																						
																																																																
	# Define a list of heights of each floor (for computing story drifts)																																																															
		set floorHeightsLIST {	0	4500	8400	12300	16200	20100	24000	27900	31800	35700	39600	43500	47400	}																																																
																																																																
	# Define a list of the node numbers at each floor (always use node 3 of the joint because it is at the slab level and we measure all height to there)																																																															
		set nodeNumsAtEachFloorLIST {	-1	202013	203013	204013	205013	206013	207013	208013	209013	210013	211013	212013	213013	}																																																
																																																																
																																																																
	#####################################################################################																																																															
	#####################################################################################																																																															
	###### END OF THE CODE WRITTEN BY VBA USING THE DEISGN DATA #########################																																																															
	#####################################################################################																																																															
	#####################################################################################																																																															
