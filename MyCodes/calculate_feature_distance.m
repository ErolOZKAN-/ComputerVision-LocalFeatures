%This function gets two feaure set, then returns euclidean distance matrix
%between each element of faature set

%PDIST2 Pairwise distance between two sets of observations.
%   D = PDIST2(X,Y) returns a matrix D containing the Euclidean distances
%   between each pair of observations
function [distanceMatrix] = calculate_feature_distance(feature1, feature2)
distanceMatrix = pdist2(feature1, feature2, 'euclidean');
