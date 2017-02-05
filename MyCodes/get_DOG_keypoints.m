%creates two gausian filters that HSIZE is 25x25 and SIGMA equals to 1 for
%50 for larger one, this code first uses DOG filter in the image, then it
%finds edges.
function [x, y, confidence, scale, orientation] = get_MSER_keypoints(image, feature_width)

k = 50;
sigma1 =  1;
sigma2 = sigma1*k;
hsize = [25,25];
h1 = fspecial('gaussian', hsize, sigma1);
h2 = fspecial('gaussian', hsize, sigma2);
gauss1 = imfilter(image,h1,'same');
gauss2 = imfilter(image,h2,'same');
dogImg = gauss1 - gauss2;

K=0.04;
gaussian = fspecial('Gaussian', [25 25], 1);
[xder, yder] = imgradientxy(gaussian);
ix = imfilter(dogImg, xder);
iy = imfilter(dogImg, yder);
ix([(1:feature_width) end-feature_width+(1:feature_width)],:) = 0;
ix(:, [(1:feature_width) end-feature_width+(1:feature_width)]) = 0;
iy([(1:feature_width) end-feature_width+(1:feature_width)],:) = 0;
iy(:, [(1:feature_width) end-feature_width+(1:feature_width)]) = 0;

biggerGaussian = fspecial('Gaussian', [25 25], 2);

ixx = imfilter(ix.*ix, biggerGaussian);
ixy = imfilter(ix.*iy, biggerGaussian);
iyy = imfilter(iy.*iy, biggerGaussian);

Mc = ixx.*iyy - ixy.*ixy - K.*(ixx+iyy).*(ixx+iyy);
thresholded = Mc > 10*mean2(Mc); 

Mc = Mc.*thresholded;
har_max = colfilt(Mc, [feature_width feature_width], 'sliding', @max);
Mc = Mc.*(Mc == har_max);
[y, x] = find(Mc > 0);
confidence = Mc(Mc > 0);
