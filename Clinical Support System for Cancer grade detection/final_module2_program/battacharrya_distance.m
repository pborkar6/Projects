function [ output_battacharrya ] = battacharrya_distance( input_distributions )
%BATTACHARRYA_DISTANCE
%   Computes the battacharrya distance between each pair of vectors in the
%   input cell array, then outputs the maximum. This provides a way to
%   rank a given feature by measuring how separable the most separable
%   pair of classes are.

if (~iscell(input_distributions))
    error('Input must be a cell array of vectors');
end

if (length(input_distributions) < 2)
    error('Input must contain atleast two vectors for comparison');
end

for i = 1:length(input_distributions)
    % Remove NaNs
    input_distributions{i} = ...
        double(input_distributions{i}(~isnan(input_distributions{i})));
end

battacharrya = 0;
max_battacharrya = 0;

for i = 1:1:length(input_distributions)
    for j = length(input_distributions):-1:(i + 1)
        % Use robust estimators of distributions
%         mu1 = median(input_distributions{i});
%         mu2 = median(input_distributions{j});
%         sig1 = qn_estimate(input_distributions{i}) .^ 2;
%         sig2 = qn_estimate(input_distributions{j}) .^ 2;
        
        mu1 = mean(input_distributions{i});
        mu2 = mean(input_distributions{j});
        sig1 = std(input_distributions{i}) .^ 2;
        sig2 = std(input_distributions{j}) .^ 2;
        
        battacharrya = ...
            (((mu1 - mu2) .^ 2) ./ (sig1 + sig2)) + ...
            log(0.25 .* (2 + (sig1 ./ sig2) + (sig2 ./ sig1)));
            
        battacharrya = 0.25 .* battacharrya;
        
        if (max_battacharrya < battacharrya)
            max_battacharrya = battacharrya;
        end
    end
end

output_battacharrya = max_battacharrya;

end

