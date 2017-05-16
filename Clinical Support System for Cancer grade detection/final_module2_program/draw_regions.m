function [ output_image ] = draw_regions( colors, input_regions, outline, outline_color )
%DRAW_REGIONS
%   Colorizes the regions provided and draws them in an image.

if (size(colors, 2) ~= 3)
    error('Colors parameter must have rows of length 3 (24-bit RGB color)');
end

if (size(colors, 1) < length(input_regions))
    error('One color must be provided for every layer');
end

if (exist('outline', 'var') ~= 1)
    outline = 0;
end

if (exist('outline_color', 'var') == 1)
    if ((size(outline_color, 2) ~= 3) && ...
        (size(outline_color, 1) ~= 1))
        outline_color = [-1, -1, -1];
    end
else
    outline_color = [-1, -1, -1];
end

M = input_regions{1}.ImageSize(1);
N = input_regions{1}.ImageSize(2);

output_image = uint8(zeros(M, N, 3));
outline_image = false(M, N);

% Iterate through each region layer
for p = 1:size(colors, 1)
    % Draw each pixel in the image by region
    for q = 1:length(input_regions{p}.PixelIdxList)
        for r = 1:length(input_regions{p}.PixelIdxList{q})
            [i, j] = ind2sub([M, N], input_regions{p}.PixelIdxList{q}(r));
            output_image(i, j, :) = colors(p, :);
        end
    end
    
    % Find region outlines
    if (outline ~= 0)
        outline_image = ...
            or(outline_image, ...
               outline_regions(input_regions{p}));
    end
end

% Draw region outlines in output image
if (outline ~= 0)
    for i = 1:M
        for j = 1:N
            if (outline_image(i, j) == true)
                if (outline_color(1) < 0)
                    output_image(i, j, :) = output_image(i, j, :) ./ 2;
                else
                    output_image(i, j, :) = outline_color;
                end
            end
        end
    end
end

end

