function [thetaU_p, thetaU_n, thetaCap_p, thetaCap_n] = fun1_extractThetaU(bldgID, eleID)

% both outputs return algebraic value

% This function extracts ultimate rotation capacity of the eleID
% address to model directory is extracted using H:\DamageIndex\Automated\returnModelFolderInfo 
% further, psb_ModelCodePastedFromExcelVBA.tcl and fgetl is used  

% bldgID = '2211v03_sca2';
% eleID = 20203;


baseFolder = pwd;
%% material tag number
% for columns, thetaCapPos and thetaCapNeg are equal
% for beams, in our model, values of both, thetaCapPos and thetaCapNeg, are used in same mat definition 
matTag = eleID * 10 + 1;

% cd H:\DamageIndex\Automated
cd ..\..\..\DamageIndex\Automated\
[modelFolder, ~, ~, ~] = returnModelFolderInfo(bldgID);
% lastwarn('') % resetting last warning message;
cd(modelFolder);
fileName = 'psb_ModelCodePastedFromExcelVBA.tcl';

fid = fopen(fileName,'r');
while 0 == 0 
    newline = fgetl(fid);
    
    newlineSplit = strsplit(strtrim(newline));
    if size(newlineSplit, 2) > 10 && strcmp(newlineSplit{1, 1}, 'CreateIbarraMaterial') && str2double(newlineSplit{1, 2}) == matTag
        thetaCap_p = str2double(newlineSplit{1, 7});
        thetaCap_n = -str2double(newlineSplit{1, 8}); % return absolute value of negative capping rotation
        thetaPC = str2double(newlineSplit{1, 9});
        
        thetaU_p = thetaCap_p + thetaPC;
        thetaU_n = thetaCap_n + thetaPC; % both are algebraic values

        fclose(fid);
        break
    end
end

cd(baseFolder)