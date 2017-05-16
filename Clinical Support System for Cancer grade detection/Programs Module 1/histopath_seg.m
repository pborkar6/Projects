function [ output_regions ] = histopath_seg( colors, input_image, options, fuzziness, watershed_blur )
%HISTOPATH_SEG
%   Segments a histopathology slide using K-means clustering on the
%   image colormap with the option of further segmenting the resulting
%   layers using watershed segmentation, which is used to differentiate
%   spatially adjacent objects in the same layer (i.e. nuclei).

if ((size(colors, 2) ~= 3) && ...
    (size(colors, 2) ~= 4))
    error('Colors parameter must have rows of length 3, or 4 (24-bit RGB color, and flag for watershed segmentation)');
end

watershed_layers = true(size(colors, 1), 1);

if (size(colors, 2) == 4)
    watershed_layers = (colors(:, 4) ~= 0);
end

fill = 1;

if (exist('options', 'var') ~= 1)
    options = 1;
elseif ((options < 0) || ...
        (options > 3))
    options = 1;
else
    options = round(options);
end

if (exist('fuzziness', 'var') ~= 1)
    fuzziness = 2;
end

if (exist('watershed_blur', 'var') ~= 1)
    watershed_blur = 2;
end

if (options == 0)
    % No fill or watershed segmentation
    fill = 0;
end

[M, N, ~] = size(input_image);

if ((options == 0) || ...
    (options == 1))

    regions = cell(size(colors, 1), 1);

    layers = kmeans_fv_colorseg(colors(:, 1:3), ...
                                input_image, ...
                                fuzziness, ...
                                fill);
    
    for p = 1:size(colors, 1)
        regions{p} = bwconncomp(layers(:, :, p), 4);
    end
    
elseif (options == 2)

    regions = cell(size(colors, 1), 1);
    
    layers = kmeans_fv_colorseg(colors(:, 1:3), ...
                                input_image, ...
                                fuzziness, ...
                                fill);
    
    gray_image = uint8((double(input_image(:, :, 1)) + ...
                        double(input_image(:, :, 2)) + ...
                        double(input_image(:, :, 3))) ./ 3);
    
    watershed_image = logical(watershed(imgaussfilt(gray_image, watershed_blur)) ~= 0);
    
    for p = 1:size(colors, 1)
        if (watershed_layers(p) == true)
            layers(:, :, p) = and(layers(:, :, p), watershed_image);
        end
    end
    
    region_image = zeros(M, N, size(colors, 1));
    
    for p = 1:size(colors, 1)
        regions{p} = bwconncomp(layers(:, :, p), 4);
        for i = 1:length(regions{p}.PixelIdxList)
            for j = 1:length(regions{p}.PixelIdxList{i})
                [k, l] = ind2sub([M, N], regions{p}.PixelIdxList{i}(j));
                region_image(k, l, p) = i;
            end
        end
    end
    
    % Some pixels are now unclassified due to watershed segmentation;
    % assign them to the nearest region
    watershed_unassigned = watershed_image;
    
    for p = 1:size(colors, 1)
        if (watershed_layers(p) == false)
            watershed_unassigned = or(watershed_unassigned, layers(:, :, p));
        end
    end
    
    for i = 1:M
        for j = 1:N
            if (watershed_unassigned(i, j) == false)
                [k, l] = spiral_search(watershed_unassigned, i, j);
                pixel_index = sub2ind([M, N], i, j);
                for p = 1:size(colors, 1)
                    if (region_image(k, l, p) > 0)
                        regions{p}.PixelIdxList{region_image(k, l, p)} = ...
                            [regions{p}.PixelIdxList{region_image(k, l, p)}; ...
                             pixel_index];
                        break;
                    end
                end
            end
        end
    end
    
elseif (options == 3)

    regions = cell(1);
                            
    gray_image = uint8((double(input_image(:, :, 1)) + ...
                        double(input_image(:, :, 2)) + ...
                        double(input_image(:, :, 3))) ./ 3);
    
    watershed_image = logical(watershed(imgaussfilt(gray_image, watershed_blur)) ~= 0);
    
    region_image = zeros(M, N);
    
    regions{1} = bwconncomp(watershed_image, 4);
    
    for i = 1:length(regions{1}.PixelIdxList)
        for j = 1:length(regions{1}.PixelIdxList{i})
            [k, l] = ind2sub([M, N], regions{1}.PixelIdxList{i}(j));
            region_image(k, l) = i;
        end
    end
    
    % Some pixels are now unclassified due to watershed segmentation;
    % assign them to the nearest region
    watershed_unassigned = watershed_image;
    
    for i = 1:M
        for j = 1:N
            if (watershed_unassigned(i, j) == false)
                [k, l] = spiral_search(watershed_unassigned, i, j);
                pixel_index = sub2ind([M, N], i, j);
                if (region_image(k, l) > 0)
                    regions{1}.PixelIdxList{region_image(k, l)} = ...
                        [regions{1}.PixelIdxList{region_image(k, l)}; ...
                         pixel_index];
                end
            end
        end
    end
    
end

output_regions = regions;

end