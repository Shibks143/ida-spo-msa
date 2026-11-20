# 1. Shear Panel Material 																																												
	# Define Joint Shear Panel Materials																																											
		#	Elastic	matTag	Force-Defo_Slope																																							
		uniaxialMaterial	Elastic	40901	1078001517.83288																																							
		uniaxialMaterial	Elastic	40902	1916447142.81401																																							
		uniaxialMaterial	Elastic	40903	1916447142.81401																																							
		uniaxialMaterial	Elastic	40904	1078001517.83288																																							
																																												
		uniaxialMaterial	Elastic	40801	1078001517.83288																																							
		uniaxialMaterial	Elastic	40802	1916447142.81401																																							
		uniaxialMaterial	Elastic	40803	1916447142.81401																																							
		uniaxialMaterial	Elastic	40804	1078001517.83288																																							
																																												
		uniaxialMaterial	Elastic	40701	1078001517.83288																																							
		uniaxialMaterial	Elastic	40702	1916447142.81401																																							
		uniaxialMaterial	Elastic	40703	1916447142.81401																																							
		uniaxialMaterial	Elastic	40704	1078001517.83288																																							
																																												
		uniaxialMaterial	Elastic	40601	1078001517.83288																																							
		uniaxialMaterial	Elastic	40602	1916447142.81401																																							
		uniaxialMaterial	Elastic	40603	1916447142.81401																																							
		uniaxialMaterial	Elastic	40604	1078001517.83288																																							
																																												
		uniaxialMaterial	Elastic	40501	1441771577.34851																																							
		uniaxialMaterial	Elastic	40502	2436593965.71898																																							
		uniaxialMaterial	Elastic	40503	2436593965.71898																																							
		uniaxialMaterial	Elastic	40504	1441771577.34851																																							
																																												
		uniaxialMaterial	Elastic	40401	1441771577.34851																																							
		uniaxialMaterial	Elastic	40402	2436593965.71898																																							
		uniaxialMaterial	Elastic	40403	2436593965.71898																																							
		uniaxialMaterial	Elastic	40404	1441771577.34851																																							
																																												
		uniaxialMaterial	Elastic	40301	1441771577.34851																																							
		uniaxialMaterial	Elastic	40302	2436593965.71898																																							
		uniaxialMaterial	Elastic	40303	2436593965.71898																																							
		uniaxialMaterial	Elastic	40304	1441771577.34851																																							
																																												
		uniaxialMaterial	Elastic	40201	1441771577.34851																																							
		uniaxialMaterial	Elastic	40202	2436593965.71898																																							
		uniaxialMaterial	Elastic	40203	2436593965.71898																																							
		uniaxialMaterial	Elastic	40204	1441771577.34851																																							
	################################################################																																											
																																												
# 2a. Ibarra-Medina-Krawinkler Material for Column Joints																																												
	# Define the Column Plastic Hinge Materials																																											
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																												
		CreateIbarraMaterial	308011	90856730009.532	1092225.106	-1092225.106	1.192060318	0.053435025	-0.053435025	0.1	106.5958753	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	308021	121142306679.376	1323215.901	-1323215.901	1.190076996	0.053368306	-0.053368306	0.1	104.6200945	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	308031	121142306679.376	1323215.901	-1323215.901	1.190076996	0.053368306	-0.053368306	0.1	104.6200945	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	308041	90856730009.532	1092225.106	-1092225.106	1.192060318	0.053435025	-0.053435025	0.1	106.5958753	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
																																												
		CreateIbarraMaterial	307011	90856730009.532	1168356.458	-1168356.458	1.187859208	0.051342354	-0.051342354	0.094747965	102.4502911	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	307021	121142306679.376	1475010.13	-1475010.13	1.183909832	0.05030655	-0.05030655	0.095372046	98.68760559	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	307031	121142306679.376	1475010.13	-1475010.13	1.183909832	0.05030655	-0.05030655	0.095372046	98.68760559	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	307041	90856730009.532	1168356.458	-1168356.458	1.187859208	0.051342354	-0.051342354	0.094747965	102.4502911	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
																																												
		CreateIbarraMaterial	306011	90856730009.532	1243541.049	-1243541.049	1.183672903	0.049381278	-0.049381278	0.085283441	98.46593141	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	306021	121515812691.84	1623774.843	-1623774.843	1.177774627	0.047502128	-0.047502128	0.081688112	93.09151888	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	306031	121515812691.84	1623774.843	-1623774.843	1.177774627	0.047502128	-0.047502128	0.081688112	93.09151888	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	306041	90856730009.532	1243541.049	-1243541.049	1.183672903	0.049381278	-0.049381278	0.085283441	98.46593141	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
																																												
		CreateIbarraMaterial	305011	90856730009.532	1317836.319	-1317836.319	1.179501353	0.047544726	-0.047544726	0.076764343	94.63652611	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	305021	136638885999.156	1769808.187	-1769808.187	1.171671216	0.044115642	-0.044115642	0.069967543	87.8127586	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	305031	136638885999.156	1769808.187	-1769808.187	1.171671216	0.044115642	-0.044115642	0.069967543	87.8127586	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	305041	90856730009.532	1317836.319	-1317836.319	1.179501353	0.047544726	-0.047544726	0.076764343	94.63652611	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
																																												
		CreateIbarraMaterial	304011	128351489088.826	1543762.269	-1543762.269	1.178820954	0.043866231	-0.043866231	0.068729189	97.56099432	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	304021	184941990622.693	2117164.504	-2117164.504	1.170052716	0.041074575	-0.041074575	0.062473198	89.71096771	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	304031	184941990622.693	2117164.504	-2117164.504	1.170052716	0.041074575	-0.041074575	0.062473198	89.71096771	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	304041	128351489088.826	1543762.269	-1543762.269	1.178820954	0.043866231	-0.043866231	0.068729189	97.56099432	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
																																												
		CreateIbarraMaterial	303011	128388177899.814	1625477.597	-1625477.597	1.175328723	0.042496636	-0.042496636	0.062911825	94.3624294	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	303021	202809296228.441	2274685.247	-2274685.247	1.164849801	0.038584054	-0.038584054	0.054701375	85.32944967	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	303031	202809296228.441	2274685.247	-2274685.247	1.164849801	0.038584054	-0.038584054	0.054701375	85.32944967	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	303041	128388177899.814	1625477.597	-1625477.597	1.175328723	0.042496636	-0.042496636	0.062911825	94.3624294	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
																																												
		CreateIbarraMaterial	302011	137537862406.092	1706349.36	-1706349.36	1.171846839	0.040731645	-0.040731645	0.057586853	91.26873034	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	302021	220676601834.188	2429884.208	-2429884.208	1.159670021	0.036268145	-0.036268145	0.047896386	81.16192665	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	302031	220676601834.188	2429884.208	-2429884.208	1.159670021	0.036268145	-0.036268145	0.047896386	81.16192665	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
		CreateIbarraMaterial	302041	137537862406.092	1706349.36	-1706349.36	1.171846839	0.040731645	-0.040731645	0.057586853	91.26873034	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3200																												
																																												
		CreateIbarraMaterial	301011	162036202161.823	1787430.796	-1787430.796	1.168331424	0.039526912	-0.039526912	0.052653662	88.23924603	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																												
		CreateIbarraMaterial	301021	258497159264.225	2518633.123	-2518633.123	1.15446995	0.034492344	-0.034492344	0.041891068	77.16540415	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																												
		CreateIbarraMaterial	301031	258497159264.225	2518633.123	-2518633.123	1.15446995	0.034492344	-0.034492344	0.041891068	77.16540415	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																												
		CreateIbarraMaterial	301041	162036202161.823	1787430.796	-1787430.796	1.168331424	0.039526912	-0.039526912	0.052653662	88.23924603	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3800																												
	################################################################																																											
																																												
# 2b. Ibarra-Medina-Krawinkler Material for Beam Joints																																												
	# Define the Beam Plastic Hinge Materials																																											
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength																												
		CreateIbarraMaterial	209011	193154677872.116	634489.5601	-634489.5601	1.196276286	0.045434447	-0.045434447	0.1	107.8946237	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	209012	193154677872.116	634489.5601	-634489.5601	1.196276286	0.045434447	-0.045434447	0.1	107.8946237	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	209021	193154677872.116	572311.534	-696205.1396	1.196276286	0.046756782	-0.044178683	0.1	107.8946237	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	209022	193154677872.116	696205.1396	-572311.534	1.196276286	0.044178683	-0.046756782	0.1	107.8946237	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	209031	193154677872.116	634489.5601	-634489.5601	1.196276286	0.045434447	-0.045434447	0.1	107.8946237	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	209032	193154677872.116	634489.5601	-634489.5601	1.196276286	0.045434447	-0.045434447	0.1	107.8946237	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
																																												
		CreateIbarraMaterial	208011	193154677872.116	573145.0367	-921593.0719	1.196276286	0.053142451	-0.04653458	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	208012	193154677872.116	921593.0719	-573145.0367	1.196276286	0.04653458	-0.053142451	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	208021	193154677872.116	573145.0367	-921593.0719	1.196276286	0.053142451	-0.04653458	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	208022	193154677872.116	921593.0719	-573145.0367	1.196276286	0.04653458	-0.053142451	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	208031	193154677872.116	573145.0367	-921593.0719	1.196276286	0.053142451	-0.04653458	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	208032	193154677872.116	921593.0719	-573145.0367	1.196276286	0.04653458	-0.053142451	0.1	111.5150992	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
																																												
		CreateIbarraMaterial	207011	193154677872.116	573641.3245	-1089099.651	1.196276286	0.059079789	-0.049630617	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	207012	193154677872.116	1089099.651	-573641.3245	1.196276286	0.049630617	-0.059079789	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	207021	193154677872.116	573641.3245	-1089099.651	1.196276286	0.059079789	-0.049630617	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	207022	193154677872.116	1089099.651	-573641.3245	1.196276286	0.049630617	-0.059079789	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	207031	193154677872.116	573641.3245	-1089099.651	1.196276286	0.059079789	-0.049630617	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	207032	193154677872.116	1089099.651	-573641.3245	1.196276286	0.049630617	-0.059079789	0.1	115.5425627	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
																																												
		CreateIbarraMaterial	206011	193154677872.116	686057.7978	-1257232.693	1.196276286	0.064327198	-0.05513131	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	206012	193154677872.116	1257232.693	-686057.7978	1.196276286	0.05513131	-0.064327198	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	206021	193154677872.116	686057.7978	-1257232.693	1.196276286	0.064327198	-0.05513131	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	206022	193154677872.116	1257232.693	-686057.7978	1.196276286	0.05513131	-0.064327198	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	206031	193154677872.116	686057.7978	-1257232.693	1.196276286	0.064327198	-0.05513131	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
		CreateIbarraMaterial	206032	193154677872.116	1257232.693	-686057.7978	1.196276286	0.05513131	-0.064327198	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7600																												
																																												
		CreateIbarraMaterial	205011	191829683892.811	700582.316	-1408711.981	1.196276286	0.068350615	-0.057565337	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	205012	191829683892.811	1408711.981	-700582.316	1.196276286	0.057565337	-0.068350615	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	205021	191829683892.811	700582.316	-1408711.981	1.196276286	0.065818048	-0.055645716	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	205022	191829683892.811	1408711.981	-700582.316	1.196276286	0.055645716	-0.065818048	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	205031	191829683892.811	700582.316	-1408711.981	1.196276286	0.068350615	-0.057565337	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	205032	191829683892.811	1408711.981	-700582.316	1.196276286	0.057565337	-0.068350615	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
																																												
		CreateIbarraMaterial	204011	191829683892.811	749676.4192	-1469335.463	1.196276286	0.068530783	-0.058469382	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	204012	191829683892.811	1469335.463	-749676.4192	1.196276286	0.058469382	-0.068530783	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	204021	191829683892.811	749676.4192	-1469335.463	1.196276286	0.068530783	-0.058469382	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	204022	191829683892.811	1469335.463	-749676.4192	1.196276286	0.058469382	-0.068530783	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	204031	191829683892.811	749676.4192	-1469335.463	1.196276286	0.068530783	-0.058469382	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	204032	191829683892.811	1469335.463	-749676.4192	1.196276286	0.058469382	-0.068530783	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
																																												
		CreateIbarraMaterial	203011	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	203012	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	203021	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	203022	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	203031	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	203032	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
																																												
		CreateIbarraMaterial	202011	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	202012	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	202021	191829683892.811	700416.6025	-1363089.422	1.196276286	0.065345296	-0.055541661	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	202022	191829683892.811	1363089.422	-700416.6025	1.196276286	0.055541661	-0.065345296	0.1	119.7154814	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	202031	191829683892.811	763621.4601	-1469662.973	1.196276286	0.068417536	-0.058679278	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
		CreateIbarraMaterial	202032	191829683892.811	1469662.973	-763621.4601	1.196276286	0.058679278	-0.068417536	0.1	121.8581208	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7550																												
	################################################################																																											
																																												
# 3. Footing rotational stiffness																																												
	# Define the Elastic Footing Rotational Stiffness Materials (this is supposed to include link beam and footing-soil stiffness)																																											
		#	Elastic	matTag	Force-Defo_Slope																																							
		uniaxialMaterial	Elastic	601	15487035503.11																																							
		uniaxialMaterial	Elastic	602	64091488732.62																																							
		uniaxialMaterial	Elastic	603	64091488732.62																																							
		uniaxialMaterial	Elastic	604	15487035503.11																																							
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
		node	202012	325	4150																																							
		node	202013	0	4500																																							
		node	202014	-325	4150																																							
		node	202021	8200	3800																																							
		node	202022	8525	4150																																							
		node	202023	8200	4500																																							
		node	202024	7875	4150																																							
		node	202031	16400	3800																																							
		node	202032	16725	4150																																							
		node	202033	16400	4500																																							
		node	202034	16075	4150																																							
		node	202041	24600	3800																																							
		node	202042	24925	4150																																							
		node	202043	24600	4500																																							
		node	202044	24275	4150																																							
																																												
		node	203011	0	7700																																							
		node	203012	325	8050																																							
		node	203013	0	8400																																							
		node	203014	-325	8050																																							
		node	203021	8200	7700																																							
		node	203022	8525	8050																																							
		node	203023	8200	8400																																							
		node	203024	7875	8050																																							
		node	203031	16400	7700																																							
		node	203032	16725	8050																																							
		node	203033	16400	8400																																							
		node	203034	16075	8050																																							
		node	203041	24600	7700																																							
		node	203042	24925	8050																																							
		node	203043	24600	8400																																							
		node	203044	24275	8050																																							
																																												
		node	204011	0	11600																																							
		node	204012	325	11950																																							
		node	204013	0	12300																																							
		node	204014	-325	11950																																							
		node	204021	8200	11600																																							
		node	204022	8525	11950																																							
		node	204023	8200	12300																																							
		node	204024	7875	11950																																							
		node	204031	16400	11600																																							
		node	204032	16725	11950																																							
		node	204033	16400	12300																																							
		node	204034	16075	11950																																							
		node	204041	24600	11600																																							
		node	204042	24925	11950																																							
		node	204043	24600	12300																																							
		node	204044	24275	11950																																							
																																												
		node	205011	0	15500																																							
		node	205012	325	15850																																							
		node	205013	0	16200																																							
		node	205014	-325	15850																																							
		node	205021	8200	15500																																							
		node	205022	8525	15850																																							
		node	205023	8200	16200																																							
		node	205024	7875	15850																																							
		node	205031	16400	15500																																							
		node	205032	16725	15850																																							
		node	205033	16400	16200																																							
		node	205034	16075	15850																																							
		node	205041	24600	15500																																							
		node	205042	24925	15850																																							
		node	205043	24600	16200																																							
		node	205044	24275	15850																																							
																																												
		node	206011	0	19400																																							
		node	206012	300	19750																																							
		node	206013	0	20100																																							
		node	206014	-300	19750																																							
		node	206021	8200	19400																																							
		node	206022	8500	19750																																							
		node	206023	8200	20100																																							
		node	206024	7900	19750																																							
		node	206031	16400	19400																																							
		node	206032	16700	19750																																							
		node	206033	16400	20100																																							
		node	206034	16100	19750																																							
		node	206041	24600	19400																																							
		node	206042	24900	19750																																							
		node	206043	24600	20100																																							
		node	206044	24300	19750																																							
																																												
		node	207011	0	23300																																							
		node	207012	300	23650																																							
		node	207013	0	24000																																							
		node	207014	-300	23650																																							
		node	207021	8200	23300																																							
		node	207022	8500	23650																																							
		node	207023	8200	24000																																							
		node	207024	7900	23650																																							
		node	207031	16400	23300																																							
		node	207032	16700	23650																																							
		node	207033	16400	24000																																							
		node	207034	16100	23650																																							
		node	207041	24600	23300																																							
		node	207042	24900	23650																																							
		node	207043	24600	24000																																							
		node	207044	24300	23650																																							
																																												
		node	208011	0	27200																																							
		node	208012	300	27550																																							
		node	208013	0	27900																																							
		node	208014	-300	27550																																							
		node	208021	8200	27200																																							
		node	208022	8500	27550																																							
		node	208023	8200	27900																																							
		node	208024	7900	27550																																							
		node	208031	16400	27200																																							
		node	208032	16700	27550																																							
		node	208033	16400	27900																																							
		node	208034	16100	27550																																							
		node	208041	24600	27200																																							
		node	208042	24900	27550																																							
		node	208043	24600	27900																																							
		node	208044	24300	27550																																							
																																												
		node	209011	0	31100																																							
		node	209012	300	31450																																							
		node	209013	0	31800																																							
		node	209014	-300	31450																																							
		node	209021	8200	31100																																							
		node	209022	8500	31450																																							
		node	209023	8200	31800																																							
		node	209024	7900	31450																																							
		node	209031	16400	31100																																							
		node	209032	16700	31450																																							
		node	209033	16400	31800																																							
		node	209034	16100	31450																																							
		node	209041	24600	31100																																							
		node	209042	24900	31450																																							
		node	209043	24600	31800																																							
		node	209044	24300	31450																																							
																																												
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
		element	elasticBeamColumn	30801	208013	209011	270000	32.04822928	2835000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30802	208023	209021	360000	32.04822928	3780000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30803	208033	209031	360000	32.04822928	3780000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30804	208043	209041	270000	32.04822928	2835000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30701	207013	208011	270000	32.04822928	2835000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30702	207023	208021	360000	32.04822928	3780000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30703	207033	208031	360000	32.04822928	3780000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30704	207043	208041	270000	32.04822928	2835000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30601	206013	207011	270000	32.04822928	2835000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30602	206023	207021	360000	32.04822928	3791654498	$primaryGeomTransT																																		
		element	elasticBeamColumn	30603	206033	207031	360000	32.04822928	3791654498	$primaryGeomTransT																																		
		element	elasticBeamColumn	30604	206043	207041	270000	32.04822928	2835000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30501	205013	206011	270000	32.04822928	2835000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	30502	205023	206021	360000	32.04822928	4263539330	$primaryGeomTransT																																		
		element	elasticBeamColumn	30503	205033	206031	360000	32.04822928	4263539330	$primaryGeomTransT																																		
		element	elasticBeamColumn	30504	205043	206041	270000	32.04822928	2835000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30401	204013	205011	325000	32.04822928	4004947917	$primaryGeomTransT																																		
		element	elasticBeamColumn	30402	204023	205021	422500	32.04822928	5770739750	$primaryGeomTransT																																		
		element	elasticBeamColumn	30403	204033	205031	422500	32.04822928	5770739750	$primaryGeomTransT																																		
		element	elasticBeamColumn	30404	204043	205041	325000	32.04822928	4004947917	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30301	203013	204011	325000	32.04822928	4006092717	$primaryGeomTransT																																		
		element	elasticBeamColumn	30302	203023	204021	422500	32.04822928	6328252786	$primaryGeomTransT																																		
		element	elasticBeamColumn	30303	203033	204031	422500	32.04822928	6328252786	$primaryGeomTransT																																		
		element	elasticBeamColumn	30304	203043	204041	325000	32.04822928	4006092717	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30201	202013	203011	325000	32.04822928	4291590066	$primaryGeomTransT																																		
		element	elasticBeamColumn	30202	202023	203021	422500	32.04822928	6885765822	$primaryGeomTransT																																		
		element	elasticBeamColumn	30203	202033	203031	422500	32.04822928	6885765822	$primaryGeomTransT																																		
		element	elasticBeamColumn	30204	202043	203041	325000	32.04822928	4291590066	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	30101	201013	202011	325000	32.04822928	5056011075	$primaryGeomTransT																																		
		element	elasticBeamColumn	30102	201023	202021	422500	32.04822928	8065879615	$primaryGeomTransT																																		
		element	elasticBeamColumn	30103	201033	202031	422500	32.04822928	8065879615	$primaryGeomTransT																																		
		element	elasticBeamColumn	30104	201043	202041	325000	32.04822928	5056011075	$primaryGeomTransT																																		
																																												
# 6b. Elastic Beam elements																																												
		element	elasticBeamColumn	20901	209012	209024	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20902	209022	209034	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20903	209032	209044	315000	32.04822928	6027000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20801	208012	208024	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20802	208022	208034	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20803	208032	208044	315000	32.04822928	6027000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20701	207012	207024	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20702	207022	207034	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20703	207032	207044	315000	32.04822928	6027000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20601	206012	206024	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20602	206022	206034	315000	32.04822928	6027000000	$primaryGeomTransT																																		
		element	elasticBeamColumn	20603	206032	206044	315000	32.04822928	6027000000	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20501	205012	205024	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20502	205022	205034	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20503	205032	205044	315000	32.04822928	5985656250	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20401	204012	204024	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20402	204022	204034	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20403	204032	204044	315000	32.04822928	5985656250	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20301	203012	203024	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20302	203022	203034	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20303	203032	203044	315000	32.04822928	5985656250	$primaryGeomTransT																																		
																																												
		element	elasticBeamColumn	20201	202012	202024	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20202	202022	202034	315000	32.04822928	5985656250	$primaryGeomTransT																																		
		element	elasticBeamColumn	20203	202032	202044	315000	32.04822928	5985656250	$primaryGeomTransT																																		
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
		eleLoad -ele	20901	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20902	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20903	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20801	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20802	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20803	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20701	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20702	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20703	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20601	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20602	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20603	-type -beamUniform	-0.094583224																																							
		eleLoad -ele	20501	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20502	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20503	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20401	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20402	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20403	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20301	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20302	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20303	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20201	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20202	-type -beamUniform	-0.095209603																																							
		eleLoad -ele	20203	-type -beamUniform	-0.095209603																																							
																																												
	# 7b. Leaning Column Point Loads 																																											
		#	node	X	Y	M																																						
		load	309	0	-100.8	0																																						
		load	308	0	-100.8	0																																						
		load	307	0	-100.8	0																																						
		load	306	0	-100.8	0																																						
		load	305	0	-119.6	0																																						
		load	304	0	-119.6	0																																						
		load	303	0	-119.6	0																																						
		load	302	0	-142.025	0																																						
																																												
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
		mass	209011	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	209012	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	209013	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	209014	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	209021	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209022	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209023	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209024	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209031	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209032	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209033	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209034	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	209041	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	209042	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	209043	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	209044	0.009709894	0.009709894	[expr $smallMass3]																																						
																																												
		mass	208011	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	208012	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	208013	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	208014	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	208021	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208022	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208023	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208024	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208031	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208032	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208033	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208034	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	208041	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	208042	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	208043	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	208044	0.009709894	0.009709894	[expr $smallMass3]																																						
																																												
		mass	207011	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	207012	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	207013	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	207014	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	207021	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207022	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207023	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207024	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207031	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207032	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207033	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207034	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	207041	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	207042	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	207043	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	207044	0.009709894	0.009709894	[expr $smallMass3]																																						
																																												
		mass	206011	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	206012	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	206013	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	206014	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	206021	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206022	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206023	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206024	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206031	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206032	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206033	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206034	0.019052816	0.019052816	[expr $smallMass3]																																						
		mass	206041	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	206042	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	206043	0.009709894	0.009709894	[expr $smallMass3]																																						
		mass	206044	0.009709894	0.009709894	[expr $smallMass3]																																						
																																												
		mass	205011	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	205012	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	205013	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	205014	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	205021	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205022	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205023	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205024	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205031	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205032	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205033	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205034	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	205041	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	205042	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	205043	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	205044	0.009822025	0.009822025	[expr $smallMass3]																																						
																																												
		mass	204011	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	204012	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	204013	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	204014	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	204021	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204022	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204023	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204024	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204031	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204032	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204033	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204034	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	204041	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	204042	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	204043	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	204044	0.009822025	0.009822025	[expr $smallMass3]																																						
																																												
		mass	203011	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	203012	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	203013	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	203014	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	203021	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203022	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203023	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203024	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203031	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203032	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203033	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203034	0.019180237	0.019180237	[expr $smallMass3]																																						
		mass	203041	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	203042	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	203043	0.009822025	0.009822025	[expr $smallMass3]																																						
		mass	203044	0.009822025	0.009822025	[expr $smallMass3]																																						
																																												
		mass	202011	0.00994626	0.00994626	[expr $smallMass3]																																						
		mass	202012	0.00994626	0.00994626	[expr $smallMass3]																																						
		mass	202013	0.00994626	0.00994626	[expr $smallMass3]																																						
		mass	202014	0.00994626	0.00994626	[expr $smallMass3]																																						
		mass	202021	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202022	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202023	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202024	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202031	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202032	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202033	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202034	0.019341743	0.019341743	[expr $smallMass3]																																						
		mass	202041	0.00994626	0.00994626	[expr $smallMass3]																																						
		mass	202042	0.00994626	0.00994626	[expr $smallMass3]																																						
		mass	202043	0.00994626	0.00994626	[expr $smallMass3]																																						
		mass	202044	0.00994626	0.00994626	[expr $smallMass3]																																						
	################################################################																																											
	##################### total mass is 1.85076503567788 (kN-s^2 /mm) ##############																																											
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
