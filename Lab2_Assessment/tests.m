            % L1 = Link('d',0.327,'a',0,'alpha',pi/2,'qlim',deg2rad([-230 230]), 'offset',0);
            % L2 = Link('d',0,'a',0.290,'alpha',0,'qlim', deg2rad([-115 113]), 'offset', pi/2);
            % L3 = Link('d',0 ,'a',0,'alpha',-pi/2,'qlim', deg2rad([-205 55]), 'offset', 0);
            % L4 = Link('d',0.2275,'a', 0,'alpha',pi/2,'qlim',deg2rad([-230 230]),'offset', 0);
            % L5 = Link('d',0 ,'a',0,'alpha',-pi/2,'qlim',deg2rad([-125,120]), 'offset',0);
            % L6 = Link('d',	0.064,'a',0,'alpha',0,'qlim',deg2rad([-400,400]), 'offset', pi);

            % L1 = Link('d',0.290,'a',0,'alpha',pi/2,'qlim',deg2rad([-165 165]), 'offset',0);
            % L2 = Link('d',0,'a',0.270,'alpha',0,'qlim', deg2rad([-110 110]), 'offset', -pi/2);
            % L3 = Link('d',0,'a',0.070,'alpha',-pi/2,'qlim', deg2rad([-110 70]), 'offset', 0);
            % L4 = Link('d',0.302,'a',0,'alpha',pi/2,'qlim',deg2rad([-160 160]),'offset', 0);
            % L5 = Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-120,120]), 'offset',0);
            % L6 = Link('d',	0.072,'a',0,'alpha',0,'qlim',deg2rad([-400,400]), 'offset', pi);
        
        % robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','myRobot')                     % Generate the model
        % 
       
      
        robot = IRB1100;

      
        % workspace = [-1 1 -1 1 0 1];                                       % Set the size of the workspace when drawing the robot        
        % scale = 0.5;        
        % q = zeros(1,6);                                                     % Create a vector of initial joint angles        
        % robot.plot(q,'workspace',workspace,'scale',scale);                  % Plot the robot
        
        robot.model.teach;  



%% Combined Robot Movement
clc
clear

hold on;

makeEnvironment();

angleDown = 7*pi/6;
angleUp = 5*pi/6;

steps = 100;

% Dobot Magician Setup
robot1 = DobotMagician;
offsetDobot = transl(0.25, 0, 0);
robot1.model.base = offsetDobot;

currentPosDobot = robot1.model.getpos();
hold on


% ABB IRB1100 Setup
robot2 = IRB1100;
offsetABB = transl(0, 0, 0)*trotz(pi);
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



q0 = currentPosABB;

% Move to trowel and pick it up
T1_ABB = transl(0, -0.5, 0.2)* troty(pi);
T2_ABB = transl(0, -0.5, 0.05)* troty(pi);
T3_ABB = transl(0, -0.5, 0.2)* troty(pi);

q1_ABB = robot2.model.ikcon(T1_ABB, currentPosABB);
q2_ABB = robot2.model.ikcon(T2_ABB, currentPosABB);
q3_ABB = robot2.model.ikcon(T3_ABB, currentPosABB);

% Move to first plot
T4_ABB = transl(0.5, -0.2, 0.2)*troty(pi);
T5_ABB = transl(0.5, -0.1, 0.05)*troty(pi);
T6_ABB = transl(0.5, 0, 0.05)*troty(pi);
T7_ABB = transl(0.5, 0, 0.2)*troty(pi)*trotz(0);
T8_ABB = transl(-0.5, 0, 0.2)*troty(pi);


q4_ABB = robot2.model.ikcon(T4_ABB, currentPosABB);
q5_ABB = robot2.model.ikcon(T5_ABB, currentPosABB);
q6_ABB = robot2.model.ikcon(T6_ABB, currentPosABB);
q7_ABB = robot2.model.ikcon(T7_ABB, currentPosABB);
q8_ABB = robot2.model.ikcon(T8_ABB, currentPosABB);



move2PosABB(robot2, currentPosABB, currentPosABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

move2PosABB(robot2, currentPosABB, q2_ABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

move2PosABB(robot2, currentPosABB, q3_ABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

move2PosABB(robot2, currentPosABB, q4_ABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

move2PosABB(robot2, currentPosABB, q5_ABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

move2PosABB(robot2, currentPosABB, q6_ABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

move2PosABB(robot2, currentPosABB, q7_ABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();

move2PosABB(robot2, currentPosABB, q8_ABB, steps, shovelVertices, shovel);
currentPosABB = robot2.model.getpos();


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
T1_Dobot = transl(0,-0.3 , 0.15);
T2_Dobot = transl(0, -0.3, 0.05);
T3_Dobot = transl(0,-0.3 , 0.15);

q1_Dobot = robot1.model.ikunc(T1_Dobot, currentPosDobot);
q2_Dobot = robot1.model.ikunc(T2_Dobot, currentPosDobot);
q3_Dobot = robot1.model.ikunc(T3_Dobot, currentPosDobot);

% Move to first plot
T4_Dobot = transl(0.2, 0.2, 0.15)* trotx(0);
T5_Dobot = transl(0.2, 0.2, 0)* trotx(-pi/6);
T6_Dobot = transl(0.2, 0.2, 0)* trotx(pi/8);
T7_Dobot = transl(0.2, 0.2, 0.15)* trotx(pi/8);



q4_Dobot = robot1.model.ikunc(T4_Dobot, currentPosDobot);
q5_Dobot = robot1.model.ikunc(T5_Dobot, currentPosDobot);
q6_Dobot = robot1.model.ikunc(T6_Dobot, currentPosDobot);
q7_Dobot = robot1.model.ikunc(T7_Dobot, currentPosDobot);




move2PosDobot(robot1, currentPosDobot, currentPosDobot, steps, canVertices, can);
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









   
    


 
  
