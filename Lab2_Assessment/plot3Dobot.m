function [T10_Dobot, T11_Dobot, T12_Dobot] = plot3Dobot(choice)    
    switch choice
        case 1
            T10_Dobot = transl(0.5, 0.5, 0.25);
            T11_Dobot = transl(0.5, 0.5, 0.19);
            T12_Dobot = transl(0.5, 0.5, 0.25);
                        
        case 2
            T10_Dobot = transl(0.5, 0.5, 0.25);
            T11_Dobot = transl(0.5, 0.5, 0.25)*troty(-pi/10);
            T12_Dobot = transl(0.5, 0.5, 0.25);
    end
end