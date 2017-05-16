function [ output_feature_rank ] = rank_features( input_feature_matrix )
%RANK_FEATURES
%   Uses class labels to determine the separability of each feature using
%   the Battacharrya distance. Each pair of classes is compared and the
%   maximum Battacharrya distance between them is the rank for that
%   particular feature. A larger value represents better seperability, and
%   is therefore better for use in a classifier than features with smaller
%   values.

if (~iscell(input_feature_matrix))
    error('Input must be a feature matrix (cell array with 3 members: feature values, feature labels, and class labels)');
end

if (length(input_feature_matrix) < 3)
    error('Input must be a feature matrix (cell array with 3 members: feature values, feature labels, and class labels)');
end

class_labels = cell(0);

for i = 1:size(input_feature_matrix{1}, 1)
    temp_label = input_feature_matrix{3}{i};
    if (~any(strcmpi(temp_label, class_labels)))
        class_labels = [class_labels; temp_label];
    end
end

class_row_indices = cell(length(class_labels), 1);

for i = 1:size(input_feature_matrix{1}, 1)
    temp_label = input_feature_matrix{3}{i};
    for j = 1:length(class_row_indices)
        if (strcmpi(temp_label, class_labels{j}))
            class_row_indices{j} = [class_row_indices{j}; ...
                                    i];
            break;
        end
    end
end

feature_rank = zeros(size(input_feature_matrix{1}, 2), 1);

for k = 1:size(input_feature_matrix{1}, 2)
    feature = cell(length(class_row_indices), 1);
    
    for j = 1:length(class_row_indices)
        feature{j} = input_feature_matrix{1}(class_row_indices{j}, k);
    end

    feature_rank(k) = battacharrya_distance(feature);
end

max_finite = max(feature_rank(~isinf(feature_rank)));

if (isempty(max_finite))
    max_finite = 1;
end

min_finite = min(feature_rank(~isinf(feature_rank)));

if (isempty(min_finite))
    min_finite = 0;
end

% Replace positive infinities with the largest finite value
feature_rank(and(isinf(feature_rank), (feature_rank >= 0))) = ...
    max_finite;

% Replace negative infinities with the smallest finite value
feature_rank(and(isinf(feature_rank), (feature_rank < 0))) = ...
    min_finite;

% Replace NaNs with the smallest finite value
feature_rank(isnan(feature_rank)) = min_finite;

output_feature_rank = feature_rank;

end

