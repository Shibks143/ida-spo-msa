# 1. Shear Panel Material
	# Define Joint Shear Panel Materials
		#	Elastic	matTag	Force-Defo_Slope
		uniaxialMaterial	Elastic	40601	494573174.881635
		uniaxialMaterial	Elastic	40602	1009333009.96252
		uniaxialMaterial	Elastic	40603	1009333009.96252
		uniaxialMaterial	Elastic	40604	494573174.881635

		uniaxialMaterial	Elastic	40501	494573174.881635
		uniaxialMaterial	Elastic	40502	1009333009.96252
		uniaxialMaterial	Elastic	40503	1009333009.96252
		uniaxialMaterial	Elastic	40504	494573174.881635

		uniaxialMaterial	Elastic	40401	710570439.013614
		uniaxialMaterial	Elastic	40402	1343422236.26011
		uniaxialMaterial	Elastic	40403	1343422236.26011
		uniaxialMaterial	Elastic	40404	710570439.013614

		uniaxialMaterial	Elastic	40301	710570439.013614
		uniaxialMaterial	Elastic	40302	1343422236.26011
		uniaxialMaterial	Elastic	40303	1343422236.26011
		uniaxialMaterial	Elastic	40304	710570439.013614

		uniaxialMaterial	Elastic	40201	710570439.013614
		uniaxialMaterial	Elastic	40202	1343422236.26011
		uniaxialMaterial	Elastic	40203	1343422236.26011
		uniaxialMaterial	Elastic	40204	710570439.013614
	################################################################

# 2a. Ibarra-Medina-Krawinkler Material for Column Joints
	# Define the Column Plastic Hinge Materials
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength
		CreateIbarraMaterial	305011	37217762847.0317	371104.8059	-371104.8059	1.196578593	0.052593372	-0.052593372	0.1	93.41280112	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	305021	53168232638.6167	393782.1289	-393782.1289	1.193206938	0.046232071	-0.046232071	0.1	90.49770495	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	305031	53168232638.6167	393782.1289	-393782.1289	1.193206938	0.046232071	-0.046232071	0.1	90.49770495	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	305041	37217762847.0317	371104.8059	-371104.8059	1.196578593	0.052593372	-0.052593372	0.1	93.41280112	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150

		CreateIbarraMaterial	304011	41061642499.9662	576377.0856	-576377.0856	1.187884665	0.061925422	-0.061925422	0.1	85.60448691	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	304021	65868949485.9756	680006.2789	-680006.2789	1.181199781	0.043530877	-0.043530877	0.1	80.5856235	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	304031	65868949485.9756	680006.2789	-680006.2789	1.181199781	0.043530877	-0.043530877	0.1	80.5856235	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	304041	41061642499.9662	576377.0856	-576377.0856	1.187884665	0.061925422	-0.061925422	0.1	85.60448691	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150

		CreateIbarraMaterial	303011	62190474059.6229	731610.5922	-731610.5922	1.184484957	0.054926256	-0.054926256	0.1	87.48919922	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	303021	99851383694.0453	964490.5587	-964490.5587	1.175438672	0.03891796	-0.03891796	0.08686525	80.4620467	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	303031	99851383694.0453	964490.5587	-964490.5587	1.175438672	0.03891796	-0.03891796	0.08686525	80.4620467	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	303041	62190474059.6229	731610.5922	-731610.5922	1.184484957	0.054926256	-0.054926256	0.1	87.48919922	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150

		CreateIbarraMaterial	302011	70147058845.8725	1003991.319	-1003991.319	1.177576829	0.052950958	-0.052950958	0.1	81.9242621	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	302021	115562322767.062	1376894.732	-1376894.732	1.16560648	0.039932316	-0.039932316	0.067624152	73.03929993	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	302031	115562322767.062	1376894.732	-1376894.732	1.16560648	0.039932316	-0.039932316	0.067624152	73.03929993	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150
		CreateIbarraMaterial	302041	70147058845.8725	1003991.319	-1003991.319	1.177576829	0.052950958	-0.052950958	0.1	81.9242621	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150

		CreateIbarraMaterial	301011	86105875374.3046	1128690.757	-1128690.757	1.170655948	0.049606906	-0.049606906	0.1	76.67425202	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750
		CreateIbarraMaterial	301021	142276330485.58	1648893.493	-1648893.493	1.155804162	0.040752792	-0.040752792	0.052574	66.20095408	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750
		CreateIbarraMaterial	301031	142276330485.58	1648893.493	-1648893.493	1.155804162	0.040752792	-0.040752792	0.052574	66.20095408	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750
		CreateIbarraMaterial	301041	86105875374.3046	1128690.757	-1128690.757	1.170655948	0.049606906	-0.049606906	0.1	76.67425202	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3750
	################################################################

# 2b. Ibarra-Medina-Krawinkler Material for Beam Joints
	# Define the Beam Plastic Hinge Materials
		#	matTag	EIeff	mYPos	mYNeg	mcOverMy	thetaCapPos	thetaCapNeg	thetaPC	lambda	c	resStrRatio	stiffFactor1	stiffFactor2	eleLength
		CreateIbarraMaterial	206011	181288482374.072	654387.4301	-765798.1024	1.205336151	0.037867805	-0.03648502	    0.1	104.5481997	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	206012	181288482374.072	765798.1024	-654387.4301	1.205336151	0.03648502	-0.037867805	0.1	104.5481997	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	206021	181288482374.072	455423.5294	-748700.2319	1.205336151	0.038693624	-0.033969522	0.1	104.5481997	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	206022	181288482374.072	748700.2319	-455423.5294	1.205336151	0.033969522	-0.038693624	0.1	104.5481997	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	206031	181288482374.072	654387.4301	-765798.1024	1.205336151	0.037867805	-0.03648502	    0.1	104.5481997	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	206032	181288482374.072	765798.1024	-654387.4301	1.205336151	0.03648502	-0.037867805	0.1	104.5481997	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700

		CreateIbarraMaterial	205011	181288482374.072	578459.0685	-992765.1354	1.205336151	0.048163236	-0.042120263	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	205012	181288482374.072	992765.1354	-578459.0685	1.205336151	0.042120263	-0.048163236	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	205021	181288482374.072	534524.2999	-977558.8734	1.205336151	0.040424917	-0.035308042	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	205022	181288482374.072	977558.8734	-534524.2999	1.205336151	0.035308042	-0.040424917	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	205031	181288482374.072	578459.0685	-992765.1354	1.205336151	0.048163236	-0.042120263	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700
		CreateIbarraMaterial	205032	181288482374.072	992765.1354	-578459.0685	1.205336151	0.042120263	-0.048163236	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7700

		CreateIbarraMaterial	204011	180058017561.578	625653.9075	-1223424.644	1.205336151	0.056177537	-0.048009832	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	204012	180058017561.578	1223424.644	-625653.9075	1.205336151	0.048009832	-0.056177537	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	204021	180058017561.578	623459.4447	-1223298.225	1.205336151	0.050054351	-0.043238626	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	204022	180058017561.578	1223298.225	-623459.4447	1.205336151	0.043238626	-0.050054351	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	204031	180058017561.578	625653.9075	-1223424.644	1.205336151	0.056177537	-0.048009832	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	204032	180058017561.578	1223424.644	-625653.9075	1.205336151	0.048009832	-0.056177537	0.1	113.2183524	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650

		CreateIbarraMaterial	203011	180058017561.578	702051.5192	-1354309.914	1.205336151	0.045871829	-0.040928267	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	203012	180058017561.578	1354309.914	-702051.5192	1.205336151	0.040928267	-0.045871829	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	203021	180058017561.578	701965.1402	-1339481.674	1.205336151	0.045765529	-0.040869411	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	203022	180058017561.578	1339481.674	-701965.1402	1.205336151	0.040869411	-0.045765529	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	203031	180058017561.578	702051.5192	-1354309.914	1.205336151	0.045871829	-0.040928267	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	203032	180058017561.578	1354309.914	-702051.5192	1.205336151	0.040928267	-0.045871829	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650

		CreateIbarraMaterial	202011	180058017561.578	738438.7751	-1454423.758	1.205336151	0.068331553	-0.058497862	0.1	122.9080048	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	202012	180058017561.578	1454423.758	-738438.7751	1.205336151	0.058497862	-0.068331553	0.1	122.9080048	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	202021	180058017561.578	701965.1402	-1339481.674	1.205336151	0.045765529	-0.040869411	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	202022	180058017561.578	1339481.674	-701965.1402	1.205336151	0.040869411	-0.045765529	0.1	104.2925995	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	202031	180058017561.578	738438.7751	-1454423.758	1.205336151	0.068331553	-0.058497862	0.1	122.9080048	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
		CreateIbarraMaterial	202032	180058017561.578	1454423.758	-738438.7751	1.205336151	0.058497862	-0.068331553	0.1	122.9080048	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	7650
	################################################################

# 3. Footing rotational stiffness
	# Define the Elastic Footing Rotational Stiffness Materials (this is supposed to include link beam and footing-soil stiffness)
		#	Elastic	matTag	Force-Defo_Slope
		uniaxialMaterial	Elastic	601	6508426305
		uniaxialMaterial	Elastic	602	20342903582
		uniaxialMaterial	Elastic	603	20342903582
		uniaxialMaterial	Elastic	604	6508426305
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
		node	202012	275	4125
		node	202013	0	4500
		node	202014	-275	4125
		node	202021	8200	3750
		node	202022	8475	4125
		node	202023	8200	4500
		node	202024	7925	4125
		node	202031	16400	3750
		node	202032	16675	4125
		node	202033	16400	4500
		node	202034	16125	4125
		node	202041	24600	3750
		node	202042	24875	4125
		node	202043	24600	4500
		node	202044	24325	4125

		node	203011	0	7650
		node	203012	275	8025
		node	203013	0	8400
		node	203014	-275	8025
		node	203021	8200	7650
		node	203022	8475	8025
		node	203023	8200	8400
		node	203024	7925	8025
		node	203031	16400	7650
		node	203032	16675	8025
		node	203033	16400	8400
		node	203034	16125	8025
		node	203041	24600	7650
		node	203042	24875	8025
		node	203043	24600	8400
		node	203044	24325	8025

		node	204011	0	11550
		node	204012	275	11925
		node	204013	0	12300
		node	204014	-275	11925
		node	204021	8200	11550
		node	204022	8475	11925
		node	204023	8200	12300
		node	204024	7925	11925
		node	204031	16400	11550
		node	204032	16675	11925
		node	204033	16400	12300
		node	204034	16125	11925
		node	204041	24600	11550
		node	204042	24875	11925
		node	204043	24600	12300
		node	204044	24325	11925

		node	205011	0	15450
		node	205012	250	15825
		node	205013	0	16200
		node	205014	-250	15825
		node	205021	8200	15450
		node	205022	8450	15825
		node	205023	8200	16200
		node	205024	7950	15825
		node	205031	16400	15450
		node	205032	16650	15825
		node	205033	16400	16200
		node	205034	16150	15825
		node	205041	24600	15450
		node	205042	24850	15825
		node	205043	24600	16200
		node	205044	24350	15825

		node	206011	0	19350
		node	206012	250	19725
		node	206013	0	20100
		node	206014	-250	19725
		node	206021	8200	19350
		node	206022	8450	19725
		node	206023	8200	20100
		node	206024	7950	19725
		node	206031	16400	19350
		node	206032	16650	19725
		node	206033	16400	20100
		node	206034	16150	19725
		node	206041	24600	19350
		node	206042	24850	19725
		node	206043	24600	20100
		node	206044	24350	19725

	# Define the leaning column nodes
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
		element	elasticBeamColumn	30501	205013	206011	175000	29.16657333	1276041667	$primaryGeomTransT
		element	elasticBeamColumn	30502	205023	206021	250000	29.16657333	1822916667	$primaryGeomTransT
		element	elasticBeamColumn	30503	205033	206031	250000	29.16657333	1822916667	$primaryGeomTransT
		element	elasticBeamColumn	30504	205043	206041	175000	29.16657333	1276041667	$primaryGeomTransT

		element	elasticBeamColumn	30401	204013	205011	175000	29.16657333	1407832248	$primaryGeomTransT
		element	elasticBeamColumn	30402	204023	205021	250000	29.16657333	2258371209	$primaryGeomTransT
		element	elasticBeamColumn	30403	204033	205031	250000	29.16657333	2258371209	$primaryGeomTransT
		element	elasticBeamColumn	30404	204043	205041	175000	29.16657333	1407832248	$primaryGeomTransT

		element	elasticBeamColumn	30301	203013	204011	220000	29.16657333	2132251648	$primaryGeomTransT
		element	elasticBeamColumn	30302	203023	204021	302500	29.16657333	3423486968	$primaryGeomTransT
		element	elasticBeamColumn	30303	203033	204031	302500	29.16657333	3423486968	$primaryGeomTransT
		element	elasticBeamColumn	30304	203043	204041	220000	29.16657333	2132251648	$primaryGeomTransT

		element	elasticBeamColumn	30201	202013	203011	220000	29.16657333	2405049714	$primaryGeomTransT
		element	elasticBeamColumn	30202	202023	203021	302500	29.16657333	3962149459	$primaryGeomTransT
		element	elasticBeamColumn	30203	202033	203031	302500	29.16657333	3962149459	$primaryGeomTransT
		element	elasticBeamColumn	30204	202043	203041	220000	29.16657333	2405049714	$primaryGeomTransT

		element	elasticBeamColumn	30101	201013	202011	220000	29.16657333	2952210888	$primaryGeomTransT
		element	elasticBeamColumn	30102	201023	202021	302500	29.16657333	4878061226	$primaryGeomTransT
		element	elasticBeamColumn	30103	201033	202031	302500	29.16657333	4878061226	$primaryGeomTransT
		element	elasticBeamColumn	30104	201043	202041	220000	29.16657333	2952210888	$primaryGeomTransT

# 6b. Elastic Beam elements
		element	elasticBeamColumn	20601	206012	206024	300000	29.16657333	6215625000	$primaryGeomTransT
		element	elasticBeamColumn	20602	206022	206034	300000	29.16657333	6215625000	$primaryGeomTransT
		element	elasticBeamColumn	20603	206032	206044	300000	29.16657333	6215625000	$primaryGeomTransT

		element	elasticBeamColumn	20501	205012	205024	300000	29.16657333	6215625000	$primaryGeomTransT
		element	elasticBeamColumn	20502	205022	205034	300000	29.16657333	6215625000	$primaryGeomTransT
		element	elasticBeamColumn	20503	205032	205044	300000	29.16657333	6215625000	$primaryGeomTransT

		element	elasticBeamColumn	20401	204012	204024	300000	29.16657333	6173437500	$primaryGeomTransT
		element	elasticBeamColumn	20402	204022	204034	300000	29.16657333	6173437500	$primaryGeomTransT
		element	elasticBeamColumn	20403	204032	204044	300000	29.16657333	6173437500	$primaryGeomTransT

		element	elasticBeamColumn	20301	203012	203024	300000	29.16657333	6173437500	$primaryGeomTransT
		element	elasticBeamColumn	20302	203022	203034	300000	29.16657333	6173437500	$primaryGeomTransT
		element	elasticBeamColumn	20303	203032	203044	300000	29.16657333	6173437500	$primaryGeomTransT

		element	elasticBeamColumn	20201	202012	202024	300000	29.16657333	6173437500	$primaryGeomTransT
		element	elasticBeamColumn	20202	202022	202034	300000	29.16657333	6173437500	$primaryGeomTransT
		element	elasticBeamColumn	20203	202032	202044	300000	29.16657333	6173437500	$primaryGeomTransT
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
		element	Joint2D	40601	206011	206012	206013	206014	206015	305011	206011	49999	49999	40601	$lrgDsp
		element	Joint2D	40602	206021	206022	206023	206024	206025	305021	206021	49999	206012	40602	$lrgDsp
		element	Joint2D	40603	206031	206032	206033	206034	206035	305031	206031	49999	206022	40603	$lrgDsp
		element	Joint2D	40604	206041	206042	206043	206044	206045	305041	49999	49999	206032	40604	$lrgDsp

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
		element	elasticBeamColumn	5051	305	306	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT
		element	elasticBeamColumn	5041	304	305	$A_strut	$E_strut	$I_strut	$primaryGeomTransT
		element	elasticBeamColumn	5031	303	304	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT
		element	elasticBeamColumn	5021	302	303	$A_strut	$E_strut	$I_strut	$primaryGeomTransT
		element	elasticBeamColumn	5011	301	302	$A_strut	$E_strut	$IOfZero	$primaryGeomTransT

		## consider changing nodes for connecting leaning columns from 208043 etc. to 208048 etc. This may improve the convergence.
		element	truss	5062	206043	306	$A_strut	$strutMatT
		element	truss	5052	205043	305	$A_strut	$strutMatT
		element	truss	5042	204043	304	$A_strut	$strutMatT
		element	truss	5032	203043	303	$A_strut	$strutMatT
		element	truss	5022	202043	302	$A_strut	$strutMatT
	################################################################


# 7. Define Gravity Loads

	pattern Plain 1 Linear {
	# 7a. udl on the beams
		eleLoad -ele	20601	-type -beamUniform	-0.10615539
		eleLoad -ele	20602	-type -beamUniform	-0.10615539
		eleLoad -ele	20603	-type -beamUniform	-0.10615539
		eleLoad -ele	20501	-type -beamUniform	-0.10615539
		eleLoad -ele	20502	-type -beamUniform	-0.10615539
		eleLoad -ele	20503	-type -beamUniform	-0.10615539
		eleLoad -ele	20401	-type -beamUniform	-0.106849216
		eleLoad -ele	20402	-type -beamUniform	-0.106849216
		eleLoad -ele	20403	-type -beamUniform	-0.106849216
		eleLoad -ele	20301	-type -beamUniform	-0.106849216
		eleLoad -ele	20302	-type -beamUniform	-0.106849216
		eleLoad -ele	20303	-type -beamUniform	-0.106849216
		eleLoad -ele	20201	-type -beamUniform	-0.106849216
		eleLoad -ele	20202	-type -beamUniform	-0.106849216
		eleLoad -ele	20203	-type -beamUniform	-0.106849216

	# 7b. Leaning Column Point Loads
		#	node	X	Y	M
		load	306	0	-66.9375	0
		load	305	0	-66.9375	0
		load	304	0	-82.29375	0
		load	303	0	-82.29375	0
		load	302	0	-97.96875	0

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
		mass	206011	0.010766552	0.010766552	[expr $smallMass3]
		mass	206012	0.010766552	0.010766552	[expr $smallMass3]
		mass	206013	0.010766552	0.010766552	[expr $smallMass3]
		mass	206014	0.010766552	0.010766552	[expr $smallMass3]
		mass	206021	0.021332416	0.021332416	[expr $smallMass3]
		mass	206022	0.021332416	0.021332416	[expr $smallMass3]
		mass	206023	0.021332416	0.021332416	[expr $smallMass3]
		mass	206024	0.021332416	0.021332416	[expr $smallMass3]
		mass	206031	0.021332416	0.021332416	[expr $smallMass3]
		mass	206032	0.021332416	0.021332416	[expr $smallMass3]
		mass	206033	0.021332416	0.021332416	[expr $smallMass3]
		mass	206034	0.021332416	0.021332416	[expr $smallMass3]
		mass	206041	0.010766552	0.010766552	[expr $smallMass3]
		mass	206042	0.010766552	0.010766552	[expr $smallMass3]
		mass	206043	0.010766552	0.010766552	[expr $smallMass3]
		mass	206044	0.010766552	0.010766552	[expr $smallMass3]

		mass	205011	0.010766552	0.010766552	[expr $smallMass3]
		mass	205012	0.010766552	0.010766552	[expr $smallMass3]
		mass	205013	0.010766552	0.010766552	[expr $smallMass3]
		mass	205014	0.010766552	0.010766552	[expr $smallMass3]
		mass	205021	0.021332416	0.021332416	[expr $smallMass3]
		mass	205022	0.021332416	0.021332416	[expr $smallMass3]
		mass	205023	0.021332416	0.021332416	[expr $smallMass3]
		mass	205024	0.021332416	0.021332416	[expr $smallMass3]
		mass	205031	0.021332416	0.021332416	[expr $smallMass3]
		mass	205032	0.021332416	0.021332416	[expr $smallMass3]
		mass	205033	0.021332416	0.021332416	[expr $smallMass3]
		mass	205034	0.021332416	0.021332416	[expr $smallMass3]
		mass	205041	0.010766552	0.010766552	[expr $smallMass3]
		mass	205042	0.010766552	0.010766552	[expr $smallMass3]
		mass	205043	0.010766552	0.010766552	[expr $smallMass3]
		mass	205044	0.010766552	0.010766552	[expr $smallMass3]

		mass	204011	0.010856862	0.010856862	[expr $smallMass3]
		mass	204012	0.010856862	0.010856862	[expr $smallMass3]
		mass	204013	0.010856862	0.010856862	[expr $smallMass3]
		mass	204014	0.010856862	0.010856862	[expr $smallMass3]
		mass	204021	0.021437777	0.021437777	[expr $smallMass3]
		mass	204022	0.021437777	0.021437777	[expr $smallMass3]
		mass	204023	0.021437777	0.021437777	[expr $smallMass3]
		mass	204024	0.021437777	0.021437777	[expr $smallMass3]
		mass	204031	0.021437777	0.021437777	[expr $smallMass3]
		mass	204032	0.021437777	0.021437777	[expr $smallMass3]
		mass	204033	0.021437777	0.021437777	[expr $smallMass3]
		mass	204034	0.021437777	0.021437777	[expr $smallMass3]
		mass	204041	0.010856862	0.010856862	[expr $smallMass3]
		mass	204042	0.010856862	0.010856862	[expr $smallMass3]
		mass	204043	0.010856862	0.010856862	[expr $smallMass3]
		mass	204044	0.010856862	0.010856862	[expr $smallMass3]

		mass	203011	0.010856862	0.010856862	[expr $smallMass3]
		mass	203012	0.010856862	0.010856862	[expr $smallMass3]
		mass	203013	0.010856862	0.010856862	[expr $smallMass3]
		mass	203014	0.010856862	0.010856862	[expr $smallMass3]
		mass	203021	0.021437777	0.021437777	[expr $smallMass3]
		mass	203022	0.021437777	0.021437777	[expr $smallMass3]
		mass	203023	0.021437777	0.021437777	[expr $smallMass3]
		mass	203024	0.021437777	0.021437777	[expr $smallMass3]
		mass	203031	0.021437777	0.021437777	[expr $smallMass3]
		mass	203032	0.021437777	0.021437777	[expr $smallMass3]
		mass	203033	0.021437777	0.021437777	[expr $smallMass3]
		mass	203034	0.021437777	0.021437777	[expr $smallMass3]
		mass	203041	0.010856862	0.010856862	[expr $smallMass3]
		mass	203042	0.010856862	0.010856862	[expr $smallMass3]
		mass	203043	0.010856862	0.010856862	[expr $smallMass3]
		mass	203044	0.010856862	0.010856862	[expr $smallMass3]

		mass	202011	0.010940959	0.010940959	[expr $smallMass3]
		mass	202012	0.010940959	0.010940959	[expr $smallMass3]
		mass	202013	0.010940959	0.010940959	[expr $smallMass3]
		mass	202014	0.010940959	0.010940959	[expr $smallMass3]
		mass	202021	0.021553412	0.021553412	[expr $smallMass3]
		mass	202022	0.021553412	0.021553412	[expr $smallMass3]
		mass	202023	0.021553412	0.021553412	[expr $smallMass3]
		mass	202024	0.021553412	0.021553412	[expr $smallMass3]
		mass	202031	0.021553412	0.021553412	[expr $smallMass3]
		mass	202032	0.021553412	0.021553412	[expr $smallMass3]
		mass	202033	0.021553412	0.021553412	[expr $smallMass3]
		mass	202034	0.021553412	0.021553412	[expr $smallMass3]
		mass	202041	0.010940959	0.010940959	[expr $smallMass3]
		mass	202042	0.010940959	0.010940959	[expr $smallMass3]
		mass	202043	0.010940959	0.010940959	[expr $smallMass3]
		mass	202044	0.010940959	0.010940959	[expr $smallMass3]
	################################################################
	##################### total mass is 1.29025267584098 (kN-s^2 /mm) ##############
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
		region 1 -eleRange  20201 30504 -rayleigh $alpha1 0 $alpha2ToUse 0;    # Initial stiffness
	################################################################

# 10. Define Stuffs to records etc. and few analysis options
	# Define control nodes for monotonic and cyclic pushover - at top of leaning column
		set poControlNodeNum 306
		set poControlNodeNumCyclic 306

	# Define a list of element numbers to record - record the columns or primary frame and leaning column - these are used for computing base shear and story shear
		set elementNumToRecordLIST { 		30501	30502	30503	30504	5051	30401	30402	30403	30404	5041	30301	30302	30303	30304	5031	30201	30202	30203	30204	5021	30101	30102	30103	30104	5011	}

	# Define a list of joint numbers to record - all joints of primary frame
		set jointNumToRecordLIST { 		40601	40602	40603	40604	40501	40502	40503	40504	40401	40402	40403	40404	40301	40302	40303	40304	40201	40202	40203	40204	}

	# Define a list of node numbers to record - top/bottom node of joint in left column of each floor, leaning column nodes, base spring nodes
		set nodeNumToRecordLIST { 		206011	206013	306	205011	205013	305	204011	204013	304	203011	203013	303	202011	202013	302	201012	201013	201022	201023	201032	201033	201042	201043	}

	# Define a list of hinge elements to record - these are the springs at the base of the columns (elastic foundation + column PH)
		set hingeElementsToRecordLIST  { 		6011	6012	6021	6022	6031	6032	6041	6042	}

	# Define a list of column numbers at the base of the frame (including the leaning column); this is for base shear calculations
		set columnNumsAtBaseLIST { 		30101	30102	30103	30104	5011	}

	# Define a list of column numbers at each story (including the leaning column); this is for story shear calculations
		 set columnNumsAtEachStoryLIST {	{	30101	30102	30103	30104	5011	}
			{	30201	30202	30203	30204	5021	}
			{	30301	30302	30303	30304	5031	}
			{	30401	30402	30403	30404	5041	}
			{	30501	30502	30503	30504	5051	}	}

	# Define a list of heights of each floor (for computing story drifts)
		set floorHeightsLIST {	0	4500	8400	12300	16200	20100	}

	# Define a list of the node numbers at each floor (always use node 3 of the joint because it is at the slab level and we measure all height to there)
		set nodeNumsAtEachFloorLIST {	-1	202013	203013	204013	205013	206013	}


	#####################################################################################
	#####################################################################################
	###### END OF THE CODE WRITTEN BY VBA USING THE DEISGN DATA #########################
	#####################################################################################
	#####################################################################################

