clear;

% https://au.mathworks.com/help/matlab/supportpkg/find-arduino-port-on-windows-mac-and-linux.html
% MATLAB Method: run "serialportlist" to identify USB port in Command Window
% Windows Methoc: check Device Manager
% Mac Method: "cd /" then "ls /dev/*" in Terminal

arduinoBoard = arduino("/dev/tty.usbserial-2140", "Uno");   % mac
%arduinoBoard = arduino("COM4", "Uno");                     % windows

buttonState = readDigitalPin(arduinoBoard, 'D13');