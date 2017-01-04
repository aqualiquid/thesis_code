function [final_img] =processing_noise(corrected)
    % Assining offset for max entropie
    offset = 30;
    
    % anisotropic diffusion
    num_iter = 5;   % default 15 (the most affective factor)
    delta_t = 1/7;  % default 1/7 (Not recommend to manipulate the 'delta'
    kappa = 7;     % default 30 :A low value of ? results in little diffusion anywhere in the image and a high value of ? results in linear diffusion.
    option = 1;     % prefer to option 1 
    
    med_img= medfilt2(corrected);
    med_img= denoised_cornerPX(med_img);

    % Call Anisropic Diffusion function (2-D)
%     med_img=gpuArray(uint8(med_img));
    ad_img = anisodiff2D(med_img,num_iter,delta_t,kappa,option);
    clear med_img; 
    
    % NEWLY ADDED
    ad_img = DoG_enhancement(ad_img);
    meanval = mean2(ad_img);
    thrsh = meanval + offset;  
    I1 = zeros(size(ad_img));
    I1(ad_img<(abs(thrsh))) = 0;
    I1(ad_img>((thrsh))) = 255;    
    
    corrected(I1==0)=0;
    final_img = corrected;
 

% % %     delta = 0.5;
% % %     [f,xi] = ksdensity(ad_img(:));
% % %     val = 1000.*f;                 % normalizing y-axis values
% % %     % xi represents y-axis value
% % %     [maxtab, mintab]=peakdet(val, delta, xi);
% % %     x_range= abs(max(ad_img(:)))+abs(min(ad_img(:)));
% % %     % find index of most frequent number in history
% % %     [freq x_ind] =max(maxtab(:,2));
% % %     pos_val = maxtab(x_ind,1);
% % %     THRESHOLD_DoG =std2(ad_img)*4 + pos_val;
% % %     final_img(final_img<THRESHOLD_DoG) = 0;
% % %     disp('');  
end
