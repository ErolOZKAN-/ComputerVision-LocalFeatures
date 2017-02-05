function [abc] = match_images(filePathIndexToRead, keypointDetection, featureExtraction,alsoEvaluate,thresholdForMatch)
%SET THIS VALUES BEFORE USING THE PROGRAM

directory = dir( '../data/');
filePathToRead = directory(filePathIndexToRead).name;

fprintf(strcat(char(filePathToRead),' folder is going to be read to match images.'));
fprintf('\n')

filepath1 = strcat('../data/',filePathToRead);
filepath1 = strcat (filepath1, '/01.png');
image1 = imread(filepath1);

filepath2 = strcat('../data/',filePathToRead);
filepath2 = strcat (filepath2, '/02.png');
image2 = imread(filepath2);

fileNameToWrite= strcat(strcat(strcat(filePathToRead,char(keypointDetection)),char(featureExtraction)) ,'.jpg');

scalee = 1; 
featureWidth = 16; %width and height of each local feature, in pixels. 

image1 = rgb2gray(single(image1)/255);
image2 = rgb2gray(single(image2)/255);

image1 = imresize(image1, scalee, 'bilinear');
image2 = imresize(image2, scalee, 'bilinear');


%% Decision
if keypointDetection == KeyPointDetector.HARRIS
    [x1, y1] = get_Harris_keypoints(image1, featureWidth);
    [x2, y2] = get_Harris_keypoints(image2, featureWidth);

elseif  keypointDetection == KeyPointDetector.MSER
    [x1, y1] = get_MSER_keypoints(image1, featureWidth);
    [x2, y2] = get_MSER_keypoints(image2, featureWidth);

elseif  keypointDetection == KeyPointDetector.DOG
    [x1, y1] = get_DOG_keypoints(image1, featureWidth);
    [x2, y2] = get_DOG_keypoints(image2, featureWidth);
end

if featureExtraction == FeatureExtractor.SIFT
    [image1Features] = extract_SIFT_features(image1, x1, y1, featureWidth);
    [image2Features] = extract_SIFT_features(image2, x2, y2, featureWidth);
elseif featureExtraction == FeatureExtractor.PCASIFT
    [image1Features] = extract_PCASIFT_features(image1, x1, y1, featureWidth);
    [image2Features] = extract_PCASIFT_features(image2, x2, y2, featureWidth);
elseif featureExtraction == FeatureExtractor.GLOH
    [image1Features] = extract_GLOH_features(image1, x1, y1, featureWidth);
    [image2Features] = extract_GLOH_features(image2, x2, y2, featureWidth);
end
%%
fprintf(strcat(char(keypointDetection),' is going to be used as key point detector'));
fprintf('\n')
fprintf(strcat(char(featureExtraction),' is going to be used as feature extractor'));
fprintf('\n')

%% Match points and features. 
[matches, confidences] = match_points(image1Features, image2Features,thresholdForMatch);

numberOfPointToSee = size(matches,1);

showCorrespondence(image1, image2, x1(matches(1:numberOfPointToSee,1)), ...
                                    y1(matches(1:numberOfPointToSee,1)), ...
                                    x2(matches(1:numberOfPointToSee,2)), ...
                                    y2(matches(1:numberOfPointToSee,2)),fileNameToWrite);
%% evaluate correspondences                              
if alsoEvaluate
    evaluateCorrespondence(image1,image2,x1(matches(1:numberOfPointToSee,1))/scalee, ...
                       y1(matches(1:numberOfPointToSee,1))/scalee, ...
                       x2(matches(1:numberOfPointToSee,2))/scalee, ...
                       y2(matches(1:numberOfPointToSee,2))/scalee,filePathToRead,fileNameToWrite);
end