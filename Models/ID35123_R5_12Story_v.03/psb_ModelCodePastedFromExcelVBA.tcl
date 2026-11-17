# 1. Shear Panel Material 																																																																
	# Define Joint Shear Panel Materials																																																															
		#	Elastic	matTag	Force-Defo_Slope																																																											
		uniaxialMaterial	Elastic	41301	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41302	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41303	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41304	1078001517.83288																																																											
																																																																
		uniaxialMaterial	Elastic	41201	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41202	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41203	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41204	1078001517.83288																																																											
																																																																
		uniaxialMaterial	Elastic	41101	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41102	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41103	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41104	1078001517.83288																																																											
																																																																
		uniaxialMaterial	Elastic	41001	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41002	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41003	1078001517.83288																																																											
		uniaxialMaterial	Elastic	41004	1078001517.83288																																																											
																																																																
		uniaxialMaterial	Elastic	40901	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40902	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40903	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40904	1441771577.34851																																																											
																																																																
		uniaxialMaterial	Elastic	40801	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40802	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40803	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40804	1441771577.34851																																																											
																																																																
		uniaxialMaterial	Elastic	40701	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40702	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40703	1441771577.34851																																																											
		uniaxialMaterial	Elastic	40704	1441771577.34851																																																											
																																																																
		uniaxialMaterial	Elastic	40601	1878739270.79105																																																											
		uniaxialMaterial	Elastic	40602	1878739270.79105																																																											
		uniaxialMaterial	Elastic	40603	1878739270.79105																																																											
		uniaxialMaterial	Elastic	40604	1878739270.79105																																																											
																																																																
		uniaxialMaterial	Elastic	40501	1878739270.79105																																																											
		uniaxialMaterial	Elastic	40502	1878739270.79105																																																											
		uniaxialMaterial	Elastic	40503	1878739270.79105																																																											
		uniaxialMaterial	Elastic	40504	1878739270.79105																																																											
																																																																
		uniaxialMaterial	Elastic	40401	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40402	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40403	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40404	2555262857.08535																																																											
																																																																
		uniaxialMaterial	Elastic	40301	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40302	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40303	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40304	2555262857.08535																																																											
																																																																
		uniaxialMaterial	Elastic	40201	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40202	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40203	2555262857.08535																																																											
		uniaxialMaterial	Elastic	40204	2555262857.08535																																																											
	################################################################																																																															
																																																																
# 2a. Ibarra-Medina-Krawinkler Material for Column Joints																																																																
	# Define the Column Plastic Hinge Materials																																																															
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																																																
		CreateIbarraMaterial	312011	90856730009.532	1042971.553	-1042971.553	1.192060318	0.049139159	-0.049139159	0.1	106.8955943	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	312021	90856730009.532	1116412.925	-1116412.925	1.188096974	0.047375368	-0.047375368	0.095314931	102.9696464	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	312031	90856730009.532	1116412.925	-1116412.925	1.188096974	0.047375368	-0.047375368	0.095314931	102.9696464	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	312041	90856730009.532	732174.3612	-732174.3612	1.192060318	0.020642828	-0.020642828	0.012651995	106.8955943	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	311011	90856730009.532	1120795.648	-1120795.648	1.187859208	0.047272813	-0.047272813	0.094747965	102.7383538	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	311021	90856730009.532	1264779.499	-1264779.499	1.179973587	0.044071235	-0.044071235	0.077685799	95.33040395	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	311031	90856730009.532	1264779.499	-1264779.499	1.179973587	0.044071235	-0.044071235	0.077685799	95.33040395	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	311041	90856730009.532	801070.5114	-801070.5114	1.187859208	0.020164524	-0.020164524	0.011388167	102.7383538	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	310011	90856730009.532	1197555.417	-1197555.417	1.183672903	0.045525686	-0.045525686	0.085283441	98.74279117	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	310021	102042240765.529	1409608.874	-1409608.874	1.171905743	0.040266322	-0.040266322	0.063317292	88.25791129	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	310031	102042240765.529	1409608.874	-1409608.874	1.171905743	0.040266322	-0.040266322	0.063317292	88.25791129	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	310041	90856730009.532	869164.6263	-869164.6263	1.183672903	0.019729185	-0.019729185	0.010250585	98.74279117	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	309011	90856730009.532	1273322.206	-1273322.206	1.179501353	0.04389142	-0.04389142	0.076764343	94.90261861	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	309021	117019672828.233	1551318.703	-1551318.703	1.16389306	0.036604499	-0.036604499	0.051606337	81.71012166	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	309031	117019672828.233	1551318.703	-1551318.703	1.16389306	0.036604499	-0.036604499	0.051606337	81.71012166	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	309041	90856730009.532	936488.3263	-936488.3263	1.179501353	0.019334422	-0.019334422	0.009226638	94.90261861	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	308011	128351489088.826	1493633.065	-1493633.065	1.178820954	0.040466798	-0.040466798	0.068729189	97.79042389	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	308021	161900748733.438	1873434.657	-1873434.657	1.162625833	0.033733653	-0.033733653	0.04550423	83.7131916	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	308031	161900748733.438	1873434.657	-1873434.657	1.162625833	0.033733653	-0.033733653	0.04550423	83.7131916	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	308041	128351489088.826	1122832.838	-1122832.838	1.178820954	0.018377858	-0.018377858	0.009069293	97.79042389	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	307011	128388177899.814	1576693.341	-1576693.341	1.175328723	0.039248316	-0.039248316	0.062911825	94.58433706	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	307021	179582884307.696	2025814.024	-2025814.024	1.155978869	0.031202133	-0.031202133	0.038355261	78.49035796	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	307031	179582884307.696	2025814.024	-2025814.024	1.155978869	0.031202133	-0.031202133	0.038355261	78.49035796	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	307041	128388177899.814	1197786.559	-1197786.559	1.175328723	0.018062822	-0.018062822	0.008301651	94.58433706	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	306011	137537862406.092	1658831.853	-1658831.853	1.171846839	0.037640554	-0.037640554	0.057586853	91.48336269	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	306021	197265019881.954	2126604.767	-2126604.767	1.149369908	0.028763838	-0.028763838	0.032329435	73.59337489	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	306031	197265019881.954	2126604.767	-2126604.767	1.149369908	0.028763838	-0.028763838	0.032329435	73.59337489	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	306041	137537862406.092	1271979.04	-1271979.04	1.171846839	0.01742294	-0.01742294	0.007598984	91.48336269	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	305011	178106807590.182	1911607.848	-1911607.848	1.172643708	0.035886717	-0.035886717	0.054068466	95.06248983	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	305021	257271797380.675	2523896.211	-2523896.211	1.150936969	0.02771542	-0.02771542	0.030978259	77.0614317	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	305031	257271797380.675	2523896.211	-2523896.211	1.150936969	0.02771542	-0.02771542	0.030978259	77.0614317	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	305041	178106807590.182	1491738.179	-1491738.179	1.172643708	0.01709175	-0.01709175	0.007754538	95.06248983	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	304011	188850431955.85	2001307.41	-2001307.41	1.169674007	0.034635303	-0.034635303	0.050132241	92.39235825	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	304021	277911045470.154	2595519.336	-2595519.336	1.145344104	0.025806308	-0.025806308	0.026791325	72.95707717	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	304031	277911045470.154	2595519.336	-2595519.336	1.145344104	0.025806308	-0.025806308	0.026791325	72.95707717	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	304041	188850431955.85	1573765.514	-1573765.514	1.169674007	0.016575763	-0.016575763	0.007190002	92.39235825	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	303011	287152134351.114	2454352.928	-2454352.928	1.172458108	0.033409286	-0.033409286	0.049924087	99.65666173	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	303021	399275508799.558	3255601.88	-3255601.88	1.150698814	0.025837763	-0.025837763	0.0285623	80.74149682	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	303031	399275508799.558	3255601.88	-3255601.88	1.150698814	0.025837763	-0.025837763	0.0285623	80.74149682	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	303041	287152134351.114	1961882.557	-1961882.557	1.172458108	0.016237259	-0.016237259	0.007718036	99.65666173	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	302011	287152134351.114	2559964.539	-2559964.539	1.170029593	0.032679888	-0.032679888	0.046931819	97.36183771	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	302021	426506196147.941	3508837.067	-3508837.067	1.146166235	0.024583591	-0.024583591	0.025392106	77.23928943	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	302031	426506196147.941	3508837.067	-3508837.067	1.146166235	0.024583591	-0.024583591	0.025392106	77.23928943	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
		CreateIbarraMaterial	302041	287152134351.114	2059731.472	-2059731.472	1.170029593	0.01601499	-0.01601499	0.007255445	97.36183771	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																																																
																																																																
		CreateIbarraMaterial	301011	326586715854.763	2666516.125	-2666516.125	1.167562291	0.03218445	-0.03218445	0.044069571	95.07975939	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																																																
		CreateIbarraMaterial	301021	481685471362.667	3534547.844	-3534547.844	1.141608667	0.023616651	-0.023616651	0.022548542	73.85784424	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																																																
		CreateIbarraMaterial	301031	481685471362.667	3534547.844	-3534547.844	1.141608667	0.023616651	-0.023616651	0.022548542	73.85784424	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																																																
		CreateIbarraMaterial	301041	326586715854.763	2158501.529	-2158501.529	1.167562291	0.015977279	-0.015977279	0.006812954	95.07975939	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																																																
	################################################################																																																															
																																																																
# 2b. Ibarra-Medina-Krawinkler Material for Beam Joints																																																																
	# Define the Beam Plastic Hinge Materials																																																															
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																																																
		CreateIbarraMaterial	213011	193154677872.116	647648.5754	-523334.0128	1.196276286	0.040944835	-0.043584868	0.1	104.1535637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	213012	193154677872.116	523334.0128	-647648.5754	1.196276286	0.043584868	-0.040944835	0.1	104.1535637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	213021	193154677872.116	647648.5754	-523334.0128	1.196276286	0.040944835	-0.043584868	0.1	104.1535637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	213022	193154677872.116	523334.0128	-647648.5754	1.196276286	0.043584868	-0.040944835	0.1	104.1535637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	213031	193154677872.116	647648.5754	-523334.0128	1.196276286	0.040944835	-0.043584868	0.1	104.1535637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	213032	193154677872.116	523334.0128	-647648.5754	1.196276286	0.043584868	-0.040944835	0.1	104.1535637	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
																																																																
		CreateIbarraMaterial	212011	193154677872.116	586952.9682	-875072.4561	1.196276286	0.052417212	-0.046806249	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	212012	193154677872.116	875072.4561	-586952.9682	1.196276286	0.046806249	-0.052417212	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	212021	193154677872.116	586952.9682	-875072.4561	1.196276286	0.052417212	-0.046806249	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	212022	193154677872.116	875072.4561	-586952.9682	1.196276286	0.046806249	-0.052417212	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	212031	193154677872.116	586952.9682	-875072.4561	1.196276286	0.052417212	-0.046806249	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	212032	193154677872.116	875072.4561	-586952.9682	1.196276286	0.046806249	-0.052417212	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
																																																																
		CreateIbarraMaterial	211011	193154677872.116	569232.4507	-1028714.679	1.196276286	0.063935219	-0.054018584	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	211012	193154677872.116	1028714.679	-569232.4507	1.196276286	0.054018584	-0.063935219	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	211021	193154677872.116	569232.4507	-1028714.679	1.196276286	0.063935219	-0.054018584	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	211022	193154677872.116	1028714.679	-569232.4507	1.196276286	0.054018584	-0.063935219	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	211031	193154677872.116	569232.4507	-1028714.679	1.196276286	0.063935219	-0.054018584	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	211032	193154677872.116	1028714.679	-569232.4507	1.196276286	0.054018584	-0.063935219	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
																																																																
		CreateIbarraMaterial	210011	193154677872.116	651136.3096	-1256575.169	1.196276286	0.064668057	-0.054566101	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	210012	193154677872.116	1256575.169	-651136.3096	1.196276286	0.054566101	-0.064668057	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	210021	193154677872.116	651136.3096	-1256575.169	1.196276286	0.064668057	-0.054566101	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	210022	193154677872.116	1256575.169	-651136.3096	1.196276286	0.054566101	-0.064668057	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	210031	193154677872.116	651136.3096	-1256575.169	1.196276286	0.064668057	-0.054566101	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
		CreateIbarraMaterial	210032	193154677872.116	1256575.169	-651136.3096	1.196276286	0.054566101	-0.064668057	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																																																
																																																																
		CreateIbarraMaterial	209011	191829683892.811	700416.6025	-1363089.422	1.196276286	0.067858352	-0.057469357	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	209012	191829683892.811	1363089.422	-700416.6025	1.196276286	0.057469357	-0.067858352	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	209021	191829683892.811	700416.6025	-1363089.422	1.196276286	0.067858352	-0.057469357	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	209022	191829683892.811	1363089.422	-700416.6025	1.196276286	0.057469357	-0.067858352	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	209031	191829683892.811	700416.6025	-1363089.422	1.196276286	0.067858352	-0.057469357	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	209032	191829683892.811	1363089.422	-700416.6025	1.196276286	0.057469357	-0.067858352	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
																																																																
		CreateIbarraMaterial	208011	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	208012	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	208021	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	208022	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	208031	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	208032	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
																																																																
		CreateIbarraMaterial	207011	191829683892.811	826774.7333	-1576057.831	1.196276286	0.071706718	-0.061986897	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	207012	191829683892.811	1576057.831	-826774.7333	1.196276286	0.061986897	-0.071706718	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	207021	191829683892.811	826774.7333	-1576057.831	1.196276286	0.071706718	-0.061986897	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	207022	191829683892.811	1576057.831	-826774.7333	1.196276286	0.061986897	-0.071706718	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	207031	191829683892.811	826774.7333	-1576057.831	1.196276286	0.071706718	-0.061986897	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
		CreateIbarraMaterial	207032	191829683892.811	1576057.831	-826774.7333	1.196276286	0.061986897	-0.071706718	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																																																
																																																																
		CreateIbarraMaterial	206011	190504689913.505	826774.7333	-1576057.831	1.196276286	0.071708272	-0.06198986	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	206012	190504689913.505	1576057.831	-826774.7333	1.196276286	0.06198986	-0.071708272	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	206021	190504689913.505	826774.7333	-1576057.831	1.196276286	0.071708272	-0.06198986	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	206022	190504689913.505	1576057.831	-826774.7333	1.196276286	0.06198986	-0.071708272	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	206031	190504689913.505	826774.7333	-1576057.831	1.196276286	0.071708272	-0.06198986	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	206032	190504689913.505	1576057.831	-826774.7333	1.196276286	0.06198986	-0.071708272	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
																																																																
		CreateIbarraMaterial	205011	190504689913.505	827255.7697	-1680553.114	1.196276286	0.072720432	-0.062317673	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	205012	190504689913.505	1680553.114	-827255.7697	1.196276286	0.062317673	-0.072720432	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	205021	190504689913.505	827255.7697	-1680553.114	1.196276286	0.072720432	-0.062317673	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	205022	190504689913.505	1680553.114	-827255.7697	1.196276286	0.062317673	-0.072720432	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	205031	190504689913.505	827255.7697	-1680553.114	1.196276286	0.072720432	-0.062317673	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
		CreateIbarraMaterial	205032	190504689913.505	1680553.114	-827255.7697	1.196276286	0.062317673	-0.072720432	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7500																																																
																																																																
		CreateIbarraMaterial	204011	187854701954.894	826774.7333	-1576057.831	1.196276286	0.071711447	-0.061995912	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	204012	187854701954.894	1576057.831	-826774.7333	1.196276286	0.061995912	-0.071711447	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	204021	187854701954.894	826774.7333	-1576057.831	1.196276286	0.071711447	-0.061995912	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	204022	187854701954.894	1576057.831	-826774.7333	1.196276286	0.061995912	-0.071711447	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	204031	187854701954.894	826774.7333	-1576057.831	1.196276286	0.071711447	-0.061995912	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	204032	187854701954.894	1576057.831	-826774.7333	1.196276286	0.061995912	-0.071711447	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
																																																																
		CreateIbarraMaterial	203011	187854701954.894	826774.7333	-1576057.831	1.196276286	0.071711447	-0.061995912	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	203012	187854701954.894	1576057.831	-826774.7333	1.196276286	0.061995912	-0.071711447	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	203021	187854701954.894	826774.7333	-1576057.831	1.196276286	0.071711447	-0.061995912	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	203022	187854701954.894	1576057.831	-826774.7333	1.196276286	0.061995912	-0.071711447	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	203031	187854701954.894	826774.7333	-1576057.831	1.196276286	0.071711447	-0.061995912	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	203032	187854701954.894	1576057.831	-826774.7333	1.196276286	0.061995912	-0.071711447	0.1	124.0391086	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
																																																																
		CreateIbarraMaterial	202011	187854701954.894	700189.3339	-1303342.857	1.196276286	0.064711992	-0.055433036	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	202012	187854701954.894	1303342.857	-700189.3339	1.196276286	0.055433036	-0.064711992	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	202021	187854701954.894	700189.3339	-1303342.857	1.196276286	0.064711992	-0.055433036	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	202022	187854701954.894	1303342.857	-700189.3339	1.196276286	0.055433036	-0.064711992	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	202031	187854701954.894	700189.3339	-1303342.857	1.196276286	0.064711992	-0.055433036	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
		CreateIbarraMaterial	202032	187854701954.894	1303342.857	-700189.3339	1.196276286	0.055433036	-0.064711992	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7400																																																
	################################################################																																																															
																																																																
# 3. Footing rotational stiffness																																																																
	# Define the Elastic Footing Rotational Stiffness Materials (this is supposed to include link beam and footing-soil stiffness)																																																															
		#	Elastic	matTag	Force-Defo_Slope																																																											
		uniaxialMaterial	Elastic	601	37666267772.47																																																									
		uniaxialMaterial	Elastic	602	132803991263.67																																																						
		uniaxialMaterial	Elastic	603	132803991263.67																																																											
		uniaxialMaterial	Elastic	604	37666267772.47																																																											
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
		node	202011	0	3800																																																											
		node	202012	400	4150																																																											
		node	202013	0	4500																																																											
		node	202014	-400	4150																																																											
		node	202021	8200	3800																																																											
		node	202022	8600	4150																																																											
		node	202023	8200	4500																																																											
		node	202024	7800	4150																																																											
		node	202031	16400	3800																																																											
		node	202032	16800	4150																																																											
		node	202033	16400	4500																																																											
		node	202034	16000	4150																																																											
		node	202041	24600	3800																																																											
		node	202042	25000	4150																																																											
		node	202043	24600	4500																																																											
		node	202044	24200	4150																																																											
																																																																
		node	203011	0	7700																																																											
		node	203012	400	8050																																																											
		node	203013	0	8400																																																											
		node	203014	-400	8050																																																											
		node	203021	8200	7700																																																											
		node	203022	8600	8050																																																											
		node	203023	8200	8400																																																											
		node	203024	7800	8050																																																											
		node	203031	16400	7700																																																											
		node	203032	16800	8050																																																											
		node	203033	16400	8400																																																											
		node	203034	16000	8050																																																											
		node	203041	24600	7700																																																											
		node	203042	25000	8050																																																											
		node	203043	24600	8400																																																											
		node	203044	24200	8050																																																											
																																																																
		node	204011	0	11600																																																											
		node	204012	400	11950																																																											
		node	204013	0	12300																																																											
		node	204014	-400	11950																																																											
		node	204021	8200	11600																																																											
		node	204022	8600	11950																																																											
		node	204023	8200	12300																																																											
		node	204024	7800	11950																																																											
		node	204031	16400	11600																																																											
		node	204032	16800	11950																																																											
		node	204033	16400	12300																																																											
		node	204034	16000	11950																																																											
		node	204041	24600	11600																																																											
		node	204042	25000	11950																																																											
		node	204043	24600	12300																																																											
		node	204044	24200	11950																																																											
																																																																
		node	205011	0	15500																																																											
		node	205012	350	15850																																																											
		node	205013	0	16200																																																											
		node	205014	-350	15850																																																											
		node	205021	8200	15500																																																											
		node	205022	8550	15850																																																											
		node	205023	8200	16200																																																											
		node	205024	7850	15850																																																											
		node	205031	16400	15500																																																											
		node	205032	16750	15850																																																											
		node	205033	16400	16200																																																											
		node	205034	16050	15850																																																											
		node	205041	24600	15500																																																											
		node	205042	24950	15850																																																											
		node	205043	24600	16200																																																											
		node	205044	24250	15850																																																											
																																																																
		node	206011	0	19400																																																											
		node	206012	350	19750																																																											
		node	206013	0	20100																																																											
		node	206014	-350	19750																																																											
		node	206021	8200	19400																																																											
		node	206022	8550	19750																																																											
		node	206023	8200	20100																																																											
		node	206024	7850	19750																																																											
		node	206031	16400	19400																																																											
		node	206032	16750	19750																																																											
		node	206033	16400	20100																																																											
		node	206034	16050	19750																																																											
		node	206041	24600	19400																																																											
		node	206042	24950	19750																																																											
		node	206043	24600	20100																																																											
		node	206044	24250	19750																																																											
																																																																
		node	207011	0	23300																																																											
		node	207012	325	23650																																																											
		node	207013	0	24000																																																											
		node	207014	-325	23650																																																											
		node	207021	8200	23300																																																											
		node	207022	8525	23650																																																											
		node	207023	8200	24000																																																											
		node	207024	7875	23650																																																											
		node	207031	16400	23300																																																											
		node	207032	16725	23650																																																											
		node	207033	16400	24000																																																											
		node	207034	16075	23650																																																											
		node	207041	24600	23300																																																											
		node	207042	24925	23650																																																											
		node	207043	24600	24000																																																											
		node	207044	24275	23650																																																											
																																																																
		node	208011	0	27200																																																											
		node	208012	325	27550																																																											
		node	208013	0	27900																																																											
		node	208014	-325	27550																																																											
		node	208021	8200	27200																																																											
		node	208022	8525	27550																																																											
		node	208023	8200	27900																																																											
		node	208024	7875	27550																																																											
		node	208031	16400	27200																																																											
		node	208032	16725	27550																																																											
		node	208033	16400	27900																																																											
		node	208034	16075	27550																																																											
		node	208041	24600	27200																																																											
		node	208042	24925	27550																																																											
		node	208043	24600	27900																																																											
		node	208044	24275	27550																																																											
																																																																
		node	209011	0	31100																																																											
		node	209012	325	31450																																																											
		node	209013	0	31800																																																											
		node	209014	-325	31450																																																											
		node	209021	8200	31100																																																											
		node	209022	8525	31450																																																											
		node	209023	8200	31800																																																											
		node	209024	7875	31450																																																											
		node	209031	16400	31100																																																											
		node	209032	16725	31450																																																											
		node	209033	16400	31800																																																											
		node	209034	16075	31450																																																											
		node	209041	24600	31100																																																											
		node	209042	24925	31450																																																											
		node	209043	24600	31800																																																											
		node	209044	24275	31450																																																											
																																																																
		node	210011	0	35000																																																											
		node	210012	300	35350																																																											
		node	210013	0	35700																																																											
		node	210014	-300	35350																																																											
		node	210021	8200	35000																																																											
		node	210022	8500	35350																																																											
		node	210023	8200	35700																																																											
		node	210024	7900	35350																																																											
		node	210031	16400	35000																																																											
		node	210032	16700	35350																																																											
		node	210033	16400	35700																																																											
		node	210034	16100	35350																																																											
		node	210041	24600	35000																																																											
		node	210042	24900	35350																																																											
		node	210043	24600	35700																																																											
		node	210044	24300	35350																																																											
																																																																
		node	211011	0	38900																																																											
		node	211012	300	39250																																																											
		node	211013	0	39600																																																											
		node	211014	-300	39250																																																											
		node	211021	8200	38900																																																											
		node	211022	8500	39250																																																											
		node	211023	8200	39600																																																											
		node	211024	7900	39250																																																											
		node	211031	16400	38900																																																											
		node	211032	16700	39250																																																											
		node	211033	16400	39600																																																											
		node	211034	16100	39250																																																											
		node	211041	24600	38900																																																											
		node	211042	24900	39250																																																											
		node	211043	24600	39600																																																											
		node	211044	24300	39250																																																											
																																																																
		node	212011	0	42800																																																											
		node	212012	300	43150																																																											
		node	212013	0	43500																																																											
		node	212014	-300	43150																																																											
		node	212021	8200	42800																																																											
		node	212022	8500	43150																																																											
		node	212023	8200	43500																																																											
		node	212024	7900	43150																																																											
		node	212031	16400	42800																																																											
		node	212032	16700	43150																																																											
		node	212033	16400	43500																																																											
		node	212034	16100	43150																																																											
		node	212041	24600	42800																																																											
		node	212042	24900	43150																																																											
		node	212043	24600	43500																																																											
		node	212044	24300	43150																																																											
																																																																
		node	213011	0	46700																																																											
		node	213012	300	47050																																																											
		node	213013	0	47400																																																											
		node	213014	-300	47050																																																											
		node	213021	8200	46700																																																											
		node	213022	8500	47050																																																											
		node	213023	8200	47400																																																											
		node	213024	7900	47050																																																											
		node	213031	16400	46700																																																											
		node	213032	16700	47050																																																											
		node	213033	16400	47400																																																											
		node	213034	16100	47050																																																											
		node	213041	24600	46700																																																											
		node	213042	24900	47050																																																											
		node	213043	24600	47400																																																											
		node	213044	24300	47050																																																											
																																																																
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
		element	elasticBeamColumn	31201	212013	213011	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31202	212023	213021	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31203	212033	213031	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31204	212043	213041	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	31101	211013	212011	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31102	211023	212021	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31103	211033	212031	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31104	211043	212041	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	31001	210013	211011	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31002	210023	211021	270000	32.04822928	3184021179	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31003	210033	211031	270000	32.04822928	3184021179	$primaryGeomTransT																																																						
		element	elasticBeamColumn	31004	210043	211041	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30901	209013	210011	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30902	209023	210021	270000	32.04822928	3651361571	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30903	209033	210031	270000	32.04822928	3651361571	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30904	209043	210041	270000	32.04822928	2835000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30801	208013	209011	325000	32.04822928	4004947917	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30802	208023	209021	325000	32.04822928	5051784525	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30803	208033	209031	325000	32.04822928	5051784525	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30804	208043	209041	325000	32.04822928	4004947917	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30701	207013	208011	325000	32.04822928	4006092717	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30702	207023	208021	325000	32.04822928	5603519706	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30703	207033	208031	325000	32.04822928	5603519706	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30704	207043	208041	325000	32.04822928	4006092717	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30601	206013	207011	325000	32.04822928	4291590066	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30602	206023	207021	325000	32.04822928	6155254887	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30603	206033	207031	325000	32.04822928	6155254887	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30604	206043	207041	325000	32.04822928	4291590066	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30501	205013	206011	385000	32.04822928	5557461725	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30502	205023	206021	385000	32.04822928	8027644683	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30503	205033	206031	385000	32.04822928	8027644683	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30504	205043	206041	385000	32.04822928	5557461725	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30401	204013	205011	385000	32.04822928	5892694735	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30402	204023	205021	385000	32.04822928	8671650563	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30403	204033	205031	385000	32.04822928	8671650563	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30404	204043	205041	385000	32.04822928	5892694735	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30301	203013	204011	480000	32.04822928	8960000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30302	203023	204021	480000	32.04822928	12458582510	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30303	203033	204031	480000	32.04822928	12458582510	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30304	203043	204041	480000	32.04822928	8960000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30201	202013	203011	480000	32.04822928	8960000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30202	202023	203021	480000	32.04822928	13308260884	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30203	202033	203031	480000	32.04822928	13308260884	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30204	202043	203041	480000	32.04822928	8960000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	30101	201013	202011	480000	32.04822928	10190476141	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30102	201023	202021	480000	32.04822928	15030018262	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30103	201033	202031	480000	32.04822928	15030018262	$primaryGeomTransT																																																						
		element	elasticBeamColumn	30104	201043	202041	480000	32.04822928	10190476141	$primaryGeomTransT																																																						
																																																																
# 6b. Elastic Beam elements																																																																
		element	elasticBeamColumn	21301	213012	213024	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21302	213022	213034	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21303	213032	213044	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	21201	212012	212024	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21202	212022	212034	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21203	212032	212044	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	21101	211012	211024	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21102	211022	211034	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21103	211032	211044	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	21001	210012	210024	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21002	210022	210034	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	21003	210032	210044	315000	32.04822928	6027000000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20901	209012	209024	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20902	209022	209034	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20903	209032	209044	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20801	208012	208024	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20802	208022	208034	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20803	208032	208044	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20701	207012	207024	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20702	207022	207034	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20703	207032	207044	315000	32.04822928	5985656250	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20601	206012	206024	315000	32.04822928	5944312500	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20602	206022	206034	315000	32.04822928	5944312500	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20603	206032	206044	315000	32.04822928	5944312500	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20501	205012	205024	315000	32.04822928	5944312500	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20502	205022	205034	315000	32.04822928	5944312500	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20503	205032	205044	315000	32.04822928	5944312500	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20401	204012	204024	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20402	204022	204034	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20403	204032	204044	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20301	203012	203024	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20302	203022	203034	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20303	203032	203044	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
																																																																
		element	elasticBeamColumn	20201	202012	202024	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20202	202022	202034	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
		element	elasticBeamColumn	20203	202032	202044	315000	32.04822928	5861625000	$primaryGeomTransT																																																						
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
		eleLoad -ele	21301	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21302	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21303	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21201	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21202	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21203	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21101	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21102	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21103	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21001	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21002	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	21003	-type -beamUniform	-0.094583224																																																											
		eleLoad -ele	20901	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20902	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20903	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20801	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20802	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20803	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20701	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20702	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20703	-type -beamUniform	-0.095209603																																																											
		eleLoad -ele	20601	-type -beamUniform	-0.095844333																																																											
		eleLoad -ele	20602	-type -beamUniform	-0.095844333																																																											
		eleLoad -ele	20603	-type -beamUniform	-0.095844333																																																											
		eleLoad -ele	20501	-type -beamUniform	-0.095844333																																																											
		eleLoad -ele	20502	-type -beamUniform	-0.095844333																																																											
		eleLoad -ele	20503	-type -beamUniform	-0.095844333																																																											
		eleLoad -ele	20401	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20402	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20403	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20301	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20302	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20303	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20201	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20202	-type -beamUniform	-0.097139527																																																											
		eleLoad -ele	20203	-type -beamUniform	-0.097139527																																																											
																																																																
	# 7b. Leaning Column Point Loads 																																																															
		#	node	X	Y	M																																																										
		load	313	0	-86.4	0																																																										
		load	312	0	-86.4	0																																																										
		load	311	0	-86.4	0																																																										
		load	310	0	-86.4	0																																																										
		load	309	0	-104	0																																																										
		load	308	0	-104	0																																																										
		load	307	0	-104	0																																																										
		load	306	0	-123.2	0																																																										
		load	305	0	-123.2	0																																																										
		load	304	0	-153.6	0																																																										
		load	303	0	-153.6	0																																																										
		load	302	0	-182.4	0																																																										
																																																																
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
		mass	213011	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	213012	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	213013	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	213014	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	213021	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213022	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213023	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213024	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213031	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213032	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213033	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213034	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	213041	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	213042	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	213043	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	213044	0.009709894	0.009709894	[expr $smallMass3]																																																										
																																																																
		mass	212011	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	212012	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	212013	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	212014	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	212021	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212022	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212023	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212024	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212031	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212032	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212033	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212034	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	212041	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	212042	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	212043	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	212044	0.009709894	0.009709894	[expr $smallMass3]																																																										
																																																																
		mass	211011	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	211012	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	211013	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	211014	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	211021	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211022	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211023	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211024	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211031	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211032	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211033	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211034	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	211041	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	211042	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	211043	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	211044	0.009709894	0.009709894	[expr $smallMass3]																																																										
																																																																
		mass	210011	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	210012	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	210013	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	210014	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	210021	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210022	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210023	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210024	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210031	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210032	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210033	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210034	0.01886933	0.01886933	[expr $smallMass3]																																																										
		mass	210041	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	210042	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	210043	0.009709894	0.009709894	[expr $smallMass3]																																																										
		mass	210044	0.009709894	0.009709894	[expr $smallMass3]																																																										
																																																																
		mass	209011	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	209012	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	209013	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	209014	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	209021	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209022	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209023	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209024	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209031	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209032	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209033	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209034	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	209041	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	209042	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	209043	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	209044	0.009822025	0.009822025	[expr $smallMass3]																																																										
																																																																
		mass	208011	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	208012	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	208013	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	208014	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	208021	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208022	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208023	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208024	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208031	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208032	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208033	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208034	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	208041	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	208042	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	208043	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	208044	0.009822025	0.009822025	[expr $smallMass3]																																																										
																																																																
		mass	207011	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	207012	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	207013	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	207014	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	207021	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207022	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207023	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207024	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207031	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207032	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207033	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207034	0.01898146	0.01898146	[expr $smallMass3]																																																										
		mass	207041	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	207042	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	207043	0.009822025	0.009822025	[expr $smallMass3]																																																										
		mass	207044	0.009822025	0.009822025	[expr $smallMass3]																																																										
																																																																
		mass	206011	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	206012	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	206013	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	206014	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	206021	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206022	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206023	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206024	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206031	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206032	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206033	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206034	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	206041	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	206042	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	206043	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	206044	0.009944349	0.009944349	[expr $smallMass3]																																																										
																																																																
		mass	205011	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	205012	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	205013	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	205014	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	205021	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205022	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205023	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205024	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205031	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205032	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205033	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205034	0.019103784	0.019103784	[expr $smallMass3]																																																										
		mass	205041	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	205042	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	205043	0.009944349	0.009944349	[expr $smallMass3]																																																										
		mass	205044	0.009944349	0.009944349	[expr $smallMass3]																																																										
																																																																
		mass	204011	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	204012	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	204013	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	204014	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	204021	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204022	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204023	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204024	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204031	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204032	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204033	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204034	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	204041	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	204042	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	204043	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	204044	0.010138029	0.010138029	[expr $smallMass3]																																																										
																																																																
		mass	203011	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	203012	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	203013	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	203014	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	203021	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203022	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203023	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203024	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203031	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203032	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203033	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203034	0.019297464	0.019297464	[expr $smallMass3]																																																										
		mass	203041	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	203042	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	203043	0.010138029	0.010138029	[expr $smallMass3]																																																										
		mass	203044	0.010138029	0.010138029	[expr $smallMass3]																																																										
																																																																
		mass	202011	0.010321515	0.010321515	[expr $smallMass3]																																																										
		mass	202012	0.010321515	0.010321515	[expr $smallMass3]																																																										
		mass	202013	0.010321515	0.010321515	[expr $smallMass3]																																																										
		mass	202014	0.010321515	0.010321515	[expr $smallMass3]																																																										
		mass	202021	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202022	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202023	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202024	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202031	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202032	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202033	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202034	0.019480951	0.019480951	[expr $smallMass3]																																																										
		mass	202041	0.010321515	0.010321515	[expr $smallMass3]																																																										
		mass	202042	0.010321515	0.010321515	[expr $smallMass3]																																																										
		mass	202043	0.010321515	0.010321515	[expr $smallMass3]																																																										
		mass	202044	0.010321515	0.010321515	[expr $smallMass3]																																																										
	################################################################																																																															
	##################### total mass is 2.77997655453619 (kN-s^2 /mm) ##############																																																															
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
