function [ output_colormap ] = build_colormap( input_image, downsample )
%BUILD_COLORMAP
%   Outputs a matrix containing all the unique color values
%   contained within the input image; each color value appears
%   in the output matrix only once

% Precondition: input must be integer-valued
if (~isinteger(input_image))
    error('Input image must be integer-valued');
end

if (exist('downsample', 'var') == 1)
    if (downsample < 1)
        downsample = 1;
    end
    
    input_image = outlier_downsample(input_image, ...
                                     downsample);
end

% Initialize storage
[M, N, ~] = size(input_image);

duplicate = 0;

output_colormap = reshape(input_image(1, 1, :), 1, 3);
    
for i = 1:M
    for j = 1:N
        duplicate = 0;
        for k = 1:size(output_colormap, 1)
            pixel = reshape(input_image(i, j, :), 1, 3);
            color = output_colormap(k, :);
            
            if (all(pixel == color))
                % Duplicate found; do not add to the colormap
                duplicate = 1;
                % Heuristic: if a duplicate color value is found,
                % place it at the top of the colormap; the expected
                % result is that color values which occur more
                % frequently will be near the top, so the time it
                % takes to discover duplicates will be minimized
                % as the colormap grows
                output_colormap = [output_colormap(k, :); ...
                                   output_colormap(1:end ~= k, :)];
                break;
            end
        end
        if (duplicate == 0)
            output_colormap = [output_colormap; ...
                               pixel];
        end
    end
end

end
