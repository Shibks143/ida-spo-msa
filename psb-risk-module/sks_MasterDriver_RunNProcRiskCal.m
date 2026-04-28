
tic 
tStart= tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Building Information Inputs

BldgIdAndZoneLIST = {'2433v02', 'V'; };
BldgIdLIST = {'2433v02'};


MIDR_or_PHR = 'MIDR'; % later on, maybe extended to include DI-based limits

eqListID = 'setC';  
% eqListID = 'setD' ;
% eqListID = 'setDNotC'; 
% eqListID = 'setG';
% eqListID = 'setTest';
% eqLIST =  'setGEM';

%                        fragDataGen   im_efficiency     RiskCal     RTGM     
analyzeProcessPlotIndex = [1             1                0           0];


%% Define the GM sets 
switch eqListID

    case 'setC'
        % ATC-63 Ground Motion Set C (Far-Field)SetTest
        eqNumberLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        eqFormatForCollapseList_SetC = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetC = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean

    case 'setD'
        % ATC-63 Ground Motion Set D (expanded Far-Field)
        eqNumberLIST = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
        eqFormatForCollapseList_SetD = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetD = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean

    case 'setDNotC'
        % ATC-63 Records that Are in Set D AND NOT IN C
        eqNumberLIST = [120131	120132	120141	120142	120151	120152	120161	120162	120631	120632	120641	120642	120731	120732	120741	120742	120931	120932	121031	121032	121041	121042	121051	121052	121061	121062	121231	121232	121431	121432	121441	121442	121451	121452	121461	121462];
        eqFormatForCollapseList_SetInDNotC = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetInDNotC = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean

    case 'setG'
        % ATC-63 Ground Motion Set G (Near-Field)
        eqNumberLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
        eqFormatForCollapseList_SetG = 'PEER-NGA_Rotated_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetG = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean

    case 'setTest'
        % Test GM set
        eqNumberLIST =  [120121, 120122,	121221, 121222]; % replaced last 2 GMs by EQs of shorter duration
        eqFormatForCollapseList_SetTest = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetTest = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean

    case 'setGEM'
        eqNumberLIST= [
                6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272; ...
                6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862; ...
                6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702; ...
                6001601	6001602	6003121	6003122	6003391	6003392	6003411	6003412	6005501	6005502	6006341	6006342	6007851	6007852	6009311	6009312	6009601	6009602	6009921	6009922	6010081	6010082	6011081	6011082	6013381	6013382	6014391	6014392	6014571	6014572	6014971	6014972	6016811	6016812	6017761	6017762	6021111	6021112	6024531	6024532	6032671	6032672	6033991	6033992; ...
                6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342; ...
                6000361	6000362	6000961	6000962	6005761	6005762	6007261	6007262	6007371	6007372	6008061	6008062	6008611	6008612	6008741	6008742	6010871	6010872	6011191	6011192	6011201	6011202	6012261	6012262	6012661	6012662	6013441	6013442	6014131	6014132	6015811	6015812	6016281	6016282	6024781	6024782	6027111	6027112	6027391	6027392	6027501	6027502	6032601	6032602; ...
                6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742; ...
                6000311	6000312	6000791	6000792	6000881	6000882	6001581	6001582	6001601	6001602	6002801	6002802	6003351	6003352	6003601	6003602	6004101	6004102	6004181	6004182	6006371	6006372	6007731	6007732	6007991	6007992	6008791	6008792	6009901	6009902	6009931	6009932	6011351	6011352	6014891	6014892	6015201	6015202	6032691	6032692	6034741	6034742	6035041	6035042; ...
                6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522; ...
                6001641	6001642	6003601	6003602	6005811	6005812	6005871	6005872	6006451	6006452	6007441	6007442	6007541	6007542	6007651	6007652	6009521	6009522	6009701	6009702	6009891	6009892	6009901	6009902	6010041	6010042	6010391	6010392	6011071	6011072	6011541	6011542	6012471	6012472	6014711	6014712	6015131	6015132	6018351	6018352	6026551	6026552	6031051	6031052; ...
                6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172; ...
                6000301	6000302	6000961	6000962	6001601	6001602	6003411	6003412	6003591	6003592	6005741	6005742	6005841	6005842	6007251	6007252	6007961	6007962	6008621	6008622	6009001	6009002	6009311	6009312	6010871	6010872	6011061	6011062	6012251	6012252	6013271	6013272	6014891	6014892	6015401	6015402	6016021	6016022	6026521	6026522	6033021	6033022	6034961	6034962; ...
                ];
end
% end of ground motion definition...

%% Start of Inputs   
MIDRInputs.eqNumberLIST = eqNumberLIST;

switch eqListID
    case 'setC'
        MIDRInputs.GMsuiteName = 'GMSetC';
    case 'setD'
        MIDRInputs.GMsuiteName = 'GMSetD';
    case 'setDNotC'
        MIDRInputs.GMsuiteName = 'GMSetDNotC';
    case 'setG'
        MIDRInputs.GMsuiteName = 'GMSetG';
    case 'setTest'
        MIDRInputs.GMsuiteName = 'GMSetTest';
    case 'setGEM'
        MIDRInputs.GMsuiteName = 'GMSetGEM';
end
PHRInputs = MIDRInputs;

% MIDR inputs begin here

latLonLIST = [ % input depending on the site (lat, lon)
    %     13.05	80.27; % Chennai
    %     22.55	88.37; % Kolkata
    %     19.00   72.80; % Mumbai   (Table 5.4 of NDMA, 2011 report)
    % 28.62   77.22; % Delhi
    26.17   91.77; % Guwahati
    %     27.10   92.10; % an arbitrary grid point near Arunachal border
    ];
locName = 'Guwahati';
zoneOfLocLIST =  {'V';}; % {'III'; 'IV'; 'V'; 'VI'}; % size of this input must match with the size of the latLonLIST 
imScaleFac = 1; % this is an optional variable; used for paramteric study to see the impact of hazard variation on risk
% imTypeLIST = {'PGA', 'Sa_0p1', 'Sa_0p2', 'Sa_0p5', 'Sa_0p9', 'Sa_1p0', 'Sa_1p2', 'Sa_2p0', 'Sa_5p0'};
timePLIST = [0, 0.04:0.01:5]; % skipping 0.01, 0.02, and 0.03 because several response spectra has Inf for these periods
T1LIST = [1.84]'; % geoM_Topt2 (<= 2sec), % Select list of period T1 for Intensity measure, Sa(T1), corresponding to each building
Ta = [0.71]; % (approximate period as per code)
TogmLIST =  [1.72]';
imType = {'Sa_T1'};
impFacLIST = 0;
fitModelLIST = {'3param'}; % {'2param', '3param'}; % Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)] the hazard fitting parameter
NLIST = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values
codeIdealizedHazData = 0; % 1, the program uses code-idealized hazard using two-parameter model based on DBE and MCE values (% 0 = PSHA hazard, 1 = code-idealized)

if strcmp(MIDR_or_PHR, 'MIDR')
    dsLIST = {'DynInst','CP','LS','IO'};
else % PHR
    dsLIST = {'DS4', 'DS3_normalizedByThetaCap', 'DS2a_0p50_normalizedByThetaCap', 'DS1', 'DS2_normalizedByThetaCap', 'DS2a_0p60_normalizedByThetaCap', 'DS2a_0p40_normalizedByThetaCap'};
end

% PHR inputs begin here
imTypeLIST = {'PGA', 'Sa_0p1', 'Sa_0p2', 'Sa_0p5', 'Sa_0p9', 'Sa_1p0', 'Sa_1p2', 'Sa_2p0', 'Sa_5p0'};



MIDRInputs.timePLIST =            timePLIST;
MIDRInputs.dsLIST =               dsLIST;
MIDRInputs.BldgIdAndZoneLIST =    BldgIdAndZoneLIST;
MIDRInputs.latLonLIST =           latLonLIST; 
MIDRInputs.zoneOfLocLIST =        zoneOfLocLIST;
MIDRInputs.imScaleFac =           imScaleFac;
MIDRInputs.imTypeLIST =           imTypeLIST;
MIDRInputs.impFacLIST =           impFacLIST; 
MIDRInputs.fitModelLIST =         fitModelLIST;
MIDRInputs.NLIST =                NLIST;
MIDRInputs.Ta =                   Ta;
MIDRInputs.T1LIST =               T1LIST; 
MIDRInputs.TogmLIST =             TogmLIST;
MIDRInputs.codeIdealizedHazData = codeIdealizedHazData;


PHRInputs.timePLIST =            timePLIST;
PHRInputs.BldgIdLIST =           BldgIdLIST;
PHRInputs.dsLIST =               dsLIST;
PHRInputs.latLonLIST =           latLonLIST; 
PHRInputs.zoneOfLocLIST =        zoneOfLocLIST;
PHRInputs.imType =               imType;
PHRInputs.Ta =                   Ta;
PHRInputs.T1LIST =               T1LIST; 
PHRInputs.locName =              locName;
PHRInputs.fitModelLIST =         fitModelLIST;
PHRInputs.NLIST =                NLIST;
PHRInputs.codeIdealizedHazData = codeIdealizedHazData;


% End of Inputs

%% Run Fragility Data generation  
if analyzeProcessPlotIndex(1) == 1
    runFlags.runDS1  = 0;
    runFlags.runDS23 = 0;
    runFlags.runDS4  = 0;
    runFlags.runFrag = 1;

sks_FragilityData(MIDR_or_PHR, MIDRInputs, PHRInputs, runFlags)
end
% End of fragility data generation


%% Start of intensity measure efficiency
if analyzeProcessPlotIndex(2) == 1
    sks_IM_efficieny(MIDR_or_PHR, MIDRInputs, PHRInputs);
end 
% End of intensity measure efficiency 


%% Start of Seismic Risk Calculation
if analyzeProcessPlotIndex(3) == 1
    sks_seismicRiskCal(MIDR_or_PHR, MIDRInputs, PHRInputs);
end 

% End of seismic risk calculation
 toc
