clear;
close all; clc;
% numbering = '4900to5300';
for i = 1:1
%     if i==1
        start_num = 6900; step_size   = 300;
%     else
%         start_num = 4500+ i*400; step_size = 400;
%     end
    end_num     = start_num + step_size;
    numbering=strcat(num2str(start_num), 'to', num2str(end_num));
    basedpath = ['..' filesep '0102NISSLDATA_RESIZED50P' filesep numbering filesep];
    png_ext= '*.png';
    
    mkdir(basedpath, strcat('resize_','cat_left_test' ,numbering, filesep));
    mkdir(basedpath, strcat('resize_','cat_right_test',numbering, filesep));
    mkdir(basedpath, strcat('resize_','cat_all_test'  ,numbering, filesep));
    
    left_savedpath  = strcat(basedpath, strcat('resize_','cat_left_test' ,numbering, filesep));
    right_savedpath = strcat(basedpath, strcat('resize_','cat_right_test',numbering, filesep));
    all_savedpath   = strcat(basedpath, strcat('resize_','cat_all_test'  ,numbering, filesep));
    
    
    t_l_path_FileList_A = strcat(basedpath, strcat('resize_TL_',numbering, filesep, png_ext));
    t_l_path_A          = strcat(basedpath, strcat('resize_TL_',numbering, filesep));
    b_l_path_FileList_B = strcat(basedpath, strcat('resize_BL_',numbering, filesep, png_ext));
    b_l_path_B          = strcat(basedpath, strcat('resize_BL_',numbering, filesep));
    
    t_r_path_FileList_A = strcat(basedpath, strcat('resize_TR_',numbering, filesep, png_ext));
    t_r_path_A          = strcat(basedpath, strcat('resize_TR_',numbering, filesep));
    b_r_path_FileList_B = strcat(basedpath, strcat('resize_BR_',numbering, filesep, png_ext));
    b_r_path_B          = strcat(basedpath, strcat('resize_BR_',numbering, filesep));
    
    left_path_FileList_A    = strcat(left_savedpath, png_ext);
    right_path_FileList_B   = strcat(right_savedpath, png_ext);
    
    % concatenation (left side)
    concat_img(t_l_path_FileList_A,t_l_path_A, b_l_path_FileList_B, b_l_path_B,left_savedpath, 1); % 1 is vertical
    concat_img(t_r_path_FileList_A,t_r_path_A, b_r_path_FileList_B, b_r_path_B,right_savedpath, 1); % 1 is vertical
    concat_img(left_path_FileList_A,left_savedpath, right_path_FileList_B, right_savedpath,all_savedpath, 2); % 2 is landscape
end

