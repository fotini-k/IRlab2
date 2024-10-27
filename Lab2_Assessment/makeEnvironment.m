clear; close all; clf;

hold on;
view(3);

table = PlaceObject('myTable5.ply',[0,0,-0.54]);

gardenBed = PlaceObject('gardenBed.ply',[0,0,0]);
set(gardenBed, 'Vertices', get(gardenBed, 'Vertices') * 0.25 + [0.3, 0.2, 0]);

firstAid = PlaceObject('firstAid.ply',[-0.6,0.3,0.15]);
estop = PlaceObject('eStop.ply',[-0.7,-0.5,0.15]);

dobot = DobotMagician;
dobot.model.base = transl(0.3, 0.2, 0.1) * trotz(pi/2);

dobot.model.plot(dobot.homeQ);

axis([-1 1 -1 1 -1 1]);

% axis tight;
% axis equal;

%dobot.model.teach(dobot.homeQ);