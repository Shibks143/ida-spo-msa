

% Initialize stuff
maxNumPoints = 1000000000;
markerType = 'b';
figureNum = 0;
saLevelNum = 0.00;
eqName = 'Pushover';


% Define the elements and dof's that you want to to see the plastic deformations during the PO
% elementLIST = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36]
elementLIST = [1,2,3,4,5]

eleDofNumLIST = [1,2,3]





% Loop and make plots

    for elementNumINDEX = 1:length(elementLIST)
        
        for eleDofNumINDEX = 1:length(eleDofNumLIST)

                eleNum = elementLIST(elementNumINDEX)
                eleDofNum = eleDofNumLIST(eleDofNumINDEX)
                figureNum = figureNum + 1;

                % Do all of the stuff in here that you want done for each of these runs
                figure(figureNum);
                
                PlotPushoverElePlasticDef
                


        end 

    end
    
    
    

    
  