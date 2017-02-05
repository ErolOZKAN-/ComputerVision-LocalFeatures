function evaluateCorrespondence(image1,image2,x1_est, y1_est, x2_est, y2_est,filePathToRead,fileNameToWrite)

stringg = '../data/';
stringg= strcat(stringg,filePathToRead ); 
stringg = strcat(stringg, '/allmatches.mat');

%%This file hold all matches , created with matlab functions, it is
%%included in folder. 
allCorresponcesFileCreated = stringg;
load(allCorresponcesFileCreated)

good_matches = zeros(length(x1_est),1); 

h = figure;
set(h, 'Position', [100 100 800 600])
subplot(1,2,1);
imshow(image1, 'Border', 'tight')
subplot(1,2,2);
imshow(image2, 'Border', 'tight')


for i = 1:length(x1_est)
    
    fprintf('( %4.0f, %4.0f) to ( %4.0f, %4.0f)', x1_est(i), y1_est(i), x2_est(i), y2_est(i));
        
    %for each x1_est, find nearest ground truth point in x1
    x_dists = x1_est(i) - x1;
    y_dists = y1_est(i) - y1;
    dists = sqrt(  x_dists.^2 + y_dists.^2 );
    
    [dists, best_matches] = sort(dists);
    
    current_offset = [x1_est(i) - x2_est(i), y1_est(i) - y2_est(i)];
    most_similar_offset = [x1(best_matches(1)) - x2(best_matches(1)), y1(best_matches(1)) - y2(best_matches(1))];
    
    %match_dist = sqrt( (x2_est(i) - x2(best_matches(1)))^2 + (y2_est(i) - y2(best_matches(1)))^2);
    match_dist = sqrt( sum((current_offset - most_similar_offset).^2));
    
    %A match is bad if there ?S no ground truth point within 50 pixels or
    %if nearest ground truth correspondence offset isn't within 25 pixels
    %of the estimated correspondence offset.
    fprintf(' INDEX:%4.0f ERROR: %4.0f ', dists(1), match_dist);
    
    if(dists(1) > 150 || match_dist > 25)
        good_matches(i) = 0;
        edgeColor = [1 0 0];
        fprintf('  TRUE\n');
    else
        good_matches(i) = 1;
    	edgeColor = [0 1 0];
        fprintf('  FALSE\n');
    end

    cur_color = rand(1,3);
    subplot(1,2,1);
    hold on;
    plot(x1_est(i),y1_est(i), 'o', 'LineWidth',2, 'MarkerEdgeColor',edgeColor,...
                       'MarkerFaceColor', cur_color, 'MarkerSize',10)
    hold off;

    subplot(1,2,2);
    hold on;
    plot(x2_est(i),y2_est(i), 'o', 'LineWidth',2, 'MarkerEdgeColor',edgeColor,...
                       'MarkerFaceColor', cur_color, 'MarkerSize',10)
    hold off;
end

fprintf('%d good matches, %d bad matches\n', sum(good_matches), length(x1_est) - sum(good_matches))

fprintf('Saving visualization to file in RESULTS (EVAL)\n')
visualization_image = frame2im(getframe(h));
try    
    visualization_image = visualization_image(81:end-80, 51:end-50,:);
catch
    ;
end
imwrite(visualization_image,  strcat('RESULTS/',strcat(fileNameToWrite(1:end-4),'_EVAL.jpg')), 'quality', 100)
