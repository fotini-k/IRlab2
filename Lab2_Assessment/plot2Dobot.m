function [T7_Dobot, T8_Dobot, T9_Dobot] = plot2Dobot(choice)    
    switch choice
        case 1
            T7_Dobot = transl(0.35, 0.45, 0.25);
            T8_Dobot = transl(0.35, 0.45, 0.19);
            T9_Dobot = transl(0.35, 0.45, 0.25);
                        
        case 2
            T7_Dobot = transl(0.35, 0.45, 0.25);
            T8_Dobot = transl(0.35, 0.45, 0.25)*troty(-pi/10);
            T9_Dobot = transl(0.35, 0.45, 0.25);
    end
end