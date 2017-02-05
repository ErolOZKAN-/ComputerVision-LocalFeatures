function [matches, confidences] = match_points(features1, features2,threshold)

distanceMatrix = calculate_feature_distance(features1, features2);

[sortedDistanceMatrix, indices] = sort(distanceMatrix, 2);
inverseConfidences = (sortedDistanceMatrix(:,1)./sortedDistanceMatrix(:,2));
confidences = 1./inverseConfidences(inverseConfidences < threshold);

matches = zeros(size(confidences,1), 2);
matches(:,1) = find(inverseConfidences < threshold);
matches(:,2) = indices(inverseConfidences < threshold, 1);

% Sort the matches. the highest confident values are at the top of the
% list. 
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);