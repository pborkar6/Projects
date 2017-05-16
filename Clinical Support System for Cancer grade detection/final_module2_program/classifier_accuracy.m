function [ accuracy_out, kappa_out ] = classifier_accuracy( confusion_matrix_input )
%CLASSIFIER_ACCURACY
%   Computes two performances metrics for a classifier given a confusion
%   matrix. The first is the accuracy, defined as (successful_hits/total).
%   The second is Cohen's Kappa, which takes into account expected
%   accuracy as well as observed accuracy, defined as
%   
%       (successful_hits - successful_hits_due_to_chance) /
%       (total           - successful_hits_due_to_chance)

successful_hits = sum(trace(confusion_matrix_input));
total           = sum(sum(confusion_matrix_input));

% Accuracy
accuracy_out = successful_hits ./ total;

% Cohen's Kappa
successful_hits_due_to_chance = 0;

for i = 1:size(confusion_matrix_input, 1)
    successful_hits_due_to_chance = successful_hits_due_to_chance + ...
        ((sum(confusion_matrix_input(i, :)) .* ...
          sum(confusion_matrix_input(:, i))) ./ ...
         total);
end

kappa_out = ...
    (successful_hits - successful_hits_due_to_chance) ./ ...
    (total           - successful_hits_due_to_chance);

end
