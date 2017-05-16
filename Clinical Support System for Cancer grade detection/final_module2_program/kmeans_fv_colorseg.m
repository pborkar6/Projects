function [ output_layers ] = kmeans_fv_colorseg( colors, input_image, fuzziness, fill )
%KMEANS_FV_COLORSEG
%   Segments an image by color using k-means clustering on the
%   colormap of the image with the additional fuzziness
%   parameter for fv_colorseg. To acheive reasonable performance
%   on 24-bit 512x512 images, the algorithm downsamples the image
%   when computing the colormap.

if ((size(colors, 2) ~= 3) && ...
    (size(colors, 2) ~= 4) && ...
    (size(colors, 2) ~= 5))
    error('Colors parameter must have rows of length 3, 4, or 5 (24-bit RGB color, flag for watershed segmentation (unused), and hue constraint)');
end

hue_constraints = NaN(size(colors, 1), 1);

if (size(colors, 2) >= 5)
    hue_constraints = colors(:, 5);
    hue_constraints(hue_constraints < 0.0) = NaN;
    hue_constraints(hue_constraints > 1.0) = NaN;
end

max_dim = max(size(input_image, 1), ...
              size(input_image, 2));

if (max_dim >= 32)
    downsample = max_dim / 32;
else
    downsample = 1;
end

colormap = build_colormap(input_image, downsample);

if (all(isnan(hue_constraints)))
    [~, class_centers] = kmeans(double(colormap), ...
                                size(colors(:, 1:3), 1), ...
                                'Start', ...
                                double(colors(:, 1:3)));
else
    prev_class_indices = zeros(size(colormap, 1), 1);
    class_centers = double(colors(:, 1:3));
    
    % Disable warnings for kmeans nonconvergence;
    % since kmeans is being executed one step at a time,
    % it is not expected to converge every execution
    warning('off', 'stats:kmeans:FailedToConverge');

    iter = 100;

    for i = 1:iter
        if (i == 100)
            % Enable warnings for kmeans nonconvergence
            % for the last iteration since it is expected
            % to converge by this iteration
            warning('on', 'stats:kmeans:FailedToConverge');
        end
        
        [class_indices, class_centers] = kmeans(double(colormap), ...
                                                size(colors(:, 1:3), 1), ...
                                                'Start', ...
                                                class_centers, ...
                                                'MaxIter', ...
                                                1, ...
                                                'EmptyAction', ...
                                                'drop', ...
                                                'Display', ...
                                                'off');

        if (all(prev_class_indices == class_indices))
            % Enable warnings for kmeans nonconvergence
            % because this computation is completed
            warning('on', 'stats:kmeans:FailedToConverge');
            break;
        end

        prev_class_indices = class_indices;

        for p = 1:size(colors, 1)
            if (~isnan(hue_constraints(p)))
                class_center_hsv = rgb2hsv(class_centers(p, :) ./ 255);
                class_center_hsv(1) = hue_constraints(p);
                class_centers(p, :) = hsv2rgb(class_center_hsv) .* 255;
            end
        end
    end
end

if (exist('fill', 'var') ~= 1)
	output_layers = fv_colorseg(class_centers, input_image, fuzziness);
else
	output_layers = fv_colorseg(class_centers, input_image, fuzziness, fill);
end

end
