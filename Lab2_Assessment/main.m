clc
clear

hold on;

makeEnvironment();

angleDown = 7*pi/6;
angleUp = 5*pi/6;

steps = 100;

% Dobot Magician Setup
robot1 = DobotMagician;
offsetDobot = transl(0.5, 0.25, 0.15)*trotz(pi/2);
robot1.model.base = offsetDobot;

currentPosDobot = robot1.model.getpos();
hold on


% ABB IRB1100 Setup
robot2 = IRB1100;
offsetABB = transl(0.5, 0, 0)*trotz(-pi/2);
robot2.model.base = offsetABB;
currentPosABB = robot2.model.getpos();
drawnow();


% Shovel Setup
can = PlaceObject('wateringcan.ply');
axis equal
canVertices = get(can, 'Vertices');
transformedCanVertices = [canVertices, ...
    ones(size(canVertices, 1), 1)]*transl(0, -0.25, 1)';
set(can, 'Vertices', transformedCanVertices(:, 1:3));

% Watering Can Setup

% Shovel placement
shovel = PlaceObject('shovel.ply');
axis equal
shovelVertices = get(shovel, 'Vertices');
transformedVertices = [shovelVertices, ...
    ones(size(shovelVertices, 1), 1)]*transl(0, -0.25, 1)';
set(shovel, 'Vertices', transformedVertices(:, 1:3));



T0_ABB = transl(0, 0, 0);
q0_ABB = robot2.model.ikcon(T0_ABB, currentPosABB);

move2PosABB(robot2, currentPosABB, currentPosABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

T0_Dobot = transl(0, 0, 0);
q0_Dobot = robot1.model.ikunc(T0_Dobot, currentPosDobot);

move2PosDobot(robot1, currentPosDobot, currentPosDobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();


% Move to trowel and pick it up
T1_ABB = transl(0.9, 0, 0.5)* troty(pi);
T2_ABB = transl(0.9, 0, 0)*troty(pi);
T3_ABB = transl(0.9, 0, 0.5)*troty(pi);

q1_ABB = robot2.model.ikcon(T1_ABB, currentPosABB);
q2_ABB = robot2.model.ikcon(T2_ABB, currentPosABB);
q3_ABB = robot2.model.ikcon(T3_ABB, currentPosABB);

% Move to first plot
T4_ABB = transl(0.75, 0.3, 0.5)*troty(pi);
T5_ABB = transl(0.75, 0.3, 0.2)*troty(pi);
T6_ABB = transl(0.75, 0.32, 0.2)*troty(pi);
T7_ABB = transl(0.75, 0.32, 0.5)*troty(pi)*trotz(0);
T8_ABB = transl(-0.5, 0, 0.2)*troty(pi);


q4_ABB = robot2.model.ikcon(T4_ABB, currentPosABB);
q5_ABB = robot2.model.ikcon(T5_ABB, currentPosABB);
q6_ABB = robot2.model.ikcon(T6_ABB, currentPosABB);
q7_ABB = robot2.model.ikcon(T7_ABB, currentPosABB);
q8_ABB = robot2.model.ikcon(T8_ABB, currentPosABB);



% move2PosABB(robot2, currentPosABB, q1_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();
% 
% move2PosABB(robot2, currentPosABB, q2_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();
% 
% move2PosABB(robot2, currentPosABB, q3_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();
% 
% move2PosABB(robot2, currentPosABB, q4_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();
% 
% move2PosABB(robot2, currentPosABB, q5_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();
% 
% move2PosABB(robot2, currentPosABB, q6_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();
% 
% move2PosABB(robot2, currentPosABB, q7_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();
% 
% move2PosABB(robot2, currentPosABB, q8_ABB, steps, shovelVertices, shovel);
% currentPosABB = robot2.model.getpos();


function move2PosABB(robot2, startPosABB, endPosABB, steps, shovelVertices, shovel)
    qMatrix = jtraj(startPosABB, endPosABB, steps);
   


            for i = 1:steps

                robot2.model.animate(qMatrix(i,:));
                tr = robot2.model.fkine(qMatrix(i,:));
                transformedVertices = [shovelVertices, ones(size(shovelVertices, 1),1)]*tr.T';
                set(shovel, 'Vertices', transformedVertices(:, 1:3));
                axis equal
                drawnow()
            
             end
        end



q0 = currentPosDobot;

% Move to Can and pick it up
T1_Dobot = transl(0.22 ,0 , 0.25);
T2_Dobot = transl(0.22, 0, 0.05);
T3_Dobot = transl(0.22, 0 , 0.25);

q1_Dobot = robot1.model.ikunc(T1_Dobot, currentPosDobot);
q2_Dobot = robot1.model.ikunc(T2_Dobot, currentPosDobot);
q3_Dobot = robot1.model.ikunc(T3_Dobot, currentPosDobot);

% % Move to 1st plot

[T4_Dobot, T5_Dobot, T6_Dobot] = plot1Dobot(1);

q4_Dobot = robot1.model.ikunc(T4_Dobot, currentPosDobot);
q5_Dobot = robot1.model.ikunc(T5_Dobot, currentPosDobot);
q6_Dobot = robot1.model.ikunc(T6_Dobot, currentPosDobot);

    

% Move to 2nd plot
[T7_Dobot, T8_Dobot, T9_Dobot] = plot2Dobot(1);

q7_Dobot = robot1.model.ikunc(T7_Dobot, currentPosDobot);
q8_Dobot = robot1.model.ikunc(T8_Dobot, currentPosDobot);
q9_Dobot = robot1.model.ikunc(T9_Dobot, currentPosDobot);

% Move to 3rd plot
[T10_Dobot, T11_Dobot, T12_Dobot] = plot3Dobot(1);  

q10_Dobot = robot1.model.ikunc(T10_Dobot, currentPosDobot);
q11_Dobot = robot1.model.ikunc(T11_Dobot, currentPosDobot);
q12_Dobot = robot1.model.ikunc(T12_Dobot, currentPosDobot);

% Move to 4th plot
[T13_Dobot, T14_Dobot, T15_Dobot] = plot4Dobot(1) ;

q13_Dobot = robot1.model.ikunc(T13_Dobot, currentPosDobot);
q14_Dobot = robot1.model.ikunc(T14_Dobot, currentPosDobot);
q15_Dobot = robot1.model.ikunc(T15_Dobot, currentPosDobot);

% Move to 5th plot
[T16_Dobot, T17_Dobot, T18_Dobot] = plot5Dobot(1);

q16_Dobot = robot1.model.ikunc(T16_Dobot, currentPosDobot);
q17_Dobot = robot1.model.ikunc(T17_Dobot, currentPosDobot);
q18_Dobot = robot1.model.ikunc(T18_Dobot, currentPosDobot);




move2PosDobot(robot1, currentPosDobot, q1_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q2_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q3_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q4_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q5_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q6_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q7_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q8_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q9_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q10_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q11_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q12_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q13_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q14_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q15_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q16_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q17_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q18_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

% Watering cycle on the way back around

[T16_Dobot, T17_Dobot, T18_Dobot] = plot5Dobot(2);
q16_Dobot = robot1.model.ikunc(T16_Dobot, currentPosDobot);
q17_Dobot = robot1.model.ikunc(T17_Dobot, currentPosDobot);
q18_Dobot = robot1.model.ikunc(T18_Dobot, currentPosDobot);

move2PosDobot(robot1, currentPosDobot, q18_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q17_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q16_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

[T13_Dobot, T14_Dobot, T15_Dobot] = plot4Dobot(2) ;

q13_Dobot = robot1.model.ikunc(T13_Dobot, currentPosDobot);
q14_Dobot = robot1.model.ikunc(T14_Dobot, currentPosDobot);
q15_Dobot = robot1.model.ikunc(T15_Dobot, currentPosDobot);

move2PosDobot(robot1, currentPosDobot, q15_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q14_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q13_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

[T10_Dobot, T11_Dobot, T12_Dobot] = plot3Dobot(2);  

q10_Dobot = robot1.model.ikunc(T10_Dobot, currentPosDobot);
q11_Dobot = robot1.model.ikunc(T11_Dobot, currentPosDobot);
q12_Dobot = robot1.model.ikunc(T12_Dobot, currentPosDobot);

move2PosDobot(robot1, currentPosDobot, q12_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q11_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q10_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();


[T7_Dobot, T8_Dobot, T9_Dobot] = plot2Dobot(2);

q7_Dobot = robot1.model.ikunc(T7_Dobot, currentPosDobot);
q8_Dobot = robot1.model.ikunc(T8_Dobot, currentPosDobot);
q9_Dobot = robot1.model.ikunc(T9_Dobot, currentPosDobot);

move2PosDobot(robot1, currentPosDobot, q9_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q8_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q7_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();


[T4_Dobot, T5_Dobot, T6_Dobot] = plot1Dobot(2);

q4_Dobot = robot1.model.ikunc(T4_Dobot, currentPosDobot);
q5_Dobot = robot1.model.ikunc(T5_Dobot, currentPosDobot);
q6_Dobot = robot1.model.ikunc(T6_Dobot, currentPosDobot);

move2PosDobot(robot1, currentPosDobot, q6_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q5_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q4_Dobot, steps, canVertices, can);
currentPosDobot = robot1.model.getpos();


function move2PosDobot(robot1, startPosDobot, endPosDobot, steps, canVertices, can)
        qMatrix = jtraj(startPosDobot, endPosDobot, steps);

        for i = 1:steps
            robot1.model.animate(qMatrix(i,:));
            tr = robot1.model.fkine(qMatrix(i,:));
            transformedCanVertices = [canVertices, ones(size(canVertices, 1),1)]*tr.T';
            set(can, 'Vertices', transformedCanVertices(:, 1:3));
            axis equal
            drawnow()

        end
    end

