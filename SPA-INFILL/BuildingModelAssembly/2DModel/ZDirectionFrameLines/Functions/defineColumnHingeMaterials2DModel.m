% This function is used to generate the tcl file that defines the column
% hinge materials for a 3D Model in OpenSees     
function defineColumnHingeMaterials2DModel(buildingGeometry,...
    columnHingeObjects,BuildingModelDirectory,FrameLineNumber,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generating Tcl File with Column Hinge Material Models Defined      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd ZDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineColumnHingeMaterials2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define column hinge material models');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Initialize integer used as column hinge material tag
    ColumnFlexuralHingeTag = 600000;
    ColumnShearHingeTag = 6000;


    % Defining column hinge materials
    fprintf(fid,'%s\n','# Define column hinge materials');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\n',strcat('# Columm Hinges Story ', num2str(i)));
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                % Defining column hinge materials for bending about global
                % z-axis
                % Flexural material model tag
                fprintf(fid,'%s\n',strcat('# Story',num2str(i),'Pier',...
                    num2str(k),num2str(j),'Bending about global z-axis'));
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat(...
                    'ColumnGlobalZAxisFlexuralHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%u',ColumnFlexuralHingeTag);  
                ColumnFlexuralHingeTag = ColumnFlexuralHingeTag + 1;
                fprintf(fid,'%s\n',';');

                % EI Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('EIeffZZColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.EIeffZZ);       
                fprintf(fid,'%s\n',';'); 

                % My Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('MyZZColumnStory',num2str(i),...
                    'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.MyZZ);       
                fprintf(fid,'%s\n',';');

                % McOverMy Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('McOverMyColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.McOverMy); 
                fprintf(fid,'%s\n',';');

                % thetaCap Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('thetaCapColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.thetaCap);    
                fprintf(fid,'%s\n',';');

                % thetaPC Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('thetaPCColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.thetaPC);        
                fprintf(fid,'%s\n',';');

                % lambda Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('lambdaColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.lambda);    
                fprintf(fid,'%s\n',';');

                % Column Length Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnLengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',...
                    columnHingeObjects{i,k,j}.columnLength);     
                fprintf(fid,'%s\n',';');

                 % Define Flexural Material Model
                fprintf(fid,'%s\t','CreateIbarraMaterial');      
                fprintf(fid,'%s\t',strcat('$',...
                    'ColumnGlobalZAxisFlexuralHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\t',strcat('$EIeffZZColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('$MyZZColumnStory',num2str(i),...
                    'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('[expr -$MyZZColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j),']'));
                fprintf(fid,'%s\t',strcat('$McOverMyColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('$thetaCapColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('[expr -$thetaCapColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j),']'));        
                fprintf(fid,'%s\t',strcat('$thetaPCColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\t',strcat('$lambdaColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j))); 
                fprintf(fid,'%10.3f\t',1.0);        
                fprintf(fid,'%s\t','$resStrRatioBeamColumnFlexure');
                fprintf(fid,'%s\t','$stiffFactor1');       
                fprintf(fid,'%s\t','$stiffFactor2');    
                fprintf(fid,'%s',strcat('$ColumnLengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\n',';');
                fprintf(fid,'%s\n','');

                % Shear material model tag
                fprintf(fid,'%s\n',strcat('# Story',num2str(i),'Pier',...
                    num2str(k),num2str(j),'XShear'));
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnShearXHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%u',ColumnShearHingeTag);  
                ColumnShearHingeTag = ColumnShearHingeTag + 1;
                fprintf(fid,'%s\n',';');       

                % Column shear strength values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnShearXStrengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.VnX);      
                fprintf(fid,'%s\n',';');

                % Column shear stiffness values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnShearXStiffnessStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.kShearXX);        
                fprintf(fid,'%s\n',';');

                % Column deltaPCShear values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnDeltaPCShearStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',...
                    columnHingeObjects{i,k,j}.deltaPCShear);    
                fprintf(fid,'%s\n',';');       

                % Define Shear Material Model
                fprintf(fid,'%s\t','CreateIbarraShearMaterial');      
                fprintf(fid,'%s\t',strcat('$',...
                    'ColumnShearXHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\t',strcat('$ColumnShearXStiffnessStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('$ColumnShearXStrengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat(...
                    '[expr -$ColumnShearXStrengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j),']'));
                fprintf(fid,'%10.3f\t',1.01);
                fprintf(fid,'%s\t',(.01 + .2*(...
                    columnHingeObjects{i,k,j}.VnX/...
                    columnHingeObjects{i,k,j}.kShearXX)/.2));
                fprintf(fid,'%s\t',-(.01 + .2*(...
                    columnHingeObjects{i,k,j}.VnX/...
                    columnHingeObjects{i,k,j}.kShearXX)/.2));
                fprintf(fid,'%s\t',strcat('$ColumnDeltaPCShearStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s','$resStrRatioColumnShear');        
                fprintf(fid,'%s\n',';');
                fprintf(fid,'%s\n',''); 


                % Defining column hinge materials for bending about global
                % x-axis
                % Flexural material model tag
                fprintf(fid,'%s\n',strcat('# Story',num2str(i),'Pier',...
                    num2str(k),num2str(j),'Bending about global x-axis'));
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat(...
                    'ColumnGlobalXAxisFlexuralHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%u',ColumnFlexuralHingeTag);  
                ColumnFlexuralHingeTag = ColumnFlexuralHingeTag + 1;
                fprintf(fid,'%s\n',';');

                % EI Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('EIeffXXColumnStory',...
                    num2str(i),'Pier',...
                    num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.EIeffXX);       
                fprintf(fid,'%s\n',';'); 

                % My Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('MyXXColumnStory',num2str(i),...
                    'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.MyXX);       
                fprintf(fid,'%s\n',';');

                % McOverMy Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('McOverMyColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.McOverMy); 
                fprintf(fid,'%s\n',';');

                % thetaCap Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('thetaCapColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.thetaCap);    
                fprintf(fid,'%s\n',';');

                % thetaPC Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('thetaPCColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.thetaPC);        
                fprintf(fid,'%s\n',';');

                % lambda Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('lambdaColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.lambda);    
                fprintf(fid,'%s\n',';');

                % Column Length Values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnLengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.columnLength);     
                fprintf(fid,'%s\n',';');

                 % Define Flexural Material Model
                fprintf(fid,'%s\t','CreateIbarraMaterial');      
                fprintf(fid,'%s\t',strcat('$',...
                    'ColumnGlobalXAxisFlexuralHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\t',strcat('$EIeffXXColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('$MyXXColumnStory',num2str(i),...
                    'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('[expr -$MyXXColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j),']'));
                fprintf(fid,'%s\t',strcat('$McOverMyColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('$thetaCapColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('[expr -$thetaCapColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j),']'));        
                fprintf(fid,'%s\t',strcat('$thetaPCColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\t',strcat('$lambdaColumnStory',...
                    num2str(i),'Pier',num2str(k),num2str(j))); 
                fprintf(fid,'%10.3f\t',1.0);        
                fprintf(fid,'%s\t','$resStrRatioBeamColumnFlexure');
                fprintf(fid,'%s\t','$stiffFactor1');       
                fprintf(fid,'%s\t','$stiffFactor2');    
                fprintf(fid,'%s',strcat('$ColumnLengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\n',';');
                fprintf(fid,'%s\n','');

                % Shear material model tag
                fprintf(fid,'%s\n',strcat('# Story',num2str(i),'Pier',...
                    num2str(k),num2str(j),'ZShear'));
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnShearZHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%u',ColumnShearHingeTag);  
                ColumnShearHingeTag = ColumnShearHingeTag + 1;
                fprintf(fid,'%s\n',';');       

                % Column shear strength values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnShearZStrengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.VnZ);      
                fprintf(fid,'%s\n',';');

                % Column shear stiffness values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnShearZStiffnessStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',columnHingeObjects{i,k,j}.kShearZZ);        
                fprintf(fid,'%s\n',';');

                % Column deltaPCShear values
                fprintf(fid,'%s\t','set');      
                fprintf(fid,'%s\t',strcat('ColumnDeltaPCShearStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%10.3f',...
                    columnHingeObjects{i,k,j}.deltaPCShear);    
                fprintf(fid,'%s\n',';');       

                % Define Shear Material Model
                fprintf(fid,'%s\t','CreateIbarraShearMaterial');      
                fprintf(fid,'%s\t',strcat('$',...
                'ColumnShearZHingeMatStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));        
                fprintf(fid,'%s\t',strcat('$ColumnShearZStiffnessStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat('$ColumnShearZStrengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s\t',strcat(...
                    '[expr -$ColumnShearZStrengthStory',...
                    num2str(i),'Pier',num2str(k),num2str(j),']'));
                fprintf(fid,'%10.3f\t',1.01);
                fprintf(fid,'%s\t',(.01 + .2*(...
                    columnHingeObjects{i,k,j}.VnZ/...
                    columnHingeObjects{i,k,j}.kShearZZ)/.2));
                fprintf(fid,'%s\t',-(.01 + .2*(...
                    columnHingeObjects{i,k,j}.VnZ/...
                    columnHingeObjects{i,k,j}.kShearZZ)/.2));
                fprintf(fid,'%s\t',strcat('$ColumnDeltaPCShearStory',...
                    num2str(i),'Pier',num2str(k),num2str(j)));
                fprintf(fid,'%s','$resStrRatioColumnShear');        
                fprintf(fid,'%s\n',';');
                fprintf(fid,'%s\n','');
            end
        end    
    end
    fprintf(fid,'%s\n','puts "column hinge materials defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);

end

