function [calculatedFeatureList] = extract_GLOH_features(image, x, y, featureWidth)

pointNumber = size(x,1);
calculatedFeatureList = zeros(pointNumber, 128); %SIFT IS 128 B?T

%CREATE SMALL GAUSSIOAN
small_gaussian = fspecial('Gaussian', [featureWidth featureWidth], 1);
%CREATE BIGGER GAUSSIAN 
large_gaussian = fspecial('Gaussian', [featureWidth featureWidth], featureWidth/2);

%filters the image with x,y gradients of our gaussian filter.
[xDerivative, yDerivative] = imgradientxy(small_gaussian);
ix = imfilter(image, xDerivative);
iy = imfilter(image, yDerivative);

% function to be applied at each step , like functional interface in JAVA 8
getOctant = @(x,y) (ceil(atan2(y,x)/(pi/4)) + 4);
orients = arrayfun(getOctant, ix, iy);
%returns SQRT(ABS(A).^2+ABS(B).^2)
mag = hypot(ix, iy);
c_size = featureWidth/4;
for ii = 1:pointNumber
    frame_x_range = (x(ii) - 2*c_size): (x(ii) + 2*c_size-1);
    frame_y_range = (y(ii) - 2*c_size): (y(ii) + 2*c_size-1);
    %rectangle('Position', [x(ii) - 2*c_size, y(ii) - 2*c_size, feature_width, feature_width], 'EdgeColor', 'Red');
    frame_mag = mag(frame_y_range, frame_x_range);
    frame_mag = frame_mag.*large_gaussian;
    frame_orients = orients(frame_y_range, frame_x_range);
    % Looping through each cell in the frame
    for xx = 0:3
        for yy = 0:3
            cell_orients = frame_orients(xx*4+1:xx*4+4, yy*4+1:yy*4+4);
            cell_mag = frame_mag(xx*4+1:xx*4+4, yy*4+1:yy*4+4);
            for o = 1:8
                f = cell_orients == o;
                calculatedFeatureList(ii, (xx*32 + yy*8) + o) = sum(sum(cell_mag(f)));
            end
        end
    end
end
%Normalizes feature vectors
calculatedFeatureList = diag(1./sum(calculatedFeatureList,2))*calculatedFeatureList; 
    
end
