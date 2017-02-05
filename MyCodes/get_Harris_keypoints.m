%HARRIS CORNER DETECTION IMPLEMNTATION
%This code createes a set of key points for the input image
%SEE : https://en.wikipedia.org/wiki/Corner_detection
function [x, y, confidence, scale, orientation] = get_Harris_keypoints(image, feature_width)

%K is a tunable sensitivity parameter, SEE wiki
K=0.04;

%creates a gausian filter that HSIZE is 25x25 and SIGMA equals to 1
gaussian = fspecial('Gaussian', [25 25], 1);

%imgradientxy finds the directional gradients of the given input data; image or matrix.
%[xder, yder] are the gradient along with X and Y axises of our gaussian flter
[xder, yder] = imgradientxy(gaussian);

%filters the image with x,y gradients of our gaussian filter. 
ix = imfilter(image, xder);
iy = imfilter(image, yder);

%to supress the gradients near the edges
ix([(1:feature_width) end-feature_width+(1:feature_width)],:) = 0;
ix(:, [(1:feature_width) end-feature_width+(1:feature_width)]) = 0;
iy([(1:feature_width) end-feature_width+(1:feature_width)],:) = 0;
iy(:, [(1:feature_width) end-feature_width+(1:feature_width)]) = 0;

%creates a gausian filter that HSIZE is 25x25 and SIGMA equals to 2, so
%this gausian filter is larger than the first one.
biggerGaussian = fspecial('Gaussian', [25 25], 2);

%filters below values with bigger_gaussian filter
ixx = imfilter(ix.*ix, biggerGaussian);
ixy = imfilter(ix.*iy, biggerGaussian);
iyy = imfilter(iy.*iy, biggerGaussian);

%The treshold to suppress some unwanted corners.
%right side is 1e-6
Mc = ixx.*iyy - ixy.*ixy - K.*(ixx+iyy).*(ixx+iyy);
thresholded = Mc > 10*mean2(Mc); 

Mc = Mc.*thresholded;
%colfilt returns the max value on each sliding window. This ensures
%that every interest point is at a local maximum
har_max = colfilt(Mc, [feature_width feature_width], 'sliding', @max);
Mc = Mc.*(Mc == har_max);
%'x' and 'y' are vectors of x and y coordinates of interest points in s
[y, x] = find(Mc > 0);
%'confidence' is an vector indicating the strength of the key point
confidence = Mc(Mc > 0);
