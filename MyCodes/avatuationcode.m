function avatuationcode()
clc;
clear all;

image1 = imread('../data/notredame/01.png');
image2 = imread('../data/notredame/02.png');

I1 = rgb2gray(image1);
I2 = rgb2gray(image2);

%points1 = 	detectHarrisFeatures (I1);
%points2 = 	detectHarrisFeatures (I2);

points1 = 	detectMSERFeatures (I1);
points2 = 	detectMSERFeatures (I2);

%points1 = 	detectSURFFeatures (I1);
%points2 = 	detectSURFFeatures (I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);

location1 = matchedPoints1.Location;
location2 = matchedPoints2.Location;

draw(image1,location1,'1' );
draw(image2,location2,'2' );

end

function draw(img,pt,str)
    figure('Name',str);
    imshow(img);
    hold on;
    axis off;
    switch size(pt,2)
        case 2
            s = 2;
            for i=1:size(pt,1)
                rectangle('Position',[pt(i,2)-s,pt(i,1)-s,2*s,2*s],'Curvature',[0 0],'EdgeColor','b','LineWidth',2);
            end
        case 3
            for i=1:size(pt,1)
                rectangle('Position',[pt(i,2)-pt(i,3),pt(i,1)-pt(i,3),2*pt(i,3),2*pt(i,3)],'Curvature',[1,1],'EdgeColor','w','LineWidth',2);
            end
    end
end