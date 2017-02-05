%NOT USED
%this software computes the keypoints in SIFT algorithm and save the rsult
%in extrema variable
% I--> the input image should be a color(rgb) image
function exterma=key_points(I)
I=imread('door.jpg');
I=double(rgb2gray(I));
I=I/max(max(I));  % image should be in [0 1]
[M,N,C] = size(I) ;

% Lowe's choices
S=3 ;
omin=-1 ; % first octave -1 mmeans I should be doublsized for first octave
O=floor(log2(min(M,N)))-omin-4 ; % Up to 16x16 images
% we can decrease the 1.6 for some images to reach better esults
sigma0=1.6*2^(1/S) ; % this sigma is for the image in real size
% and 1.6 is for doublsized image in first octave
sigman=0.5 ;% antialiasing filter sigma
thresh = 0.006;% it was .03 in Lowe's paper ,we changed it to .006 here
r = 10 ;


%calculate Guassian images in different scales and octave
GS = gaussianss(I,O,S,omin,-1,S+1,sigma0) ;
%*************************************************************
%calculate DOG images
for o=1:GS.O %all the octaves
  [M,N,SS] = size(GS.octave{o}) ;
  DOG.octave{o} = zeros(M,N,SS-1) ;
  for s=1:SS-1
    DOG.octave{o}(:,:,s) = ...
        GS.octave{o}(:,:,s+1) - GS.octave{o}(:,:,s) ;
  end
end
%********************************************************
%******** imshow DOG images  you can comment this*******
% for o=1:GS.O %all the octaves
%   for s=1:SS-1
%     imshow(DOG.octave{o}(:,:,s),[])
%     pause(1)
%         
%   end
% end
%*************************************************************

%finding key points
exterma=zeros(2,1);
for o=1:GS.O
    for s=2:SS-2
        sig=1.6*2^(o-1)*(2^(1/S))^s;
        current_DOG=DOG.octave{o}(:,:,s);
        down_DOG=DOG.octave{o}(:,:,s-1);
        up_DOG=DOG.octave{o}(:,:,s+1);
 	    extr = search_exterm(up_DOG,down_DOG,current_DOG  ) ;%find exremum
       if extr(1,1)
        %accurate localization to subpixel and eliminate some unsuitable
        %points
        extr=localize_eliminate(extr,up_DOG,down_DOG,current_DOG ,thresh,r);
        if extr(1,1)
        extr=2^(o-1+GS.omin) *extr; %stor key points
        exterma=[exterma extr];

        
        end
       end
    
    end
    
end

imshow(I,[])
hold on
plot(exterma(2,:),exterma(1,:),'r+','LineWidth',2)
end

%**************************************************************************
function SS = gaussianss(I,O,S,omin,smin,smax,sigma0)
%smax--> maximum scale(here it is 4)
%smin--> minimum scale(here is -1...image shold  be double sized)
%omin--> first octave(here is -1)
%1.6 as sigma0 is considered for omin=-1


% Scale multiplicative step
k = 2^(1/S) ;


dsigma0 = sigma0 * sqrt(1 - 1/k^2) ; % Scale step factor
sigman  = 0.5 ;                      % Nominal smoothing of the image

% Scale space structure
SS.O          = O ;
SS.S          = S ;
SS.sigma0     = sigma0 ;
SS.omin       = omin ;
SS.smin       = smin ;
SS.smax       = smax ;

% If mino < 0, multiply the size of the image.
% (The rest of the code is consistent with this.)
if omin < 0
	for o=1:-omin
		I = doubleSize(I) ;
	end
elseif omin > 0
	for o=1:omin
		I = halveSize(I) ;
	end
end

[M,N] = size(I) ;

% Index offset
so = -smin+1 ;

% --------------------------------------------------------------------
%                                                         First octave
% --------------------------------------------------------------------
%
% The first level of the first octave has scale index (o,s) =
% (omin,smin) and scale coordinate
%
%    sigma(omin,smin) = sigma0 2^omin k^smin 
%
% The input image I is at nominal scale sigman. Thus in order to get
% the first level of the pyramid we need to apply a smoothing of
%  
%   sqrt( (sigma0 2^omin k^smin)^2 - sigman^2 ).
%
% As we have pre-scaled the image omin octaves (up or down,
% depending on the sign of omin), we need to correct this value
% by dividing by 2^omin, getting
%e
%   sqrt( (sigma0 k^smin)^2 - (sigman/2^omin)^2 )
%

if(sigma0 * 2^omin * k^smin < sigman)
	warning('The nominal smoothing exceeds the lowest level of the scale space.') ;
end

SS.octave{1} = zeros(M,N,smax-smin+1) ;% we have 6 scale in each octave
SS.octave{1}(:,:,1)  = gauss_filter(I,sqrt((sigma0*k^smin)^2 ...
    - (sigman/2^omin)^2));
%HOSSEIN   imsmooth(I, ...
	%sqrt((sigma0*k^smin)^2  - (sigman/2^omin)^2)) ;% sigman and sigma0 applyed simutnously
    %Not that sigma0 for first octave(double sized image state) is
    %1.6-->1.6*k*k^smin and smin=-1
for s=smin+1:smax
	% Here we go from (omin,s-1) to (omin,s). The extra smoothing
	% standard deviation is
	%
	%  (sigma0 2^omin 2^(s/S) )^2 - (simga0 2^omin 2^(s/S-1/S) )^2
	%
	% Aftred dividing by 2^omin (to take into account the fact
  % that the image has been pre-scaled omin octaves), the 
  % standard deviation of the smoothing kernel is
  %
	%   dsigma = sigma0 k^s sqrt(1-1/k^2)
  %
	dsigma = k^s * dsigma0 ;% smooth Image in prevous scale and just use dsigma
	SS.octave{1}(:,:,s +so) =gauss_filter...
        (squeeze(SS.octave{1}(:,:,s-1 +so)), dsigma);
	%HOSSEIN	imsmooth(squeeze(SS.octave{1}(:,:,s-1 +so)), dsigma )  ;
end


% --------------------------------------------------------------------
%                                                        Other octaves
% --------------------------------------------------------------------

for o=2:O  
	% We need to initialize the first level of octave (o,smin) from
	% the closest possible level of the previous octave. A level (o,s)
  % in this octave corrsponds to the level (o-1,s+S) in the previous
  % octave. In particular, the level (o,smin) correspnds to
  % (o-1,smin+S). However (o-1,smin+S) might not be among the levels
  % (o-1,smin), ..., (o-1,smax) that we have previously computed.
  % The closest pick is
  %
	%                       /  smin+S    if smin+S <= smax % for me it is
	%                       statisfied all the time
	% (o-1,sbest) , sbest = |
	%                       \  smax      if smin+S > smax
	%
	% The amount of extra smoothing we need to apply is then given by
	%
	%  ( sigma0 2^o 2^(smin/S) )^2 - ( sigma0 2^o 2^(sbest/S - 1) )^2
	%
  % As usual, we divide by 2^o to cancel out the effect of the
  % downsampling and we get
  %
	%  ( sigma 0 k^smin )^2 - ( sigma0 2^o k^(sbest - S) )^2
  %
	sbest = min(smin + S, smax) ;
	TMP = halveSize(squeeze(SS.octave{o-1}(:,:,sbest+so))) ;
	target_sigma = sigma0 * k^smin ;
	  prev_sigma = sigma0 * k^(sbest - S) ;
            
	if (target_sigma > prev_sigma)
          TMP =gauss_filter(TMP, sqrt(target_sigma^2 - prev_sigma^2));                            
    end
    
    
	[M,N] = size(TMP) ;
	
	SS.octave{o} = zeros(M,N,smax-smin+1) ;
	SS.octave{o}(:,:,1) = TMP ;

	for s=smin+1:smax
		% The other levels are determined as above for the first octave.		
		dsigma = k^s * dsigma0 ;
		SS.octave{o}(:,:,s +so) =gauss_filter(squeeze(SS.octave{o}...
            (:,:,s-1 +so)), dsigma);
	end
	
end
end

% -------------------------------------------------------------------------
%                                                       Auxiliary functions
% -------------------------------------------------------------------------
function J = doubleSize(I)
[M,N]=size(I) ;
J = zeros(2*M,2*N) ;
J(1:2:end,1:2:end) = I ;
J(2:2:end-1,2:2:end-1) = ...
	0.25*I(1:end-1,1:end-1) + ...
	0.25*I(2:end,1:end-1) + ...
	0.25*I(1:end-1,2:end) + ...
	0.25*I(2:end,2:end) ;
J(2:2:end-1,1:2:end) = ...
	0.5*I(1:end-1,:) + ...
    0.5*I(2:end,:) ;
J(1:2:end,2:2:end-1) = ...
	0.5*I(:,1:end-1) + ...
    0.5*I(:,2:end) ;
end

function J = halveSize(I)
J=I(1:2:end,1:2:end) ;
end
%*************************************************************************

%**************************************************************************
function im=gauss_filter(image,sigma)
G = fspecial('gaussian',[5 5],sigma);
im=imfilter(image,G,'same');
end
%**************************************************************************

%**************************************************************************
function [points2]=localize_eliminate(points,up,down,curr,thr,r)
points2=zeros(2,1);
t=1;
for i=1:size(points,2)
    x=points(1,i);
    y=points(2,i);
    fxx= curr(x-1,y)+curr(x+1,y)-2*curr(x,y);   % double derivate in x direction
    fyy= curr(x,y-1)+curr(x,y+1)-2*curr(x,y);   % double derivate in y direction
    fsigmasigma=up(x,y)+down(x,y)-2*curr(x,y);   % double derivate in sigma direction
    
    
    fxsigma=((up(x+1,y)-down(x+1,y))-(up(x-1,y)-down(x-1,y)))/4;%derivate in x and sigma direction
    fysigma=((up(x,y+1)-down(x,y+1))-(up(x,y-1)-down(x,y-1)))/4;%derivate in y and sigma direction
    fxy= curr(x-1,y-1)+curr(x+1,y+1)-curr(x-1,y+1)-curr(x+1,y-1); %derivate inx and y direction
    
    fx=curr(x,y)-curr(x-1,y);%derivate in x direction
    fy=curr(x,y)-curr(x,y-1);%derivate in y direction
    fsigma=(up(x,y)-down(x,y))/2;%derivate in sigma direction
    
    %localization using Teilor seri
    A=[fsigmasigma fxsigma fysigma;fxsigma fxx fxy;fysigma fxy fyy];
    X=-inv(A)*([fsigma fx fy]');
    
    
    x_hat=X(2);
    y_hat=X(3);
    if abs(x_hat)<4 && abs(y_hat)<4 %ignor the ofsets > 4
       px=round(x+x_hat);
       py=round(y+y_hat);
    else
        px=x;
        py=y;
        %[px py]
    end
    
    
    
    D_hat=curr(px,py)+([fsigma fx fy]*X)/2;
    if abs(D_hat)>thr%% filter some low contrast points
        if (fxx+fyy)^2/(fxx*fyy-fxy^2)<(r+1)^2/r % remove edge points
            points2(1,t)=px;points2(2,t)=py;
            t=t+1;
        end
    end
    
    
end
               
end
%**************************************************************************

%**************************************************************************
function indx=search_exterm(up,down,im)
[m n]=size(im);
t=1;
thr=.004;
indx=[0;0];

    for i=2:m-1
        for j=2:n-1
            
        if im(i,j)> thr 
        window(1:3,1:3)=down(i-1:i+1,j-1:j+1);
        window(4:6,1:3)=im(i-1:i+1,j-1:j+1);
        window(7:9,1:3)=up(i-1:i+1,j-1:j+1);
        window(5,2)=-100;
        if im(i,j)>max(max(window))
            indx(:,t)=[i j]';
            t=t+1;
        end
        end
        
        if  im(i,j)<-thr
        window(1:3,1:3)=down(i-1:i+1,j-1:j+1);
        window(4:6,1:3)=im(i-1:i+1,j-1:j+1);
        window(7:9,1:3)=up(i-1:i+1,j-1:j+1);
        window(5,2)=100;
        if im(i,j)<min(min(window))
            indx(:,t)=[i j]';
            t=t+1;
        end
        end
        end
        
    end

end
%**************************************************************************
