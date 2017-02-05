%MSER IMPLEMNTATION
%This code createes a set of key points for the image based on MSER algoritm I created.
%Firsh part is the same as get_Harris_keypoints algorithm but then this 
%code finds components that has similiar to each other based on their intensity
%values. 
%SEE : https://en.wikipedia.org/wiki/Connected-component_labeling
%SEE : https://en.wikipedia.org/wiki/Maximally_stable_extremal_regions
%SEE : https://www.mathworks.com/help/images/ref/bwconncomp.html
function [x, y, confidence, scale, orientation] = get_MSER_keypoints(image, feature_width)

%K is a tunable sensitivity parameter
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

%bwconncomp finds connected components in thresholded binary image. 
%I take the maximum value in each component.
components = bwconncomp(thresholded);
width = components.ImageSize(1);
x = zeros(components.NumObjects, 1);
y = zeros(components.NumObjects, 1);
confidence = zeros(components.NumObjects, 1);

for ii=1:(components.NumObjects)
    pixel_ids = components.PixelIdxList{ii};
    pixel_values = Mc(pixel_ids);
    [max_value, max_id] = max(pixel_values);
    %'x' and 'y' are vectors of x and y coordinates of interest points in s
    x(ii) = floor(pixel_ids(max_id)/ width);
    y(ii) = mod(pixel_ids(max_id), width);
    %'confidence' is an vector indicating the strength of the key point tha
	confidence(ii) = max_value;
end
