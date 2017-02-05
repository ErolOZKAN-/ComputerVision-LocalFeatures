%An interactive method to specify and then save many point correspondences
%between two photographs which can later be used to evaluate matching
%algorithms.
function extractallcorrespondes()

image1 = imread('../data/arch/01.png');
image2 = imread('../data/arch/02.png');

image1 = double(image1)/255;
image2 = double(image2)/255;

output_file = '../data/arch/allmatches.mat';

if(exist(output_file,'file'))
    load(output_file)
    h = show_correspondence(image1, image2, x1, y1, x2, y2)
else
    x1 = zeros(0,1); %x locations in image 1
    y1 = zeros(0,1); %y locations in image 1
    x2 = zeros(0,1); %corresponding x locations in image 2
    y2 = zeros(0,1); %corresponding y locations in image 2
    
    h = figure;
    subplot(1,2,1);
    imshow(image1)

    subplot(1,2,2);
    imshow(image2)
end

fprintf('Click on a negative coordinate (Above or to the left of the left image) to stop\n')

while(1)
    [x,y] = ginput(1);
    if(x <= 0 || y <= 0)
        break
    end
    subplot(1,2,1);
    hold on;
    plot(x,y,'ro');
    hold off;
    x1 = [x1;x];
    y1 = [y1;y];
    
    [x,y] = ginput(1);
    if(x <= 0 || y <= 0)
        break
    end
    subplot(1,2,2);
    hold on;
    plot(x,y,'ro');
    hold off;
    x2 = [x2;x];
    y2 = [y2;y];
    
    fprintf('( %5.2f, %5.2f) matches to ( %5.2f, %5.2f)\n', x1(end), y1(end), x2(end), y2(end));
    fprintf('%d total points corresponded\n', length(x1));
end

fprintf('saving matched points\n')
save(output_file, 'x1', 'y1', 'x2', 'y2')

