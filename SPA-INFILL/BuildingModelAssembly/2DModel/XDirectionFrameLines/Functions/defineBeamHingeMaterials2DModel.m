% This function is used to generate the tcl file that defines the beam
% hinge materials for a 3D Model in OpenSees     
function defineBeamHingeMaterials2DModel(buildingGeometry,...
    xBeamHingeObjects,zBeamHingeObjects,BuildingModelDirectory,...
    FrameLineNumber,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generating Tcl File with Beam Hinge Material Models Defined        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd XDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineBeamHingeMaterials2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define beam hinge material models');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Initialize integer used as beam hinge material tag
    BeamHingeTag = 70000;

    % Defining beam hinge materials
    fprintf(fid,'%s\n','# Define beam hinge materials');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        % Defining X-Direction beam hinge materials
        fprintf(fid,'%s\n','# X-Direction beam hinge materials');
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:buildingGeometry.numberOfXBays
            % Defining beam hinge materials
            % Material model tag
            fprintf(fid,'%s\n',strcat('# X-Direction Beam, Level',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionBeamHingeMatLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%u',BeamHingeTag);  
            BeamHingeTag = BeamHingeTag + 1;
            fprintf(fid,'%s\n',';');        

            % EI Values
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionEIEffLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%10.3f',xBeamHingeObjects{i,k,j}.EIeff);       
            fprintf(fid,'%s\n',';'); 

            % My Values
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionMyLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%10.3f',xBeamHingeObjects{i,k,j}.My);       
            fprintf(fid,'%s\n',';');

            % McOverMy Values
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionMcOverMyLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%10.3f',xBeamHingeObjects{i,k,j}.McOverMy);       
            fprintf(fid,'%s\n',';');

            % thetaCap Values
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionThetaCapLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%10.3f',xBeamHingeObjects{i,k,j}.thetaCap);       
            fprintf(fid,'%s\n',';');

            % thetaPC Values
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionThetaPCLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%10.3f',xBeamHingeObjects{i,k,j}.thetaPC);      
            fprintf(fid,'%s\n',';');

            % lambda Values
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionLambdaLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%10.3f',xBeamHingeObjects{i,k,j}.lambda);         
            fprintf(fid,'%s\n',';');

            % Beam Length Values
            fprintf(fid,'%s\t','set');      
            fprintf(fid,'%s\t',strcat('XDirectionBeamLengthLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%10.3f',xBeamHingeObjects{i,k,j}.beamLength);       
            fprintf(fid,'%s\n',';');

            % Define Material Model
            fprintf(fid,'%s\t','CreateIbarraMaterial');      
            fprintf(fid,'%s\t',strcat('$','XDirectionBeamHingeMatLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%s\t',strcat('$XDirectionEIEffLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));
            fprintf(fid,'%s\t',strcat('$XDirectionMyLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),...
                'Bay',num2str(k)));
            fprintf(fid,'%s\t',strcat('[expr -$XDirectionMyLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',...
                num2str(k),']'));
            fprintf(fid,'%s\t',strcat('$XDirectionMcOverMyLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));
            fprintf(fid,'%s\t',strcat('$XDirectionThetaCapLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));
            fprintf(fid,'%s\t',strcat('[expr -$XDirectionThetaCapLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',...
                num2str(k),']'));        
            fprintf(fid,'%s\t',strcat('$XDirectionThetaPCLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%s\t',strcat('$XDirectionLambdaLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k))); 
            fprintf(fid,'%10.3f\t',1.0);        
            fprintf(fid,'%s\t','$resStrRatioBeamColumnFlexure');
            fprintf(fid,'%s\t','$stiffFactor1');       
            fprintf(fid,'%s\t','$stiffFactor2');    
            fprintf(fid,'%s',strcat('$XDirectionBeamLengthLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k)));        
            fprintf(fid,'%s\n',';');
            fprintf(fid,'%s\n',''); 
            end
        end

        % Defining Z-Direction beam hinges
        fprintf(fid,'%s\n','# Z-Direction beam hinges');
        % Loop over the number of Z-Direction bays
        for j = 1:buildingGeometry.numberOfZBays
            % Looping over the number of Z-direction bays
            for k = 1:buildingGeometry.numberOfXBays + 1
                % Defining beam hinge materials
                % Material model tag
                fprintf(fid,'%s\n',strcat('# Z-Direction Beam, Level',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionBeamHingeMatLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%u',BeamHingeTag);  
                BeamHingeTag = BeamHingeTag + 1;
                fprintf(fid,'%s\n',';');        

                % EI Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionEIEffLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%10.3f',zBeamHingeObjects{i,k,j}.EIeff);       
                fprintf(fid,'%s\n',';'); 

                % My Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionMyLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%10.3f',zBeamHingeObjects{i,k,j}.My);       
                fprintf(fid,'%s\n',';');

                % McOverMy Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionMcOverMyLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%10.3f',zBeamHingeObjects{i,k,j}.McOverMy);       
                fprintf(fid,'%s\n',';');

                % thetaCap Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionThetaCapLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%10.3f',zBeamHingeObjects{i,k,j}.thetaCap);      
                fprintf(fid,'%s\n',';');

                % thetaPC Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionThetaPCLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                num2str(j)));        
                fprintf(fid,'%10.3f',zBeamHingeObjects{i,k,j}.thetaPC);        
                fprintf(fid,'%s\n',';');

                % lambda Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionLambdaLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%10.3f',zBeamHingeObjects{i,k,j}.lambda);       
                fprintf(fid,'%s\n',';');

                % Beam Length Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ZDirectionBeamLengthLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%10.3f',zBeamHingeObjects{i,k,j}.beamLength);       
                fprintf(fid,'%s\n',';');

                % Define Material Model
                fprintf(fid,'%s\t','CreateIbarraMaterial');      
                fprintf(fid,'%s\t',strcat('$',...
                    'ZDirectionBeamHingeMatLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%s\t',strcat('$ZDirectionEIEffLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));
                fprintf(fid,'%s\t',strcat('$ZDirectionMyLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),...
                    'Bay',num2str(j)));
                fprintf(fid,'%s\t',strcat('[expr -$ZDirectionMyLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),...
                    'Bay',num2str(j),']'));
                fprintf(fid,'%s\t',strcat('$ZDirectionMcOverMyLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));
                fprintf(fid,'%s\t',strcat('$ZDirectionThetaCapLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));
                fprintf(fid,'%s\t',strcat(...
                    '[expr -$ZDirectionThetaCapLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j),']'));        
                fprintf(fid,'%s\t',strcat('$ZDirectionThetaPCLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%s\t',strcat('$ZDirectionLambdaLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j))); 
                fprintf(fid,'%10.3f\t',1.0);        
                fprintf(fid,'%s\t','$resStrRatioBeamColumnFlexure');
                fprintf(fid,'%s\t','$stiffFactor1');       
                fprintf(fid,'%s\t','$stiffFactor2');    
                fprintf(fid,'%s',strcat('$ZDirectionBeamLengthLevel',...
                    num2str(i + 1),'XColumnLine',num2str(k),'Bay',...
                    num2str(j)));        
                fprintf(fid,'%s\n',';');
                fprintf(fid,'%s\n','');
            end
            fprintf(fid,'%s\n','');
        end
    end
    fprintf(fid,'%s\n','puts "beam hinge materials defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

