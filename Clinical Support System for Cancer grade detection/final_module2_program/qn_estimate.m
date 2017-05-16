function [ qn_out ] = qn_estimate( input_distribution )
%QN_ESTIMATE
%   Computes the Qn estimate of the input distribution. The Qn estimate
%   provides a robust estimation of "scale" i.e. the standard deviation
%   of a normal distribution. Unlike the sample standard deviation, the
%   Qn estimate is less influenced by outliers.

qn_estimate = 0;

if (length(input_distribution) >= 2)
    pairwise_diff = ...
        zeros( ...
            length(input_distribution) .* ...
            (length(input_distribution) - 1) ./ 2, 1);
    
    k = 1;

    for i = 2:1:length(input_distribution)
        for j = 1:1:(i - 1)
            pairwise_diff(k) = ...
                abs(input_distribution(i) - input_distribution(j));
            
            k = k + 1;
        end
    end

    pairwise_diff_sort = sort(pairwise_diff);
    
    kth_order = nchoosek(floor(length(input_distribution) ./ 2) + 1, 2);
    
    if (kth_order > length(pairwise_diff_sort))
        kth_order = length(pairwise_diff_sort);
    elseif (kth_order < 1)
        kth_order = 1;
    end

    qn_estimate = ...
        2.2219 .* ...
        pairwise_diff_sort(kth_order);
end

qn_out = qn_estimate;

end

