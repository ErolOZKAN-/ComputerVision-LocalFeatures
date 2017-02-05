function [ h ] = showConnection(image1, image2, X1, Y1, X2, Y2,fileNameToWrite)


h = figure;
set(h, 'Position', [100 100 800 600])
subplot(1,2,1);
imshow(image1, 'Border', 'tight')
subplot(1,2,2);
imshow(image2, 'Border', 'tight')

for i = 1:size(X1,1)
    title(strcat(fileNameToWrite,'_02'))
    cur_color = rand(3,1);
    subplot(1,2,1);
    hold on;
    plot(X1(i),Y1(i), 'o', 'LineWidth',2, 'MarkerEdgeColor','k',...
                       'MarkerFaceColor', cur_color, 'MarkerSize',10)

    hold off;
   title(strcat(fileNameToWrite,'_01'))
    subplot(1,2,2);
    hold on;
    plot(X2(i),Y2(i), 'o', 'LineWidth',2, 'MarkerEdgeColor','k',...
                       'MarkerFaceColor', cur_color, 'MarkerSize',10)
    hold off;
end

fileName = strcat('Saving correspondences to \t',fileNameToWrite);

fprintf(fileName)
fprintf('\n')

visualization_image = frame2im(getframe(h));

try
    visualization_image = visualization_image(81:end-80, 51:end-50,:);
catch
    ;
end
imwrite(visualization_image, strcat('RESULTS/',fileNameToWrite), 'quality', 100)