function [ output_image ] = outline_regions( input_regions )
%OUTLINE_REGIONS
%   Accepts the output of the function bwconncomp and
%   produces a binary image whose pixels are 1 wherever
%   there is a region boundary and 0 elsewhere.

M = input_regions.ImageSize(1);
N = input_regions.ImageSize(2);

output_image = false(M, N);

for i = 1:length(input_regions.PixelIdxList)
    region_outline_image = false(M, N);
    for j = 1:length(input_regions.PixelIdxList{i})
        [p, q] = ind2sub([M, N], input_regions.PixelIdxList{i}(j));
        region_outline_image(p, q) = true;
    end
    region_outline_image = bwperim(region_outline_image);
    output_image = or(output_image, region_outline_image);
end

end