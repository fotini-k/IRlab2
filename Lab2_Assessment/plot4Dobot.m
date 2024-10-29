function [T13_Dobot, T14_Dobot, T15_Dobot] = plot4Dobot(choice)    
    switch choice
        case 1
            T13_Dobot = transl(0.7, 0.45, 0.25);
            T14_Dobot = transl(0.7, 0.45, 0.19);
            T15_Dobot = transl(0.7, 0.45, 0.25);
                        
        case 2
            T13_Dobot = transl(0.7, 0.45, 0.25);
            T14_Dobot = transl(0.7, 0.45, 0.25)*troty(-pi/10);
            T15_Dobot = transl(0.7, 0.45, 0.25);
    end
end