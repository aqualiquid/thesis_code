clear; 
close all; clc;
numbering = '5700to6100';
basedpath = ['..' filesep '0102NISSLDATA_RESIZED50P' filesep numbering filesep];
% basedpath = strcat('/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/', numbering);
png_ext= '*.png';

mkdir(basedpath, strcat('cat_left_test' ,numbering, filesep));
mkdir(basedpath, strcat('cat_right_test',numbering, filesep));
mkdir(basedpath, strcat('cat_all_test'  ,numbering, filesep));

% mkdir(basedpath, strcat('resize_','cat_left_test' ,numbering, filesep));
% mkdir(basedpath, strcat('resize_','cat_right_test',numbering, filesep));
% mkdir(basedpath, strcat('resize_','cat_all_test'  ,numbering, filesep));

% left_savedpath  = strcat(basedpath, strcat('resize_','cat_left_test' ,numbering, filesep));
% right_savedpath = strcat(basedpath, strcat('resize_','cat_right_test',numbering, filesep));
% all_savedpath   = strcat(basedpath, strcat('resize_','cat_all_test'  ,numbering, filesep));
% 
left_savedpath  = strcat(basedpath, strcat('cat_left_test' ,numbering, filesep));
right_savedpath = strcat(basedpath, strcat('cat_right_test',numbering, filesep));
all_savedpath   = strcat(basedpath, strcat('cat_all_test'  ,numbering, filesep));


t_l_path_FileList_A = strcat(basedpath, strcat('TL_postproc_',numbering, filesep, png_ext));
t_l_path_A          = strcat(basedpath, strcat('TL_postproc_',numbering, filesep));
b_l_path_FileList_B = strcat(basedpath, strcat('BL_postproc_',numbering, filesep, png_ext));
b_l_path_B          = strcat(basedpath, strcat('BL_postproc_',numbering, filesep));

t_r_path_FileList_A = strcat(basedpath, strcat('TR_postproc_',numbering, filesep, png_ext));
t_r_path_A          = strcat(basedpath, strcat('TR_postproc_',numbering, filesep));
b_r_path_FileList_B = strcat(basedpath, strcat('BR_postproc_',numbering, filesep, png_ext));
b_r_path_B          = strcat(basedpath, strcat('BR_postproc_',numbering, filesep));

% t_l_path_FileList_A = strcat(basedpath, strcat('resize_TL_',numbering, filesep, png_ext));
% t_l_path_A          = strcat(basedpath, strcat('resize_TL_',numbering, filesep));
% b_l_path_FileList_B = strcat(basedpath, strcat('resize_BL_',numbering, filesep, png_ext));
% b_l_path_B          = strcat(basedpath, strcat('resize_BL_',numbering, filesep));
% 
% t_r_path_FileList_A = strcat(basedpath, strcat('resize_TR_',numbering, filesep, png_ext));
% t_r_path_A          = strcat(basedpath, strcat('resize_TR_',numbering, filesep));
% b_r_path_FileList_B = strcat(basedpath, strcat('resize_BR_',numbering, filesep, png_ext));
% b_r_path_B          = strcat(basedpath, strcat('resize_BR_',numbering, filesep));

left_path_FileList_A    = strcat(left_savedpath, png_ext);
right_path_FileList_B   = strcat(right_savedpath, png_ext);

% concatenation (left side)
concat_img(t_l_path_FileList_A,t_l_path_A, b_l_path_FileList_B, b_l_path_B,left_savedpath, 1); % 1 is vertical
concat_img(t_r_path_FileList_A,t_r_path_A, b_r_path_FileList_B, b_r_path_B,right_savedpath, 1); % 1 is vertical
concat_img(left_path_FileList_A,left_savedpath, right_path_FileList_B, right_savedpath,all_savedpath, 2); % 2 is landscape





% left_savedpath = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/cat_left_4900to5300/';
% right_savedpath = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/cat_right_4900to5300/';
% all_savedpath = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/cat_all_4900to5300/';

% t_l_path_FileList_A = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/TL_postproc_4900to5300/*.png';
% t_l_path_A = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/TL_postproc_4900to5300/';
% b_l_path_FileList_B ='/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/BL_postproc_4900to5300/*.png';
% b_l_path_B = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/BL_postproc_4900to5300/';

% t_r_path_FileList_A = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/TR_postproc_4900to5300/*.png';
% t_r_path_A = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/TR_postproc_4900to5300/';
% b_r_path_FileList_B = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/BR_postproc_4900to5300/*.png';
% b_r_path_B = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/BR_postproc_4900to5300/';

% left_path_FileList_A = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/cat_left_4900to5300/*.png';
% right_path_FileList_B = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/4900to5300/cat_right_4900to5300/*.png';

