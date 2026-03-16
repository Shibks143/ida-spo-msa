%
% Procedure: PlotMRotTHDisplEle.m
% -------------------
% This procedure plots the Moment-Rotation TH of the hinge region of a member discretized using the dispBeamColumn element.  Since the hinge region is discretized,
%   the rotation of the hinge region is found by taking the difference of the rotations of the nodes on each side of the discretized hinge region.  The moment is 
%   taken as the moment at the face of the joint (at the face of the member end, not including joint effects).
% 
% Assumptions and Notices: 
%           - The node numbers that are used depend on the element number and the number of elements used in the hinge region.
%           - This is now made for a model without joints, but when joints are added, this procedure will need to be modified to use
%               the correct new node number at the face of the joint (for now, I am simply using the node at the center of the centerline
%               model "joint").
%
% Author: Curt Haselton 
% Date Written: 6-10-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - memberNum - the member number (NOT element number) - i.e. member 10 is made up of elements 100, 101, ..., 107, 108.
%           - memberEndNum - 1 for end i (left or bottom) and 2 for end j (top or right).
%           - numElePerHinge - number of element per hinge region (you can currently use 2 or 3).  This is used to know what node numbers to 
%                               use when computing rotations.
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = PlotMRotTHDisplEle(memberNum, memberEndNum, numElePerHinge, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);

% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);

load('DATA_allDataForThisSingleRun.mat');

% Get data and do calcs. for plot
    % Get the end moment TH
        % Find the element number to use for the end moment, and get moment TH...
        %   Note that for end i, we use the moment for dof 3 and for end j, we use dof 6.
        %   The moments are postitive if they agree with the "right hand rule" (i.e. the usual element force sign convention)
        if(memberEndNum == 1)
            endElementNum = memberNum * 10;
            memberEndMomentTH = elementArray{endElementNum}.localForceTH(:, 3);
        elseif(memberEndNum == 2)
            endElementNum = memberNum * 10 + 8;
            memberEndMomentTH = elementArray{endElementNum}.localForceTH(:, 6);
        else
            error('The memberEndNum must be 1 or 2!!!')
        end

    % Now find the node numbers to use to find the rotation of the hinge region, tehn compute relative rotations...
    %   Note that this is based on the end that is used as well as the number of elements in the hinge region...
    %   Note that the hinge rotations are positive when the rotation in a "smile". 
    %   Note also that all of the node numbering is based on the numbering comvenvention that I am using (shown on the building diagram).
        if(memberEndNum == 1)
            % If this is the case, we know that the left node (at the joint face) is...
            leftNodeNum = memberNum * 10;
            % Find the right node number based on the number of elements in the hinge region...
                if(numElePerHinge == 2)
                    rightNodeNum = memberNum * 10 + 2;
                elseif(numElePerHinge == 3)
                    rightNodeNum = memberNum * 10 + 3;
                elseif(numElePerHinge == 4)
                    rightNodeNum = memberNum * 10 + 4;
                else
                    error('The numElePerHinge must be 2 or 3 or 4!!!')
                end
        elseif(memberEndNum == 2)
            % If this is the case, we know that the right node (at the joint face) is...
            rightNodeNum = memberNum * 10 + 9;
                % Find the left node number based on the number of elements in the hinge region...
                if(numElePerHinge == 2)
                    leftNodeNum = memberNum * 10 + 9 - 2;
                elseif(numElePerHinge == 3)
                    leftNodeNum = memberNum * 10 + 9 - 3; 
                elseif(numElePerHinge == 4)
                    leftNodeNum = memberNum * 10 + 9 - 4;
                else
                    error('The numElePerHinge must be 2 or 3 or 4!!!')
                end
        else
            error('The memberEndNum must be 1 or 2!!!')
        end


    % Compute the hinge rotation TH
        % Find left and right node rotation TH's...
        leftNodeDisplTH = nodeArray{rightNodeNum}.displTH(:, 3);    % Get column 3 - the rotations
        rightNodeDisplTH = nodeArray{leftNodeNum}.displTH(:, 3);
    
        % Compute hinge rotation TH's (positive rotation is when the hinge "smiles")...
        hingeRotTH = rightNodeDisplTH - leftNodeDisplTH;
        
        
    % Find the length of the vectors that should be plotted
        % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
        length1 = length(hingeRotTH);
        length2 = length(memberEndMomentTH);
        minLength = min(length1, length2);
  
        if(minLength < maxNumPoints)
            %Just use total number of entries for each data column
            numDataPointsUsed = minLength;
        else
            %Use the maxNumPoints provide by the caller
            numDataPointsUsed = maxNumPoints;
        end
    
    % Do the plot
        % Plot - note that the psuedoTimeVector is from the file that was opened 
        plot(hingeRotTH(1:numDataPointsUsed), memberEndMomentTH(1:numDataPointsUsed), markerType);
    
        hold on
        legendName = sprintf('Hinge of Member %d, end %d', memberNum, memberEndNum);
        legend(legendName);
        grid on
        titleText = sprintf('Hysteretic Hinge Responce of End %d of Member %d, Sa of %.2f for EQ Number %.0f for Analysis %s', memberEndNum, memberNum, saTOneForRun, eqNumber, analysisType);
        title(titleText);
        yLabel = sprintf('End Moment (kip-inch)');
        ylabel(yLabel);
        xlabel('Hinge Rotation (radians)');
        hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
