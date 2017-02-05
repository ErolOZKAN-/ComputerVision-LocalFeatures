%%
close all
clear all
%% THE FILE TO READ!!!!!!!! ...th folder in the directory. (IN DATA FOLDER)
% . is first one (dont chooise this)
% .. is the second one (dont chooise this)
% start from 3!
%%
close all
clear all
%% THE FILE TO READ!!!!!!!! ...th folder in the directory. (IN DATA FOLDER)
% . is first one (dont chooise this)
% .. is the second one (dont chooise this)
% start from 3!
filePathIndexToRead = 4;%2TH FOLDER IN DATA DIRECTORY,  3 is the first one, 4 is second one! and it goes on...
alsoEvaluate = true(1); %boolean : wheter evaluation step is going be happen or not.
treshold= 0.8;

keypointDetection = KeyPointDetector.MSER;%HARRIS,MSER,DOG 
featureExtraction = FeatureExtractor.SIFT;%SIFT,PCASIFT,GLOH
match_images(filePathIndexToRead,keypointDetection,featureExtraction,alsoEvaluate,treshold);


%OUTPUT WiLL BE SAVED TO RESULTS DIRECTORY