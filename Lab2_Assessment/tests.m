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
       
      
        robot = DobotMagician;

      
        % workspace = [-1 1 -1 1 0 1];                                       % Set the size of the workspace when drawing the robot        
        % scale = 0.5;        
        % q = zeros(1,6);                                                     % Create a vector of initial joint angles        
        % robot.plot(q,'workspace',workspace,'scale',scale);                  % Plot the robot
        
        robot.model.teach;  



%% DobotMagician Movement Testing
clc
clear

robot = DobotMagician;
hold on
currentPos = robot.model.getpos();

which DobotMagician



% Shovel placement
shovel = PlaceObject('wateringcan.ply');
axis equal
shovelVertices = get(shovel, 'Vertices');
transformedVertices = [shovelVertices, ...
    ones(size(shovelVertices, 1), 1)]*transl(0, -0.25, 1)';
set(shovel, 'Vertices', transformedVertices(:, 1:3));



q0 = currentPos;

% Move to trowel and pick it up
T1 = transl(0,-0.25 , 0.15);
T2 = transl(0, -0.25, 0.05);
T3 = transl(0,-0.25 , 0.15);

q1 = robot.model.ikunc(T1, currentPos);
q2 = robot.model.ikunc(T2, currentPos);
q3 = robot.model.ikunc(T3, currentPos);

% Move to first plot
T4 = transl(0.2, 0.2, 0.15)* trotx(0);
T5 = transl(0.2, 0.2, 0)* trotx(-pi/6);
T6 = transl(0.2, 0.2, 0)* trotx(pi/8);
T7 = transl(0.2, 0.2, 0.15)* trotx(pi/8);



q4 = robot.model.ikunc(T4, currentPos);
q5 = robot.model.ikunc(T5, currentPos);
q6 = robot.model.ikunc(T6, currentPos);
q7 = robot.model.ikunc(T7, currentPos);

steps = 100;



move2Pos(robot, currentPos, currentPos, steps, shovelVertices, shovel);
currentPos = robot.model.getpos();
% 
% move2Pos(robot, currentPos, q2, steps, shovelVertices, shovel);
% currentPos = robot.model.getpos();
% 
% move2Pos(robot, currentPos, q3, steps, shovelVertices, shovel);
% currentPos = robot.model.getpos();
% 
% move2Pos(robot, currentPos, q4, steps, shovelVertices, shovel);
% currentPos = robot.model.getpos();
% 
% move2Pos(robot, currentPos, q5, steps, shovelVertices, shovel);
% currentPos = robot.model.getpos();
% 
% move2Pos(robot, currentPos, q6, steps, shovelVertices, shovel);
% currentPos = robot.model.getpos();
% 
% move2Pos(robot, currentPos, q7, steps, shovelVertices, shovel);
% currentPos = robot.model.getpos();

%maximus_thane = rad2deg(currentPos)




% move2Pos(robot, q1, q2, steps);
% 
% move2Pos(robot, q2, q3, steps);
% 
% move2Pos(robot, q3, q4, steps);

    function move2Pos(robot, startPos, endPos, steps, shovelVertices, shovel)
        qMatrix = jtraj(startPos, endPos, steps);

        for i = 1:steps
            robot.model.animate(qMatrix(i,:));
            tr = robot.model.fkine(qMatrix(i,:));
            transformedVertices = [shovelVertices, ones(size(shovelVertices, 1),1)]*tr.T';
            set(shovel, 'Vertices', transformedVertices(:, 1:3));
            axis equal
            drawnow()

        end
    end

