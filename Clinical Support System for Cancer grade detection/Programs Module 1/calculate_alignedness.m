function [ alignedness ] = calculate_alignedness( input, neighbors )
%CALCULATE_ALIGNEDNESS
%   Calculates the "alignedness" of an ellipse with respect to
%   its neighbor ellipses. Eccentricity is assumed to be the
%   "2nd flattening", because it is linear with respect to
%   the length of the major axis and zero implies no eccentricity.
%   Orientation is expected to be a value between 0 and pi.

input_eccentricity = input(1);
input_orientation  = input(2);

% Transform to alignedness-space
neighbors_transformed = zeros(size(neighbors, 1), 2);

neighbors_transformed(:, 1) = neighbors(:, 1) .* cos(2.* neighbors(:, 2));
neighbors_transformed(:, 2) = neighbors(:, 1) .* sin(2.* neighbors(:, 2));

% Calculate the "average" of neighbors
avg_transformed = sum(neighbors_transformed, 1) ./ size(neighbors_transformed, 1);

% Transform back to eccentricity and orientation
avg_eccentricity = sqrt(dot(avg_transformed, avg_transformed));
avg_orientation  = atan2(avg_transformed(2), avg_transformed(1));
avg_orientation  = (avg_orientation >= 0) .*  avg_orientation + ...
                   (avg_orientation <  0) .* (avg_orientation + 2 * pi);
avg_orientation  = avg_orientation ./ 2;

% Calculate the "alignedness"
alignedness = sqrt(avg_eccentricity .* input_eccentricity) .* ...
              cos(2 .* (avg_orientation - input_orientation));

end
