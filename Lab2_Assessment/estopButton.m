clear;

% https://au.mathworks.com/help/matlab/supportpkg/find-arduino-port-on-windows-mac-and-linux.html
% MATLAB Method: run "serialportlist" to identify USB port in Command Window
% Windows Methoc: check Device Manager
% Mac Method: "cd /" then "ls /dev/*" in Terminal

% arduinoBoard = arduino("/dev/tty.usbserial-2140", "Uno");   % mac       /dev/tty.usbserial-0000
arduinoBoard = arduino("COM4", "Uno");                     % windows   COM0

buttonState = readDigitalPin(arduinoBoard, 'D4');% digital pin 4

buttonFlag = false; % to dictate whether the button has been pressed or not, false means no

buttonFlag = checkButtonPress(buttonState, buttonFlag);

disp(buttonFlag);

function buttonFlag = checkButtonPress(buttonState, buttonFlag)
    if buttonState == 1
        buttonFlag = ~buttonFlag;
    end 

end

%% checking button input w arduino
clc
clear

% arduinoBoard = arduino("COM4", "Uno");                     % windows   COM0

% buttonState = readDigitalPin(arduinoBoard, 'D4');% digital pin 4

x = 0.2;
y = 0.2;
z = 0.1;


angleDown = 7*pi/6;
angleUp = 5*pi/6;

% Dobot Magician Setup
robot1 = DobotMagician;
offsetDobot = transl(0.25, 0, 0);
robot1.model.base = offsetDobot;

currentPosDobot = robot1.model.getpos();
hold on


% ABB IRB1100 Setup
robot2 = IRB1100;
offsetABB = transl(0, 0, 0)*trotx(pi)*troty(pi);
robot2.model.base = offsetABB;
currentPosABB = robot2.model.getpos();

drawnow();

% Shovel Setup
shovel = PlaceObject('wateringcan.ply');
axis equal
shovelVertices = get(shovel, 'Vertices');
transformedVertices = [shovelVertices, ...
    ones(size(shovelVertices, 1), 1)]*transl(0, -0.25, 1)';
set(shovel, 'Vertices', transformedVertices(:, 1:3));

% Watering Can Setup

q0 = currentPosDobot;

% Move to trowel and pick it up
T1_Dobot = transl(0,-0.25 , 0.15);
T2_Dobot = transl(0, -0.25, 0.05);
T3_Dobot = transl(0,-0.25 , 0.15);

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

steps = 100;



move2PosDobot(robot1, currentPosDobot, currentPosDobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q2_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q3_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q4_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q5_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q6_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q7_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();








    % function move2PosDobot(robot1, startPosDobot, endPosDobot, steps, shovelVertices, shovel)
    %     qMatrix = jtraj(startPosDobot, endPosDobot, steps);
    % 
    %     for i = 1:steps
    %         robot1.model.animate(qMatrix(i,:));
    %         tr = robot1.model.fkine(qMatrix(i,:));
    %         transformedVertices = [shovelVertices, ones(size(shovelVertices, 1),1)]*tr.T';
    %         set(shovel, 'Vertices', transformedVertices(:, 1:3));
    %         axis equal
    %         drawnow()
    % 
    %     end
    % end

    function move2PosDobot(robot1, startPosDobot, endPosDobot, steps, shovelVertices, shovel)
    % Global Variable for E-Stop
    %Note: need to clear the e-stop when running function again otherwise
    %it will be set to being activated. Needs to be manually cleared
    arduinoBoard = arduino("COM4", "Uno");          % windows   COM0

    buttonFlag = false; % to dictate whether the button has been pressed or not, false means no
    prevButtonState = 0; % tracking the previous button state


    qMatrix = jtraj(startPosDobot, endPosDobot, steps);



    for i = 1:steps
        % Check E-stop flag
        buttonState = readDigitalPin(arduinoBoard, 'D4');% pin 4
        buttonFlag = checkButtonPress(buttonState, buttonFlag);

        if buttonState == 1 && prevButtonState == 0
            buttonFlag = ~buttonFlag;
            disp("E-Stop Activated")
          
        end 

        prevButtonState = buttonState;


          while buttonFlag
           
            buttonState = readDigitalPin(arduinoBoard, 'D4');
            if prevButtonState == 0 && buttonState == 1 
                buttonFlag = ~buttonFlag; % Toggle off
                disp('E-Stop Deactivated');
            end
            prevButtonState = buttonState;
            pause(0.1); 
         end


        

        robot1.model.animate(qMatrix(i,:));
        tr = robot1.model.fkine(qMatrix(i,:));
        transformedVertices = [shovelVertices, ones(size(shovelVertices, 1),1)]*tr.T';
        set(shovel, 'Vertices', transformedVertices(:, 1:3));
        axis equal
        drawnow()

        % delay to detect button press
        pause(0.01);
    end

    end

% function move2PosDobot(robot1, startPosDobot, endPosDobot, steps, shovelVertices, shovel)
%     % Initialize Arduino and button variables
%     arduinoBoard = arduino("COM4", "Uno");
%     buttonFlag = false;  % Tracks whether the button is pressed
%     buttonStatePrev = 0; % Tracks previous button state to detect changes
% 
%     qMatrix = jtraj(startPosDobot, endPosDobot, steps);
% 
%     for i = 1:steps
%         % Read the current state of the button
%         buttonState = readDigitalPin(arduinoBoard, 'D4'); % Digital pin 4
% 
%         % Check for a button press transition (0 -> 1)
%         if buttonState == 1 && buttonStatePrev == 0
%             buttonFlag = ~buttonFlag; % Toggle the flag
%             disp(['Button pressed. Emergency stop is now: ', num2str(buttonFlag)]);
%         end
%         buttonStatePrev = buttonState; % Update previous state
% 
%         % If E-stop is activated, hold position until button is pressed again
%         if buttonFlag
%             disp('Emergency stop activated!');
%             while buttonFlag
%                 buttonState = readDigitalPin(arduinoBoard, 'D4');
%                 if buttonState == 1 && buttonStatePrev == 0
%                     buttonFlag = ~buttonFlag; % Toggle off
%                     disp('Emergency stop deactivated, resuming movement.');
%                 end
%                 buttonStatePrev = buttonState;
%                 pause(0.1); % Small delay to debounce the button press
%             end
%         end

%         % Move the robotic arm if the buttonFlag allows
%         robot1.model.animate(qMatrix(i,:));
%         tr = robot1.model.fkine(qMatrix(i,:));
%         transformedVertices = [shovelVertices, ones(size(shovelVertices, 1), 1)] * tr.T';
%         set(shovel, 'Vertices', transformedVertices(:, 1:3));
%         axis equal;
%         drawnow();
% 
%         % Small delay to detect the button press
%         pause(0.01);
%     end
% end


%% E Stop with a keyboard input
clc
clear

x = 0.2;
y = 0.2;
z = 0.1;
global eStopButton

angleDown = 7*pi/6;
angleUp = 5*pi/6;

% Dobot Magician Setup
robot1 = DobotMagician;
offsetDobot = transl(0.25, 0, 0);
robot1.model.base = offsetDobot;

currentPosDobot = robot1.model.getpos();
hold on


% ABB IRB1100 Setup
robot2 = IRB1100;
offsetABB = transl(0, 0, 0)*trotx(pi)*troty(pi);
robot2.model.base = offsetABB;
currentPosABB = robot2.model.getpos();

drawnow();

% Shovel Setup
shovel = PlaceObject('wateringcan.ply');
axis equal
shovelVertices = get(shovel, 'Vertices');
transformedVertices = [shovelVertices, ...
    ones(size(shovelVertices, 1), 1)]*transl(0, -0.25, 1)';
set(shovel, 'Vertices', transformedVertices(:, 1:3));

% Watering Can Setup

q0 = currentPosDobot;

% Move to trowel and pick it up
T1_Dobot = transl(0,-0.25 , 0.15);
T2_Dobot = transl(0, -0.25, 0.05);
T3_Dobot = transl(0,-0.25 , 0.15);

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

steps = 100;



move2PosDobot(robot1, currentPosDobot, currentPosDobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q2_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q3_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q4_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q5_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q6_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();

move2PosDobot(robot1, currentPosDobot, q7_Dobot, steps, shovelVertices, shovel);
currentPosDobot = robot1.model.getpos();








    % function move2PosDobot(robot1, startPosDobot, endPosDobot, steps, shovelVertices, shovel)
    %     qMatrix = jtraj(startPosDobot, endPosDobot, steps);
    % 
    %     for i = 1:steps
    %         robot1.model.animate(qMatrix(i,:));
    %         tr = robot1.model.fkine(qMatrix(i,:));
    %         transformedVertices = [shovelVertices, ones(size(shovelVertices, 1),1)]*tr.T';
    %         set(shovel, 'Vertices', transformedVertices(:, 1:3));
    %         axis equal
    %         drawnow()
    % 
    %     end
    % end

%     function move2PosDobot(robot1, startPosDobot, endPosDobot, steps, shovelVertices, shovel)
%     % Global Variable for E-Stop
%     %Note: need to clear the e-stop when running function again otherwise
%     %it will be set to being activated. Needs to be manually cleared
%     global eStopButton;
% 
% 
%     if isempty(eStopButton) || ~islogical(eStopButton)
%         eStopButton = false;
%     end
% 
% 
%     qMatrix = jtraj(startPosDobot, endPosDobot, steps);
% 
% 
%     fig = figure;
%     set(fig, 'KeyPressFcn', @keyFlagDetector);
% 
% 
%     for i = 1:steps
%         % Check E-stop flag
%         if eStopButton
%             disp('Emergency stop activated!');
%             break;
%         end
% 
% 
%         robot1.model.animate(qMatrix(i,:));
%         tr = robot1.model.fkine(qMatrix(i,:));
%         transformedVertices = [shovelVertices, ones(size(shovelVertices, 1),1)]*tr.T';
%         set(shovel, 'Vertices', transformedVertices(:, 1:3));
%         axis equal
%         drawnow()
% 
% 
% 
%         % small delay to detect the keyPressHandler
%         pause(0.01);
%     end
% 
%     % Close the figure at the end
%     close(fig);
% end

% Function to set the e-Stop
function keyFlagDetector(~, event)
    global eStopButton;
    if strcmp(event.Key, 'e') % Press 'e' for emergency stop
        eStopButton = true;  % Set flag to true permanently until reset manually
    end
end





