clc; close all;clear;

% 'i' should be incremented by 100 images. 
for i=1:10
    if i==1
        start_num = 3700; step_size   = 300;
    else
        start_num = 3700+ (i-1)*300; step_size = 300;
    end
    
    end_num     = start_num + step_size;
    numbering=strcat(num2str(start_num), 'to', num2str(end_num));
    basedpath   = ['..' filesep '0402RAT' filesep];
    png_ext     = '*.png';
      
    % %% Directing a path to each path variables
    W_path_FileList= strcat(basedpath, numbering,filesep,'W_',numbering, filesep, png_ext);
    W_path= strcat(basedpath, numbering,filesep,'W_',numbering, filesep);
    W_fullpath= strcat(basedpath, numbering,filesep,'W_preproc_',numbering, filesep);
    W_post_FileList = strcat(basedpath, numbering,filesep,'W_preproc_',numbering, filesep, png_ext);
    W_strPath = strcat(basedpath, numbering,filesep,'W_postproc_',numbering, filesep);
    

    % % % % % Resizing (only for resizing), origin to 25%  e.g.) (580,358,98)
    W_post_resize_FileList = strcat(basedpath, numbering,filesep,'W_postproc_',numbering,filesep, png_ext);
    str_W_resize=strcat(basedpath,numbering,filesep,'resize_W_',numbering, filesep); 
    str_W_preproc_resize=strcat(basedpath,numbering,filesep,'preproc_resize_W_',numbering, filesep); 
    mkdir(basedpath, strcat(numbering,filesep,'resize_W_',numbering, filesep));

    
    % % make folder
    mkdir(basedpath, strcat(numbering,filesep,'W_preproc_',numbering, filesep));
    mkdir(basedpath, strcat(numbering,filesep,'W_postproc_',numbering, filesep));
    mkdir(basedpath, strcat(numbering,filesep,'preproc_resize_W_',numbering, filesep));
    
    % % Run Preprocessing (segmentation step)
    batchprocessing_segmentation(W_path_FileList,W_path,W_fullpath);
    
    % % Run Postprocessing (Noise removal in 3D context)
    batchprocessing_postprocessing(W_post_FileList,W_fullpath,W_strPath, W_path_FileList,W_path);
    batchprocessing_postprocessing_rat(W_post_FileList,W_fullpath,W_strPath, W_path_FileList,W_path);
 
    % % Resizing
    batchprocessing_resizing(W_post_resize_FileList,W_strPath,str_W_resize, numbering, 0.25);
    clearvars -except i;
end
