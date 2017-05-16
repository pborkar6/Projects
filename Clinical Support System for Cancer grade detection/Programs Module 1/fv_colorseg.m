function [ output_layers ] = fv_colorseg( colors, input_image, fuzziness, fill )
%FV_COLORSEG
%   Fuzzy Voronoi Color Segmentation accepts
%   a set of input colors, and segments the image
%   based on the pixel value that is nearest to the
%   input colors. The fuzzy parameter adjusts how
%   close the pixel value must be to the input colors
%   to be classified. Pixel values that are not
%   classified based on color are instead classified
%   based on spatial proximity to the nearest
%   color-classified pixel.

% Initialize storage
[M, N, ~] = size(input_image);

output_image = zeros(M, N, 3);

c_dist   = zeros(size(colors, 1), 1);
c_dist_f = zeros(size(colors, 1), 1);

    layer_image = false(M, N, size(colors, 1));
all_layer_image = zeros(M, N);

% Saturate fuzziness parameter to [1, +inf]
if (fuzziness < 1.0)
    fuzziness = 1.0;
end

% For each pixel determine whether
% it can be classified by color
for i = 1:M
    for j = 1:N
        pixel = reshape(input_image(i, j, :), 1, 3);
        
        % Distances are left squared since the sqrt operation
        % takes processing time and the values are only being
        % compared to each other, so the sqrt is not necessary.
        c_dist = (double(pixel(1)) - double(colors(:, 1))).^2 + ...
                 (double(pixel(2)) - double(colors(:, 2))).^2 + ...
                 (double(pixel(3)) - double(colors(:, 3))).^2;
        
        [~, index] = min(c_dist);
        
        c_dist_f = c_dist;
        
        % Fuzziness parameter is squared
        % since the distances are squared
        c_dist_f(index) = (fuzziness).^2 .* c_dist(index);
        
        [~, index_f] = min(c_dist_f);
        
        if (index == index_f)
            layer_image(i, j, index) = true; % classified by color
        end
    end
end

if (exist('fill', 'var') ~= 1)
    % If this parameter is omitted; default to "on"
    fill = 1;
end

if (fill ~= 0)
    for p = 1:size(colors, 1)
        all_layer_image = all_layer_image + p.*layer_image(:, :, p);
    end

    % For pixels not classified by color,
    % classify them based on their spatial proximity
    % to the nearest pixel classified by color
    for i = 1:M
        for j = 1:N
            % Look for unclassified pixels
            if (all_layer_image(i, j) == 0)
                [k, l] = spiral_search(all_layer_image, i, j);
                nearest_layer = all_layer_image(k, l);
                % Add pixel to the layer with the nearest pixel
                layer_image(i, j, nearest_layer) = true;
            end
        end
    end
end

output_layers = layer_image;

end
