function [ output_features ] = haralick_features ( input_image )

grayvals = 256;

grayimage = uint8(input_image);

if (size(grayimage, 3) == 3)
    grayimage = uint8((double(grayimage(:, :, 1)) + ...
                       double(grayimage(:, :, 2)) + ...
                       double(grayimage(:, :, 3))) ./ 3);
end

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
                              'NumLevels', ...
                              grayvals);

[M, N, ~] = size(grayimage_glcm);

angular_second_moment     = 0;
inverse_difference_moment = 0;
contrast                  = 0;
correlation               = 0;
entropy                   = 0;
sum_average               = 0;

for k = 1:length(offsets)
    p = grayimage_glcm(:, :, k) ./ (M .* N);
    
    % 1. Angular Second Moment
    angular_second_moment = angular_second_moment + ...
                            sum(sum(p.^2));
    
    % 2. Inverse difference moment
    for i = 1:M
        for j = 1:N
            inverse_difference_moment = inverse_difference_moment + ...
                                        p(i, j) .* ...
                                        (1 ./ (1 + (i - j).^2));
        end
    end

    % 3. Contrast
    % 4. Correlation
    glcm_prop = graycoprops(grayimage_glcm(:, :, k));
    
    contrast    = contrast    + glcm_prop.Contrast;
    correlation = correlation + glcm_prop.Correlation;
    
    % 5. Entropy
    for i = 1:M
        for j = 1:N
            if (p(i, j) > 0) % log(0) is undefined; ignore these
                entropy = entropy - p(i, j) * log(p(i, j));
            end
        end
    end
    
    % 6. Sum Average
    for i = 2:1:2*grayvals
        p_x_plus_y = 0;
        for j = max(1, i - grayvals):1:min(i - 1, grayvals)
            p_x_plus_y = p_x_plus_y + p(i - j, j);
        end
        sum_average = sum_average + i .* p_x_plus_y;
    end
end

angular_second_moment     = angular_second_moment     ./ length(offsets);
inverse_difference_moment = inverse_difference_moment ./ length(offsets);
contrast                  = contrast                  ./ length(offsets);
correlation               = correlation               ./ length(offsets);
entropy                   = entropy                   ./ length(offsets);
sum_average               = sum_average               ./ length(offsets);

output_features = [angular_second_moment, ...
                   inverse_difference_moment, ...
                   contrast, ...
                   correlation, ...
                   entropy, ...
                   sum_average];

end

    