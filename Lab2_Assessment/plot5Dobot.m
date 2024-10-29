function [T16_Dobot, T17_Dobot, T18_Dobot] = plot5Dobot(choice)    
    switch choice
        case 1
            T16_Dobot = transl(0.75, 0.3, 0.25);
            T17_Dobot = transl(0.75, 0.3, 0.19);
            T18_Dobot = transl(0.75, 0.3, 0.25);
                        
        case 2
            T16_Dobot = transl(0.75, 0.3, 0.25);
            T17_Dobot = transl(0.75, 0.3, 0.25)*troty(-pi/10);
            T18_Dobot = transl(0.75, 0.3, 0.25);
    end
end