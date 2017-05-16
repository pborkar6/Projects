function [ output_image ] = outlier_downsample( input_image, downsample )
%OUTLIER_DOWNSAMPLE
%   Downsamples an image by chopping it into blocks
%   and assigning to each block the color that has
%   the largest deviation from the block mean.
%   This method is intended to preserve the convex hull
%   of the color map as much as possible when downsampling.

% Preprocess downsample parameter
if (downsample < 1)
    % Limit range
    downsample = 1;
end

% Make integer
downsample = round(downsample);

% Initialize storage
[M, N, ~] = size(input_image);

M_out = ceil(double(M) / double(downsample));
N_out = ceil(double(N) / double(downsample));

output_image = input_image(1:downsample:M, ...
                           1:downsample:N, ...
                           :);

% Find the outlier of each block and assign it
% to the pixel in the resulting image
for i = 1:M_out
    for j = 1:N_out
        i_lower_range = ((i - 1) * downsample) + 1;
        j_lower_range = ((j - 1) * downsample) + 1;
        
        if ((i * downsample) > M)
            i_upper_range = M;
        else
            i_upper_range = i * downsample;
        end
        
        if ((j * downsample) > N)
            j_upper_range = N;
        else
            j_upper_range = j * downsample;
        end
        
        block = double(input_image(i_lower_range:i_upper_range, ...
                                   j_lower_range:j_upper_range, ...
                                   :));
        
        block_mean = reshape(sum(sum(block,1),2), 1, 3) / ...
                     numel(block(:, :, 1));
                 
        block_variances = (block(:, :, 1) - block_mean(1)).^2 + ...
                          (block(:, :, 2) - block_mean(2)).^2 + ...
                          (block(:, :, 3) - block_mean(3)).^2;
        
        block_variances_vector = block_variances(:);
        
        [~, max_index] = max(block_variances_vector);
        
        [max_i, max_j] = ind2sub([size(block, 1), size(block, 2)], ...
                                 max_index);
        
        output_image(i, j, :) = input_image(max_i + i_lower_range - 1, ...
                                            max_j + j_lower_range - 1, ...
                                            :);
    end
end

end
