function [T4_Dobot, T5_Dobot, T6_Dobot] = plot1Dobot(choice)    
    switch choice
        case 1
            T4_Dobot = transl(0.25, 0.3, 0.25);
            T5_Dobot = transl(0.25, 0.3, 0.19);
            T6_Dobot = transl(0.25, 0.3, 0.25);

        case 2
            T4_Dobot = transl(0.25, 0.3, 0.25);
            T5_Dobot = transl(0.25, 0.3, 0.25)*troty(-pi/10);
            T6_Dobot = transl(0.25, 0.3, 0.25);

    end
end

