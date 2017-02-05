function showAllCorrespondences()

image1 = imread('../data/notredame/01.png');
image2 = imread('../data/notredame/02.png');

allMatches = '../data/notredame/allmatches.mat';

load(allMatches)

showCorrespondence(image1, image2, x1, y1, x2, y2,'allMatches')