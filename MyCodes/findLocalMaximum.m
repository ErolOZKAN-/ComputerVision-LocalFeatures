%NOT USED
function [row,col,max_local] = findLocalMaximum(val,radius)
    % Determine the local maximum of a given value
    %
    % Author :: Vincent Garcia
    % Date   :: 09/02/2007
    %
    % INPUT
    % =====
    % val    : the NxM matrix containing values
    % radius : the radius of the neighborhood
    %
    % OUTPUT
    % ======
    % row       : the row position of the local maxima
    % col       : the column position of the local maxima
    % max_local	: the NxM matrix containing values of val on unique local maximum
    %
    % EXAMPLE
    % =======
    % [l,c,m] = findLocalMaximum(img,radius);
    



    % FIND LOCAL MAXIMA BY DILATION (FAST) /!\ NON UNIQUE /!\
    % mask = fspecial('disk',radius)>0;
    % val2 = imdilate(val,mask);
    % index = val==val2;
    % [row,col] = find(index==1);
    % max_local = zeros(size(val));
    % max_local(index) = val(index);


    % FIND UNIQUE LOCAL MAXIMA USING FILTERING (FAST)
    mask  = fspecial('disk',radius)>0;
    nb    = sum(mask(:));
    highest          = ordfilt2(val, nb, mask);
    second_highest   = ordfilt2(val, nb-1, mask);
    index            = highest==val & highest~=second_highest;
    max_local        = zeros(size(val));
    max_local(index) = val(index);
    [row,col]        = find(index==1);


    % FIND UNIQUE LOCAL MAXIMA (FAST)
    % val_height  = size(val,1);
    % val_width   = size(val,2);
    % max_local   = zeros(val_height,val_width);
    % val_enlarge = zeros(val_height+2*radius,val_width+2*radius);
    % val_mask    = zeros(val_height+2*radius,val_width+2*radius);
    % val_enlarge( (1:val_height)+radius , (1:val_width)+radius ) = val;
    % val_mask(    (1:val_height)+radius , (1:val_width)+radius ) = 1;
    % mask  = fspecial('disk',radius)>0;
    % row = zeros(val_height*val_width,1);
    % col = zeros(val_height*val_width,1);
    % index = 0;
    % for l = 1:val_height
    %     for c = 1:val_width
    %         val_ref = val(l,c);
    %         neigh_val  = val_enlarge(l:l+2*radius,c:c+2*radius);
    %         neigh_mask = val_mask(   l:l+2*radius,c:c+2*radius).*mask;
    %         neigh_sort = sort(neigh_val(neigh_mask==1));
    %         if val_ref==neigh_sort(end) && val_ref>neigh_sort(end-1)
    %             index          = index+1;
    %             row(index,1)   = l;
    %             col(index,1)   = c;
    %             max_local(l,c) = val_ref;
    %         end
    %     end
    % end
    % row(index+1:end,:) = [];
    % col(index+1:end,:) = [];


end