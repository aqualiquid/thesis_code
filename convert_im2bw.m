clc; close all; clear; 
png_ext= '*.png';
basedpath='/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/';
FilePath = strcat(basedpath, 'cat_all/');
FileList = dir(strcat(FilePath, '*.png'));
% number of FileList
N = size(FileList,1);


parfor i=1:N
    [current_slice idx] = load_slice(FileList, FilePath, i);
    strpath = strcat(basedpath, 'cat_all_im2bw/');
    bwimg = im2bw(current_slice);
    bwimg_path = strcat(strpath, idx, '.png');
    imwrite(bwimg, bwimg_path{1});
end
