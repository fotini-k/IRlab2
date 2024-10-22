classdef IRB1100 < RobotBaseClass
    %% ABB IRB 1100 robot class created by UTS students
    % 
    % WARNING: This model has been created by UTS students in the subject
    % 41013. No guarentee is made about the accuracy or correctness of the
    % of the DH parameters of the accompanying ply files. Do not assume
    % that this matches the real robot!

  properties(Access = public)   
        plyFileNameStem = 'IRB1100';
    end
    
    
    methods
%% Constructor
function self = IRB1100(baseTr)


            originalDir = pwd;
            % Change directory to where the .ply files are located
            plyFileDirectory = fileparts(mfilename('fullpath'));
            cd(plyFileDirectory);


            self.CreateModel();
            if nargin == 1			
				self.model.base = self.model.base.T * baseTr;
            end   
            self.PlotAndColourRobot();

            % Switch back to the original directory
            cd(originalDir);


        end

%% CreateModel
        function CreateModel(self)
           
            link(1) = Link('d',0.327,'a',0,'alpha',pi/2,'qlim',deg2rad([-165 165]), 'offset',0);
            link(2) = Link('d',0,'a',0.290,'alpha',0,'qlim', deg2rad([-110 110]), 'offset', -pi/2);
            link(3) = Link('d',0,'a',0.070,'alpha',-pi/2,'qlim', deg2rad([-110 70]), 'offset', 0);
            link(4) = Link('d',0.302,'a',0,'alpha',pi/2,'qlim',deg2rad([-160 160]),'offset', 0);
            link(5) = Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-120,120]), 'offset',0);
            link(6) = Link('d',	0.072,'a',0,'alpha',0,'qlim',deg2rad([-400,400]), 'offset', pi);
                   
            self.model = SerialLink(link,'name',self.name);  

            %qlims for robot?? (like what was done for Lab1 Linear UR3e?)
        end    
    end
end