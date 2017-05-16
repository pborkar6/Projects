function [ out_x, out_y, dist ] = spiral_search( input, in_x, in_y )
%SPIRAL_SEARCH
%   Search the input matrix in a spiral pattern starting at (in_x, in_y)
%   until a logical true value is located. The search ensures that
%   the returned indices indicate the closest Euclidean distance matrix
%   element that is true.

[M, N] = size(input);

 x = 0;
 y = 0;
dx = 0;
dy = -1;

index_x = 0;
index_y = 0;

out_x = in_x;
out_y = in_y;

temp = 0;

found     =  0;
dist      =  0;
dist_linf = -1;

for i = 1:(max(M, N)).^2
    index_x = x + in_x;
    index_y = y + in_y;
    
    if (((index_x) >= 1) && ...
        ((index_x) <= M) && ...
        ((index_y) >= 1) && ...
        ((index_y) <= N))
        if (input(index_x, index_y) ~= 0)
            if (found == 1)
                if (sqrt(x.^2 + y.^2) < dist)
                    dist  = sqrt(x.^2 + y.^2);
                    out_x = index_x;
                    out_y = index_y;
                end
            else
                dist_linf = max(abs(x), abs(y));
                dist  = sqrt(x.^2 + y.^2);
                out_x = index_x;
                out_y = index_y;
                found = 1;
            end
        end
    end
    
    if ((x == y)               || ...
        ((x < 0) && (x == -y)) || ...
        ((x > 0) && (x == (1 - y))))
        temp  = dx;
        dx    = -dy;
        dy    = temp;
    end
    
    if (found == 1)
        if (max(abs(x), abs(y)) >= ...
            (((3 * dist_linf) / 2) + 1))
            % Not possible for any more true elements
            % to be closer than what was already found
            break;
        end
    end
        
    x = x + dx;
    y = y + dy;
end

end