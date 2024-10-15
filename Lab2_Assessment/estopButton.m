clear;
arduinoBoard = arduino("/dev/tty.usbserial-2140", "Uno");

buttonState = readDigitalPin(arduinoBoard, 'D13');