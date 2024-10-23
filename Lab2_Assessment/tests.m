            L1 = Link('d',0.327,'a',0,'alpha',pi/2,'qlim',deg2rad([-230 230]), 'offset',0);
            L2 = Link('d',0,'a',0.290,'alpha',0,'qlim', deg2rad([-115 113]), 'offset', pi/2);
            L3 = Link('d',0 ,'a',0,'alpha',-pi/2,'qlim', deg2rad([-205 55]), 'offset', 0);
            L4 = Link('d',0.2275,'a', 0,'alpha',pi/2,'qlim',deg2rad([-230 230]),'offset', 0);
            L5 = Link('d',0 ,'a',0,'alpha',-pi/2,'qlim',deg2rad([-125,120]), 'offset',0);
            L6 = Link('d',	0.064,'a',0,'alpha',0,'qlim',deg2rad([-400,400]), 'offset', pi);
        
        robot = SerialLink([L1 L2 L3 L4 L5 L6],'name','myRobot')                     % Generate the model

        workspace = [-1 1 -1 1 0 1];                                       % Set the size of the workspace when drawing the robot        
        scale = 0.5;        
        q = zeros(1,6);                                                     % Create a vector of initial joint angles        
        robot.plot(q,'workspace',workspace,'scale',scale);                  % Plot the robot
        
        robot.teach;  