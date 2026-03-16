% This function is used to generate the tcl file that defines the infill
% strut materials for a 3D Model in OpenSees     
function defineInfillStrutMaterialsForEigenValueAnalysis2DModel(...
    buildingGeometry,xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generating Tcl File with Infill Strut Material Models Defined      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    % Load text file with XDirection infill strut locations
    cd(XDirectionInfillPropertiesLocation)
    xInfillLocation = load('xInfillLocation.txt');
    
    
    % Load text file with ZDirection infill strut locations
    cd(ZDirectionInfillPropertiesLocation)
    zInfillLocation = load('zInfillLocation.txt');
    strainHardeningRatio = load('strainHardeningRatio.txt');
    strainSofteningRatio = load('strainSofteningRatio.txt');
    deltaCOverDeltaY = load('deltaCOverDeltaY.txt');
    
    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd ZDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineInfillStrutMaterialsForEigenValueAnalysis2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define infill strut material models');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Initialize integer used as infill strut material tag
    InfillStrutMaterialTag = 50000;

    % Defining variables common to all struts
    fprintf(fid,'%s\n','# Defining variables common to all struts');
    fprintf(fid,'%s\t','set');
    fprintf(fid,'%s\t','InfillStrutHardeningRatio');
    fprintf(fid,'%10.3f',strainHardeningRatio); 
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\t','set');
    fprintf(fid,'%s\t','InfillStrutSofteningRatio');
    fprintf(fid,'%10.3f',strainSofteningRatio); 
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\t','set');
    fprintf(fid,'%s\t','resStrRatioStrut');
    fprintf(fid,'%10.3f',0.01); 
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\t','set');
    fprintf(fid,'%s\t','deltaCOverdeltaYInfillStrut');
    fprintf(fid,'%10.3f',deltaCOverDeltaY); 
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\t','set');
    fprintf(fid,'%s\t','lambdaInfillStrut');
    fprintf(fid,'%10.3f',0); 
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\t','set');
    fprintf(fid,'%s\t','cInfillStrut');
    fprintf(fid,'%10.3f',1); 
    fprintf(fid,'%s\n',';');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining infill strut materials
    fprintf(fid,'%s\n','# Define infill materials');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        % Defining X-Direction infill strut materials
        fprintf(fid,'%s\n','# x-Direction infill materials');
        % Loop over the number of Z-Direction column lines
        for j = 1:buildingGeometry.numberOfZBays + 1
            % Loop over number of X-Direction bays
            for k = 1:buildingGeometry.numberOfXBays
                    if xInfillLocation(i,(j - 1)*...
                        buildingGeometry.numberOfXBays + k) == 1
                    % Define material model tag
                    % Central strut
                    fprintf(fid,'%s\n',strcat('# Story',num2str(i),...
                        'Bay',...
                    num2str(k),'Line',num2str(j)));
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat(...
                        'CentralStrutXStory',...
                    num2str(i),'Bay',num2str(k),'Line',num2str(j)));
                    fprintf(fid,'%u',InfillStrutMaterialTag);  
                    InfillStrutMaterialTag = InfillStrutMaterialTag + 1;
                    fprintf(fid,'%s\n',';');

                    % Stiffness strut
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat('KStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j)));
                    fprintf(fid,'%10.3f',...
                        xDirectionInfillObjects{i,k,j}.Kstrut);
                    fprintf(fid,'%s\n',';');

                    % Fy strut
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat('FyStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j)));
                    fprintf(fid,'%10.3f',...
                        xDirectionInfillObjects{i,k,j}.FyStrut);
                    fprintf(fid,'%s\n',';');

                    % Strut length values
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat(...
                        'LengthStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j)));
                    fprintf(fid,'%10.3f',...
                        xDirectionInfillObjects{i,k,j}.length);
                    fprintf(fid,'%s\n',';');

                    % Define Infill Strut Material Model
                    % Central strut
                    fprintf(fid,'%s\t','uniaxialMaterial');
                    fprintf(fid,'%s\t','Clough');
                    fprintf(fid,'%s\t',strcat('$',...
                        'CentralStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j)));       
                    fprintf(fid,'%s\t',strcat(...
                        '[expr $KStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j),...
                        '*$LengthStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',...
                        num2str(j),'*1.0]'));
                    fprintf(fid,'%s\t',strcat(...
                        '[expr $FyStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',...
                        num2str(j),'*1.0]'));
                    fprintf(fid,'%s\t',strcat(...
                        '[expr -$FyStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',...
                        num2str(j),'*1.0]'));  
                    fprintf(fid,'%s\t','$InfillStrutHardeningRatio');
                    fprintf(fid,'%s\t','$resStrRatioStrut');
                    fprintf(fid,'%s\t','$InfillStrutSofteningRatio');            
                    fprintf(fid,'%s\t',strcat(...
                        '[expr $deltaCOverdeltaYInfillStrut*',...
                        '($FyStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',...
                        num2str(j),'/$KStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',...
                        num2str(j),')/$LengthStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',...
                        num2str(j),']'));
                    fprintf(fid,'%s\t',strcat(...
                        '[expr -$deltaCOverdeltaYInfillStrut*',...
                        '($FyStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j),...
                        '/$KStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j),...
                        ')/$LengthStrutXStory',...
                        num2str(i),'Bay',num2str(k),'Line',num2str(j),...
                        ']'));
                    fprintf(fid,'%s\t','$lambdaInfillStrut');
                    fprintf(fid,'%s\t','$lambdaInfillStrut');            
                    fprintf(fid,'%s\t','$lambdaInfillStrut');            
                    fprintf(fid,'%s\t','$lambdaInfillStrut');
                    fprintf(fid,'%s\t','$cInfillStrut');
                    fprintf(fid,'%s\t','$cInfillStrut');            
                    fprintf(fid,'%s\t','$cInfillStrut');            
                    fprintf(fid,'%s','$cInfillStrut'); 
                    fprintf(fid,'%s\n',';');
                    end        
            end
        end

        % Defining Z-Direction infill strut materials
        fprintf(fid,'%s\n','# z-Direction infill materials');
        % Loop over the number of Z-Direction bays
        for j = 1:buildingGeometry.numberOfZBays
            % Loop over number of X-Direction column lines
            for k = 1:buildingGeometry.numberOfXBays + 1
                    if zInfillLocation(i,(j - 1)*...
                        (buildingGeometry.numberOfXBays + 1) + k) == 1
                    % Define material model tag
                    % Central strut
                    fprintf(fid,'%s\n',strcat('# Story',num2str(i),'Bay',...
                    num2str(j),'Line',num2str(k)));
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat(...
                        'CentralStrutZStory',...
                    num2str(i),'Bay',num2str(j),'Line',num2str(k)));
                    fprintf(fid,'%u',InfillStrutMaterialTag);  
                    InfillStrutMaterialTag = InfillStrutMaterialTag + 1;
                    fprintf(fid,'%s\n',';');

                    % Stiffness strut
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat('KStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k)));
                    fprintf(fid,'%10.3f',...
                        zDirectionInfillObjects{i,k,j}.Kstrut);
                    fprintf(fid,'%s\n',';');

                    % Fy strut
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat('FyStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k)));
                    fprintf(fid,'%10.3f',...
                        zDirectionInfillObjects{i,k,j}.FyStrut);
                    fprintf(fid,'%s\n',';');

                    % Strut length values
                    fprintf(fid,'%s\t','set');      
                    fprintf(fid,'%s\t',strcat('LengthStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k)));
                    fprintf(fid,'%10.3f',...
                        zDirectionInfillObjects{i,k,j}.length);
                    fprintf(fid,'%s\n',';');

                    % Define Infill Strut Material Model
                    % Central strut
                    fprintf(fid,'%s\t','uniaxialMaterial');
                    fprintf(fid,'%s\t','Clough');
                    fprintf(fid,'%s\t',strcat('$',...
                        'CentralStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k)));       
                    fprintf(fid,'%s\t',strcat(...
                        '[expr $KStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k),...
                        '*$LengthStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',...
                        num2str(k),'*1.0]'));
                    fprintf(fid,'%s\t',strcat(...
                        '[expr $FyStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',...
                        num2str(k),'*1.0]'));
                    fprintf(fid,'%s\t',strcat(...
                        '[expr -$FyStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',...
                        num2str(k),'*1.0]'));  
                    fprintf(fid,'%s\t','$InfillStrutHardeningRatio');
                    fprintf(fid,'%s\t','$resStrRatioStrut');
                    fprintf(fid,'%s\t','$InfillStrutSofteningRatio');            
                    fprintf(fid,'%s\t',strcat(...
                        '[expr $deltaCOverdeltaYInfillStrut*',...
                        '($FyStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',...
                        num2str(k),'/$KStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',...
                        num2str(k),')/$LengthStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',...
                        num2str(k),']'));
                    fprintf(fid,'%s\t',strcat(...
                        '[expr -$deltaCOverdeltaYInfillStrut*',...
                        '($FyStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k),...
                        '/$KStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k),...
                        ')/$LengthStrutZStory',...
                        num2str(i),'Bay',num2str(j),'Line',num2str(k),...
                        ']'));
                    fprintf(fid,'%s\t','$lambdaInfillStrut');
                    fprintf(fid,'%s\t','$lambdaInfillStrut');            
                    fprintf(fid,'%s\t','$lambdaInfillStrut');            
                    fprintf(fid,'%s\t','$lambdaInfillStrut');
                    fprintf(fid,'%s\t','$cInfillStrut');
                    fprintf(fid,'%s\t','$cInfillStrut');            
                    fprintf(fid,'%s\t','$cInfillStrut');            
                    fprintf(fid,'%s','$cInfillStrut'); 
                    fprintf(fid,'%s\n',';');
                    end        
            end
        end
    end    
    fprintf(fid,'%s\n','puts "infill materials defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

