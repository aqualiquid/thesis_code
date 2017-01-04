function [] = concat_img(path_FileList_A,path_A,path_FileList_B, path_B, savedpath, option)
% 
% savedpath = '../../test_data_1202/test_final_processed_10px/all_files/all/cat_left/';
% 
% path_FileList_A = '../../test_data_1202/test_final_processed_10px/all_files/all/postproc/t-l_procnew/*.bmp';
% % path_A = '../../test_data_1202/test_final_processed_10px/all_files/all/cat_left/';
% path_A = '../../test_data_1202/test_final_processed_10px/all_files/all/postproc/t-l_procnew/';
FileList_A = dir(path_FileList_A);
N_A = size(FileList_A,1);
% 
% path_FileList_B ='../../test_data_1202/test_final_processed_10px/all_files/all/postproc/b-l_procnew/*.bmp';
% % path_B = '../../test_data_1202/test_final_processed_10px/all_files/all/cat_right/';
% path_B = '../../test_data_1202/test_final_processed_10px/all_files/all/postproc/b-l_procnew/';
FileList_B = dir(path_FileList_B);
N_B = size(FileList_B,1);

sortedFileName_A = sort_nat({FileList_A.name}');
sortedFileName_B = sort_nat({FileList_B.name}');
ext = '.png';

parfor iStart = 1:N_A 
    filename_A = char(sortedFileName_A(iStart)); %(k).name;
    fullpath_A = strcat(path_A, filename_A);
    [pathstr_A,name_A,ext_A] = fileparts(fullpath_A); 
    imgA = imread(fullpath_A);
    
    filename_B = char(sortedFileName_B(iStart)); %(k).name;
    fullpath_B = strcat(path_B, filename_B);
    [pathstr_B,name_B,ext_B] = fileparts(fullpath_B); 
    imgB = imread(fullpath_B);
    
    % swtiching cat(1)-> vertical (2) -> landscape)
    cat_img = cat(option, imgA, imgB);
   
    if (strcmp(name_A,name_B)==1)
        % extract file name and write it
        num=str2double(regexp(FileList_A(iStart).name,['\d*'],'match'));
        changedPath = strcat(savedpath, num2str(num), '_cat', ext);
        imwrite(cat_img, changedPath);
    else
        fprintf(1,'[DIFFERENT SPOTTED] Part A is %s, and Part B %s is %s. \n', name_A, name_B);
    end
    
end
%         changedPath = strcat(fullpath,slice_idx,'.png');
%         imwrite(uint8(w_correction), changedPath{1});

end