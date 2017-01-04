clc;
close all; 
clear;

load('temp_image3D.mat');
current_slice = double(image3D(:,:,81));
Iblur = imgaussfilt(current_slice, 50);
illum_corrected = 1 - ((1-current_slice)-(1-Iblur));
% %         illum_corrected = illumination_correction(gpuArray(mat2gray(illum_corrected)), sigma_enhancement );   
illum_corrected = illumination_correction(mat2gray(illum_corrected), sigma_enhancement );   
% Normalize pixels between 0 and 255
illum_corrected(:) = (illum_corrected - min(illum_corrected(:)))*255/(max(illum_corrected(:))...
    - min(illum_corrected(:)));
med_img= medfilt2(illum_corrected); 
% Denosing BLACK/WHITE pixels on T-R, T-L, B-R, B-L
med_img= denoised_cornerPX(med_img);

% Call Anisropic Diffusion function (2-D)
ad_img = anisodiff2D(med_img,num_iter,delta_t,kappa,option);
img=ad_img;  %QEUSTION : Keep this?? or delete it???
gray_scaled=ad_img;
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
% %  maxed_blob100 = extended_maxed(dogImg,110);
% %  maxed_blob105 = extended_maxed(dogImg,105);
% %  maxed_blob1 = max(maxed_blob100, maxed_blob105);
 maxed_blob85 = extended_maxed(dogImg,80);
 maxed_blob95 = extended_maxed(dogImg,90);
 maxed_blob = max(maxed_blob85, maxed_blob95);
%  maxed_blob = max(maxed_blob1, maxed_blob2);

%  bw4 = bwareaopen(bw3, 300);
 shifted_img = meanShiftPixCluster(round(maxed_blob),3,15);
 proc_mThresh_img = processing_multi_threshold(shifted_img, 2);
 
 se = strel('disk',3);
 bwopening = imopen(proc_mThresh_img, se);
 bw4 = bwareaopen(bwopening, 300);
