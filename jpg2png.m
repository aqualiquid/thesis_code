
clc;
close all;
clear; 
sort_arry=[];
basedpath = '../../0102NISSLDATA_RESIZED50p/';
FinalPath = strcat(basedpath, 'contour/');
final_path_FileList = strcat(FinalPath, '*.jpg');
% FileList = dir(final_path_FileList);
FileList = dir(final_path_FileList);
N = size(FileList,1);

parfor i=1:N
    % extracting only files (not directory)
    if (FileList(i).isdir==0) && ~strcmpi(FileList(i).name, '.') ...
            && ~strcmpi(FileList(i).name, '..') && ~strcmpi(FileList(i).name, '.DS_Store')
        filename = char({FileList(i).name});
        
        current_addr= strcat(FinalPath,filename);
        current_img = imread(current_addr);
        new_mod_img = im2bw(otsu(mat2gray(current_img)),1);
        new_mod_img = mat2gray(new_mod_img);
        new_mod_img(new_mod_img>0)=255;
        out=regexp(filename,'\d+','match');
        sort_arry = [sort_arry; strcat(out,'.jpg')];
        
        changedPath = strcat(FinalPath, regexprep(filename,'.jpg',''), '.png');
        imwrite(uint8(new_mod_img), changedPath);
    end
    
end
