%% DH parameters for the ABB IRB 120 robot
L1 = Link('d',0.290,'a',0,'alpha',pi/2,'qlim',deg2rad([-165 165]), 'offset',0);
L2 = Link('d',0,'a',0.270,'alpha',0,'qlim', deg2rad([-110 110]), 'offset',-pi/2);
L3 = Link('d',0,'a',0.070,'alpha',-pi/2,'qlim', deg2rad([-110 70]), 'offset', 0);
L4 = Link('d',0.302,'a',0,'alpha',pi/2,'qlim',deg2rad([-160 160]),'offset', 0);
L5 = Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-120,120]), 'offset',0);
L6 = Link('d',	0.072,'a',0,'alpha',0,'qlim',deg2rad([-400,400]), 'offset', pi);

% Link('d',0.290,'a',0,'alpha',pi/2,'qlim',deg2rad([-165 165]), 'offset',0);
% Link('d',0,'a',0.270,'alpha',0,'qlim', deg2rad([-110 110]), 'offset',-pi/2);
% Link('d',0,'a',0.070,'alpha',-pi/2,'qlim', deg2rad([-110 70]), 'offset', 0);
% Link('d',0.302,'a',0,'alpha',pi/2,'qlim',deg2rad([-160 160]),'offset', 0);
% Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-120,120]), 'offset',0);
% Link('d',	0.072,'a',0,'alpha',0,'qlim',deg2rad([-400,400]), 'offset', pi);

robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','IRB 120'); 

q = zeros(1,robot.n); % This creates a vector of n joint angles at 0.
workspace = [-2 +2 -2 +2 -2 +2];
scale = 2;
% q = [pi/2 pi/2 pi/2 pi/2 pi/2 pi/2];

robot.plot(q,'workspace',workspace, 'scale', scale);

% 1.3) Use teach to change the q variable (i.e. the values for each joint), and check that the model matches the images provided. 
robot.teach(q);

% r = DobotMagician;

%% 

r = IRB120;

r.model.teach();



