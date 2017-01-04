function [ adj_DoG_img ] = DoG_enhancement_removal(img)
    delta = 0.5;
    gray_scaled =(img);  %QEUSTION : Keep this?? or delete it???
    % Set Sigma value, if sigma1 is 1, which is lowest and sigma2 is 100,
    % which is highest, then 
    sigma1 = 1;
    sigma2 = 100;
    
    structingSize = size(img,1)/10;
    hsize =[structingSize,structingSize]; 

    h1 = fspecial('gaussian', hsize, sigma1);
    h2 = fspecial('gaussian', hsize, sigma2);

    gauss1 = imfilter(gray_scaled, h1, 'replicate');
    gauss2 = imfilter(gray_scaled, h2, 'replicate');
    dogImg = gauss1- gauss2;
    dogImg(:) = (dogImg - min(dogImg(:)))*255/(max(dogImg(:))...
            - min(dogImg(:)));
    copied_dogImg =dogImg;
       
    % the more denominator number
    [f,xi] = ksdensity(copied_dogImg(:));
    val = 10000.*f;                 % normalizing y-axis values
    % xi represents y-axis value
    [maxtab, mintab]=peakdet(val, delta, xi);
    x_range= abs(max(dogImg(:)))+abs(min(dogImg(:)));
    % find index of most frequent number in history
    [freq x_ind] =max(maxtab(:,2));
    pos_val = maxtab(x_ind,1);
    THRESHOLD_DoG =std2(copied_dogImg) + pos_val;
    dogImg(dogImg<THRESHOLD_DoG) = 0;
    adj_DoG_img =dogImg;
end
