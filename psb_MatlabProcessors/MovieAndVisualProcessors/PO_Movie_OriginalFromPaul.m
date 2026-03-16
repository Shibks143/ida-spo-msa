load (['DATA_' 'PO' '.mat'])

h = 12000; %height of structure in mm

aviobj=avifile('PO_Frame.avi','fps',15); 

for ind=1:length(node_out(:,1))
    
    RoofDriftLevel = node_out(ind,4)/12000;
    
    for(i=1:colFiles)
        c1(i) = IsAHinge(col_1_out{i}(:,4),col_1_out{i}(:,2),ind);
        c2(i) = IsAHinge(col_2_out{i}(:,4),col_2_out{i}(:,2),ind);
        c3(i) = IsAHinge(col_3_out{i}(:,4),col_3_out{i}(:,2),ind);
    end
    
    for(i=1:beamFiles)
        b1(i) = IsAHinge(beam_1_out{i}(:,4),beam_1_out{i}(:,2),ind);
        b2(i) = IsAHinge(beam_2_out{i}(:,4),beam_2_out{i}(:,2),ind);
        b3(i) = IsAHinge(beam_3_out{i}(:,4),beam_3_out{i}(:,2),ind);
    end
    
    columns = [ reshape(c3,2,4);reshape(c2,2,4);reshape(c1,2,4)];
    columns = [columns(2,:);
        columns(1,:);
        columns(4,:);
        columns(3,:);
        columns(6,:);
        columns(5,:)];
    beams = [b3;b2;b1];
     
    nodes = nodalDrifts(node_out,ind);

%     plot(node_out(:,4)/h,(node_out(:,1))*12.629,'b',[RoofDriftLevel RoofDriftLevel],[0 12.629*(nodes(1))],'r--x',0,1262.9,'go')
%     axis([0 0.1 0 3200])
%     xlabel('Roof Drift Level')
%     ylabel('Base Shear Force (kN)')
%     title(['Pushover Curve - Roof Drift Level ',num2str(nodes(5))])
%     grid on
     
    
    hold on
    lines1 = 25.4*[0 0;0 472.32;826.56 472.32; 826.56 0];
    lines2 = 25.4*[275.52 0;275.52 472.32;551.04 472.32;551.04 0];
    lines3 = 25.4*[0 157.44;826.56 157.44;826.56 314.88;0 314.88];
    plot(lines1(:,1),lines1(:,2),'b',lines2(:,1),lines2(:,2),'b',lines3(:,1),lines3(:,2),'b')
    axis([-1000 22000 -1000 13000])
    title(['Hinge Locations - Roof Drift Level ',num2str(nodes(5))])
    
    c_plot = 25.4*[452.32*ones(1,4);334.88*ones(1,4);294.88*ones(1,4);177.44*ones(1,4);137.44*ones(1,4);20*ones(1,4)];
    s = size(columns);
    for(i=1:s(1))
        for(j=1:s(2))
            if(columns(i,j))
                plot(25.4*275.52*(j-1),c_plot(i,j),'ro')
            end
        end
    end
    
    b_plot = 25.4*[20*ones(3,1) 255.52*ones(3,1) 295.52*ones(3,1) 531.04*ones(3,1) 571.04*ones(3,1) 806.56*ones(3,1)];
    s = size(beams);
    for(i=1:s(1))
        for(j=1:s(2))
            if(beams(i,j))
                plot(b_plot(i,j),25.4*157.44*(4-i),'ro')
            end
        end
    end
    text(500,0,['RDR = ' num2str(nodes(5))])
    hold off
     
    
%     [x,y]=stairs(nodes(2:4));
%     plot([y;y(5)],[x-1;3])
%     axis([0,0.12,0,3])       
%     xlabel('IDR')
%     ylabel('Floor')
%     title(['Drift Profile - Roof Drift Level ',num2str(nodes(5))])
%     grid on
    
    frame = getframe(gca);
    aviobj=addframe(aviobj,frame);
    close all

end

aviobj=close(aviobj); 