%%
close all
clear all
%% THE FILE TO READ!!!!!!!! ...th folder in the directory. (IN DATA FOLDER)
% . is first one (dont chooise this)
% .. is the second one (dont chooise this)
% start from 3!
alsoEvaluate = false(1); %boolean : wheter evaluation step is going be happen or not
treshold= 0.8;%play with treshold for better results
for i = 3:7%DIRECTORY INDICES, run runner to work with a single image.
%%SIFT    
%%SET ENUM VALUES 
keypointDetection = KeyPointDetector.HARRIS;%HARRIS
featureExtraction = FeatureExtractor.SIFT;%SIFT
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);

keypointDetection = KeyPointDetector.MSER;%MSER,
featureExtraction = FeatureExtractor.SIFT;%SIFT
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);

keypointDetection = KeyPointDetector.DOG;%DOG
featureExtraction = FeatureExtractor.SIFT;%SIFT
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);
%%PCA SIFT
keypointDetection = KeyPointDetector.HARRIS;%HARRIS
featureExtraction = FeatureExtractor.PCASIFT;%PCASIFT
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);

keypointDetection = KeyPointDetector.MSER;%MSER
featureExtraction = FeatureExtractor.PCASIFT;%PCASIFT
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);

keypointDetection = KeyPointDetector.DOG;%,DOG
featureExtraction = FeatureExtractor.PCASIFT;%PCASIFT
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);

%%GLOH
keypointDetection = KeyPointDetector.HARRIS;%HARRIS
featureExtraction = FeatureExtractor.GLOH;%GLOH
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);

keypointDetection = KeyPointDetector.MSER;%MSER
featureExtraction = FeatureExtractor.GLOH;%GLOH
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);

keypointDetection = KeyPointDetector.DOG;%DOG
featureExtraction = FeatureExtractor.GLOH;%GLOH
match_images(i,keypointDetection,featureExtraction,alsoEvaluate,treshold);
end
%OUTPUT WiLL BE SAVED TO RESULTS DIRECTORY