function safetySetup()
% This function is to start the safety set up of the 
 
    axis([-3,3,-3,3,0,3]);
    view(45,40);
    hold on

    
    %Safety features placement
   %tut way to place objects and then rotate them
    PlaceObject('fenceFinal.ply',[ 0,0,0; 0,0.75,0 ]); %placing object at that coordinate point
    h = PlaceObject('fenceFinal.ply',[1,0,0]);
    verts = [get(h,'Vertices'), ones(size(get(h,'Vertices'),1),1)] * trotz(pi/2);
    set(h,'Vertices',verts(:,1:3))


    camlight;

    
end