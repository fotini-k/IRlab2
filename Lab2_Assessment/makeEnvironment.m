function [table, firstAid, estop, glassPanel1, glassPanel2, glassPanel3, glassPanel4, glassPanel5, gardenBed, seedBowl] = makeEnvironment()

    hold on;
    view(3);
    
    table = PlaceObject('myTable5.ply',[0,0,-0.54]);
    firstAid = PlaceObject('firstAid.ply',[-0.7,0.3,0.15]);
    estop = PlaceObject('eStop.ply',[-0.7,-0.5,0.05]);
    
    glassPanel1 = PlaceObject('longGlassPanel.ply',[-0.1,0.7,0]);
    glassPanel2 = PlaceObject('longGlassPanel.ply',[1,0.7,0]);
    
    glassPanel3 = PlaceObject('shortGlassPanel.ply',[-0.7,1,0]);
    verts = [get(glassPanel3,'Vertices'), ones(size(get(glassPanel3,'Vertices'),1),1)] * trotz(pi/2);
    set(glassPanel3,'Vertices',verts(:,1:3))
    
    glassPanel4 = PlaceObject('shortGlassPanel.ply',[0.6,1,0]);
    verts = [get(glassPanel4,'Vertices'), ones(size(get(glassPanel4,'Vertices'),1),1)] * trotz(pi/2);
    set(glassPanel4,'Vertices',verts(:,1:3))
    
    glassPanel5 = PlaceObject('longGlassPanel.ply',[-0.1,0.7,0]);
    verts = [get(glassPanel5,'Vertices'), ones(size(get(glassPanel5,'Vertices'),1),1)] * troty(-pi/2);
    verts(:, 3) = verts(:, 3) + 1;
    set(glassPanel5,'Vertices',verts(:,1:3))

    gardenBed = PlaceObject('gardenBed.ply',[0,0,0]);
    set(gardenBed, 'Vertices', get(gardenBed, 'Vertices') * 0.25 + [0.5, 0.2, 0]);
    
    seedBowl = PlaceObject('seed.ply',[0.2,0.1,0]);
end