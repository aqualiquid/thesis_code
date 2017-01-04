clc;
close all;
clear;

% PLEASE define the following variables. 
THRESH_layer = 20;
SIZE_DISK = 80;

% [ path_FileList, path, fullpath, xlsfileTP, xlsfileFP ] = macFileList_1214();
path_FileList ='/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/5300to5700/BR_5300to5700/*.png';
path = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/5300to5700/BR_5300to5700/';

% Create FileList
FileList = dir(path_FileList);
N = size(FileList,1);

% set DoG threshold EMPIRICAL RESULT, VERY SENSATIVE and Important
sigma_enhancement=10;

tic;
parfor iStart = 1:N;  
    current_slice = load_slice(FileList, path, iStart);
    
    if std(current_slice(:))< 1.5 % below 2.5 is damaged image
        first_DoGed =zeros(size(current_slice,1));
        fprintf('no img in %d\n', iStart);   
    else

        Iblur = imgaussfilt(current_slice, 50);
        illum_corrected = 1 - ((1-current_slice)-(1-Iblur));

        % Normalize pixels between 0 and 255
        illum_corrected(:) = (illum_corrected - min(illum_corrected(:)))*255/(max(illum_corrected(:))...
            - min(illum_corrected(:)));

        
        illum_corrected = illumination_correction(mat2gray(illum_corrected), sigma_enhancement );   
        
        boxKernel = ones(50,50); % Or whatever size window you want.
        blurredImage = conv2(illum_corrected , boxKernel, 'same');        
        blurredImage(blurredImage>160) =255;
        blurredImage(blurredImage<255)=0;
        b = ~blurredImage;
        mask_blob = imdilate(b, strel('disk',SIZE_DISK));
    end
    stackfullpath = '../../test_data_1202/stackmask_l/';
    
    changedPath = strcat(stackfullpath, int2str(iStart), '.bmp');
%     figure(1), imshow(mask_blob,[]);
    imwrite(mask_blob, changedPath); % RECOVER THIS after you test the file !!!!!
end
% 
% 
% final_path_FileList ='../../test_data_1202/stackmask_l/*.bmp';
% FinalPath = '../../test_data_1202/stackmask_l/';
% FileList = dir(final_path_FileList);
% % number of FileList
% N = size(FileList,1);
% temp_image3D=gen_3Dslices( FileList, N, FinalPath );
% 
% 
% 
% 
% 
% % connected component segmentation from 3D volume
% CC = bwconncomp(temp_image3D);
% cc_stat = regionprops(CC, 'PixelList', 'BoundingBox', 'Area', 'PixelIdxList');
% 
% for i=1:size(cc_stat,1)
%     %validation 
%     if size(CC.PixelIdxList{i},1) == cc_stat(i).Area
%         % extracting max size of the layer
%         max_layer = max(cc_stat(i).PixelList(:,3));
%         % extracting min size of the layer
%         min_layer = min(cc_stat(i).PixelList(:,3));
%         diff_z = abs(max_layer-min_layer);
%         % if size of the CC is less than threshold, discard the CC
%         if diff_z < THRESH_layer 
%             temp_image3D(CC.PixelIdxList{i})=0;
%         end
%     else
%         fprintf(1,'Wrong array assignment in array number %d\n', i)
%     end
% end
% 
% 
% strPath = '../../test_data_1202/stackmask_proc_l/';
% for iStart=1:N % number 10 should be changed into 'td'
%    
%     current = temp_image3D(:,:,iStart);
%     current = im2double(current);
%     
%     changedPath = strcat(strPath, int2str(iStart), '.bmp');
%     imwrite(current, changedPath);
% end
% t=toc;disp(['elapse time: ', num2str(t)]);
