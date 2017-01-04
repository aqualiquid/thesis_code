% myCluster = parcluster('local');
% myCluster.NumWorkers = 8; % 'Modified' property now TRUE
% saveProfile(myCluster);
% Batch processing for preprocessing and postprocessing
clc; close all;clear;



start_num = 7300; step_size   = 300;
end_num     = start_num + step_size;
numbering=strcat(num2str(start_num), 'to', num2str(end_num));
basedpath   = ['..' filesep '0102NISSLDATA_RESIZED50P' filesep];
% basedpath   = ['..' filesep '0305img25p4step' filesep];
png_ext     = '*.png';


% %% Directing a path to each path variables
TL_path_FileList= strcat(basedpath, numbering,filesep,'TL_',numbering, filesep, png_ext);
TL_path= strcat(basedpath, numbering,filesep,'TL_',numbering, filesep);
TL_fullpath= strcat(basedpath, numbering,filesep,'TL_preproc_',numbering, filesep);
TL_post_FileList = strcat(basedpath, numbering,filesep,'TL_preproc_',numbering, filesep, png_ext);
TL_strPath = strcat(basedpath, numbering,filesep,'TL_postproc_',numbering, filesep);

BL_path_FileList= strcat(basedpath, numbering,filesep,'BL_',numbering, filesep, png_ext);
BL_path= strcat(basedpath, numbering,filesep,'BL_',numbering, filesep);
BL_fullpath= strcat(basedpath, numbering,filesep,'BL_preproc_',numbering, filesep);
BL_post_FileList = strcat(basedpath, numbering,filesep,'BL_preproc_',numbering, filesep, png_ext);
BL_strPath = strcat(basedpath, numbering,filesep,'BL_postproc_',numbering, filesep);
%
TR_path_FileList= strcat(basedpath, numbering,filesep,'TR_',numbering, filesep, png_ext);
TR_path= strcat(basedpath, numbering,filesep,'TR_',numbering, filesep);
TR_fullpath= strcat(basedpath, numbering,filesep,'TR_preproc_',numbering, filesep);
TR_post_FileList = strcat(basedpath, numbering,filesep,'TR_preproc_',numbering,filesep, png_ext);
TR_strPath = strcat(basedpath, numbering,filesep,'TR_postproc_',numbering, filesep);

BR_path_FileList= strcat(basedpath, numbering,filesep,'BR_',numbering, filesep, png_ext);
BR_path= strcat(basedpath, numbering,filesep,'BR_',numbering, filesep);
BR_fullpath= strcat(basedpath, numbering,filesep,'BR_preproc_',numbering, filesep);
BR_post_FileList = strcat(basedpath, numbering,filesep,'BR_preproc_',numbering, filesep, png_ext);
BR_strPath = strcat(basedpath, numbering,filesep,'BR_postproc_',numbering, filesep);


% % % % % Resizing (only for resizing command), origin to 25%  e.g.) (580,358,98)
TL_post_resize_FileList = strcat(basedpath, numbering,filesep,'TL_postproc_',numbering,filesep, png_ext);
TR_post_resize_FileList = strcat(basedpath, numbering,filesep,'TR_postproc_',numbering,filesep, png_ext);
BL_post_resize_FileList = strcat(basedpath, numbering,filesep,'BL_postproc_',numbering,filesep, png_ext);
BR_post_resize_FileList = strcat(basedpath, numbering,filesep,'BR_postproc_',numbering,filesep, png_ext);
str_TL_resize=strcat(basedpath,numbering,filesep,'resize_TL_',numbering, filesep);
str_TR_resize=strcat(basedpath,numbering,filesep,'resize_TR_',numbering, filesep);
str_BL_resize=strcat(basedpath,numbering,filesep,'resize_BL_',numbering, filesep);
str_BR_resize=strcat(basedpath,numbering,filesep,'resize_BR_',numbering, filesep);

mkdir(basedpath, strcat(numbering,filesep,'resize_TL_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'resize_TR_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'resize_BL_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'resize_BR_',numbering, filesep));


% % make folder
mkdir(basedpath, strcat(numbering,filesep,'TL_preproc_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'TR_preproc_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'BL_preproc_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'BR_preproc_',numbering, filesep));

mkdir(basedpath, strcat(numbering,filesep,'TL_postproc_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'TR_postproc_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'BL_postproc_',numbering, filesep));
mkdir(basedpath, strcat(numbering,filesep,'BR_postproc_',numbering, filesep));


% % % Run Preprocessing (segmentation step)
% batchprocessing_segmentation(TL_path_FileList,TL_path,TL_fullpath);
% batchprocessing_segmentation(BL_path_FileList,BL_path,BL_fullpath);
% batchprocessing_segmentation_empty(TR_path_FileList,TR_path,TR_fullpath);
% batchprocessing_resizing(TR_post_resize_FileList,TR_strPath,str_TR_resize, numbering, 0.25);
% batchprocessing_segmentation(BR_path_FileList,BR_path,BR_fullpath);

% % % % Run Postprocessing (Noise removal in 3D context)
% batchprocessing_postprocessing(TL_post_FileList,TL_fullpath,TL_strPath, TL_path_FileList,TL_path);
% batchprocessing_postprocessing(BL_post_FileList,BL_fullpath,BL_strPath, BL_path_FileList,BL_path);
% batchprocessing_postprocessing(TR_post_FileList,TR_fullpath,TR_strPath, TR_path_FileList,TR_path);
% batchprocessing_postprocessing(BR_post_FileList,BR_fullpath,BR_strPath, BR_path_FileList,BR_path);


%     % % % % Resizing
%     batchprocessing_resizing(TL_post_resize_FileList,TL_strPath,str_TL_resize, numbering, 0.25);
%     batchprocessing_resizing(TR_post_resize_FileList,TR_strPath,str_TR_resize, numbering, 0.25);
%     batchprocessing_resizing(BL_post_resize_FileList,BL_strPath,str_BL_resize, numbering, 0.25);
%     batchprocessing_resizing(BR_post_resize_FileList,BR_strPath,str_BR_resize, numbering, 0.25);
% %






