%NOT USED
function octant = get_octant(x,y)
    x_pos = x > 0;
    y_pos = y > 0;
    sum_pos = (x + y) > 0;
    diff_pos = (x - y) > 0;
    if (x_pos && y_pos && diff_pos)
        octant = 1;
    elseif (x_pos && y_pos && ~diff_pos)
        octant = 2;
    elseif (~x_pos && y_pos && sum_pos)
        octant = 3;
    elseif (~x_pos && y_pos && ~sum_pos)
        octant = 4;
    elseif (~x_pos && ~y_pos && diff_pos)
        octant = 5;
    elseif (~x_pos && ~y_pos && ~diff_pos)
        octant = 6;
    elseif (x_pos && ~y_pos && ~sum_pos)
        octant = 7;
    else
        octant = 8;     
    end
end