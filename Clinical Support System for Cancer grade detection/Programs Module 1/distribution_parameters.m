function [ output_parameters ] = distribution_parameters( input_distribution )
%DISTRIBUTION_PARAMETERS
%   Given an input vector, this function outputs a vector
%   containing the following distribution parameters:
%   - Average
%   - Standard Deviation
%   - Median
%   - Interquartile Range
%   - Skewness
%   - Kurtosis
%   - Disorder
%
%   Any NaNs in the input distribution are ignored.

no_nans_distribution = input_distribution(~isnan(input_distribution));

output_average = mean(no_nans_distribution);
output_stdev = std(no_nans_distribution);
output_disorder = (1 - (1 ./ (1 + (output_stdev ./ output_average))));

output_parameters = [output_average, ...
                     output_stdev, ...
                     median(no_nans_distribution), ...
                     iqr(no_nans_distribution), ...
                     skewness(no_nans_distribution), ...
                     kurtosis(no_nans_distribution), ...
                     output_disorder];

end
