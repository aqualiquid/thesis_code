% Pleaes run this code after 'maskstack.m'
clc;
close all;
clear;

final_path_FileList ='../../0102NISSLDATA_RESIZED50p/resized_nissl/*.jpg';
FinalPath = '../../0102NISSLDATA_RESIZED50p/resized_nissl/';
FileList = dir(final_path_FileList);
% number of FileList
N = size(FileList,1);

proc_pathList ='../../test_data_1202/test_final_processed_10px/all_files/all/b-l_result/*.bmp';
proc_path = '../../test_data_1202/test_final_processed_10px/all_files/all/b-l_result/';
% Create FileList
procFileList = dir(proc_pathList);
N = size(procFileList,1);

mask_pathList ='../../test_data_1202/stackmask_l/*.bmp';
mask_path = '../../test_data_1202/stackmask_l/';
maskFileList = dir(mask_pathList);
% number of FileList
maskN = size(maskFileList,1);


sigma_enhancement=10;
tic;
parfor iStart = 1:N;  
    current_slice = load_slice(procFileList, proc_path, iStart);
    mask_slice = load_slice(maskFileList, mask_path, iStart);
  
    current_slice(mask_slice~=0)=0;
    
    denoisedpath = '../../test_data_1202/stackmask_proc_l/denoised/';
    
    changedPath = strcat(denoisedpath, int2str(iStart), '.bmp');
    imwrite(current_slice, changedPath);
end
