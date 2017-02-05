function test()
    % The test function gives an example of keypoint extraction using the
    % methods :
    % - Harris
    % - SUSAN
    % - LoG (Laplacian of Gaussian)
    % - Harris-Laplace
    % - Gilles
    %
    % Example
    % =======
    % test();

    % Harris
    img = imread('../data/notredame/01.png');
    pt  = kp_harris(img);
    draw(img,pt,'Harris');

  

    % Harris-Laplace
    
    pt  = kp_harrislaplace(rgb2gray(img));
    draw(img,pt,'Harris Laplace');

   

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