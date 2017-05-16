function [ output_features ] = haralick_features ( input_image, input_mask )
%HARALICK_FEATURES
%   Calculates the gray level co-occurence matrix (GLCM)
%   of the intensity values of an image and determines
%   several of the texture features described by Haralick.
%   The GLCM is calculated for offsets of distance 1 to 4
%   pixels apart horizontally, vertically, and diagonally.
%   The GLCM is only calculated using pixels of the input
%   that have a value of "true" in the corresponding mask.

% Use 257 gray levels;
% the value 0 represents a pixel that was removed
% by the mask, and the values [1,256] map to [0,255];
% the first row and column of the GLCM will be removed,
% the effect of which is to filter out the contributions
% by pixels not in the region specified by the mask
grayvals = 257;

grayimage = uint8(input_image);

if (size(grayimage, 3) == 3)
    grayimage = uint8((double(grayimage(:, :, 1)) + ...
                       double(grayimage(:, :, 2)) + ...
                       double(grayimage(:, :, 3))) ./ 3);
end

grayimage = (uint16(grayimage) + 1) .* ...
            uint16(input_mask ~= 0);

offsets = [ 1,  0; ...
            1,  1; ...
            0,  1; ...
           -1,  1; ...
            2,  0; ...
            2,  2; ...
            0,  2; ...
           -2,  2; ...
            3,  0; ...
            3,  3; ...
            0,  3; ...
           -3,  3; ...
            4,  0; ...
            4,  4; ...
            0,  4; ...
           -4,  4];

grayimage_glcm = graycomatrix(grayimage, ...
                              'Offset', ...
                              offsets, ...
                              'GrayLimits', ...
                              [0, 256], ...
                              'NumLevels', ...
                              grayvals, ...
                              'Symmetric', ...
                              true);

% Remove masked pixels from the GLCM
% and flatten to a single matrix
grayimage_glcm = grayimage_glcm(2:end, 2:end);
grayimage_glcm = sum(grayimage_glcm, 3);

p = grayimage_glcm ./ sum(sum(grayimage_glcm));

angular_second_moment     = 0;
inverse_difference_moment = 0;
contrast                  = 0;
correlation               = 0;
entropy                   = 0;
sum_average               = 0;

% 1. Angular Second Moment
angular_second_moment = angular_second_moment + ...
                        sum(sum(p.^2));

% 2. Inverse difference moment
for i = 1:size(p, 1)
    for j = 1:size(p, 2)
        inverse_difference_moment = inverse_difference_moment + ...
                                    p(i, j) ./ ...
                                    (1 + (i - j).^2);
    end
end

% 3. Contrast
for i = 1:size(p, 1)
    for j = 1:size(p, 2)
        contrast = contrast + ...
                   p(i, j) .* ...
                   (i - j).^2;
    end
end

% 4. Correlation
glcm_prop = graycoprops(grayimage_glcm);
correlation = glcm_prop.Correlation;

% 5. Entropy
for i = 1:size(p, 1)
    for j = 1:size(p, 2)
        % log(0) is undefined;
        % the limit of x*log(x) as x goes to zero
        % equals zero, so these terms can be ignored
        if (p(i, j) > 0)
            entropy = entropy - (p(i, j) .* log(p(i, j)));
        end
    end
end

% 6. Sum Average
for i = 2:1:2*size(p, 1)
    p_x_plus_y = 0;
    for j = max(1, i - size(p, 1)):1:min(i - 1, size(p, 1))
        p_x_plus_y = p_x_plus_y + p(i - j, j);
    end
    sum_average = sum_average + i .* p_x_plus_y;
end

output_features = [angular_second_moment, ...
                   inverse_difference_moment, ...
                   contrast, ...
                   correlation, ...
                   entropy, ...
                   sum_average];

end

    