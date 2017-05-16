function [ output_layers ] = kmeans_fv_colorseg( colors, input_image, fuzziness, fill )
%KMEANS_FV_COLORSEG
%   Segments an image by color using k-means clustering on the
%   colormap of the image with the additional fuzziness
%   parameter for fv_colorseg. To acheive reasonable performance
%   on 24-bit 512x512 images, the algorithm downsamples the image
%   when computing the colormap.

if (size(colors, 2) ~= 3)
    error('Colors parameter must have rows of length 3 (24-bit RGB color)');
end

max_dim = max(size(input_image, 1), ...
              size(input_image, 2));

if (max_dim >= 32)
    downsample = max_dim / 32;
else
    downsample = 1;
end

colormap = build_colormap(input_image, downsample);

[~, class_centers] = kmeans(double(colormap), ...
                            size(colors, 1), ...
                            'Start', ...
                            double(colors));

if (exist('fill', 'var') ~= 1)
	output_layers = fv_colorseg(class_centers, input_image, fuzziness);
else
	output_layers = fv_colorseg(class_centers, input_image, fuzziness, fill);
end

end
