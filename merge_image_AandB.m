clc; clear; close all;
changedPath = 'C:\Users\babies\Desktop\MERGED\';

str_A ='C:\Users\babies\Desktop\MERGE\'; str_A_png =strcat(str_A, filesep, '*.png');
FileList_A = dir(str_A_png);
numArray_raw =[];
for i=1:size(FileList_A,1)
    num=str2double(regexp(FileList_A(i).name,['\d*'],'match'));
%     init_num = str2double(regexp(FileList(1).name,['\d*'],'match'));
    numArray_raw(i) =  num ;
end
numArray_raw=sort(numArray_raw);

str_B='D:\research\0102NISSLDATA_RESIZED50P\100to400\W_preproc_100to400\';str_B_png =strcat(str_B, filesep, '*.png');
FileList_B = dir(str_B_png);
numArray =[];
for i=1:size(FileList_B,1)
    numArray(i) = str2double(regexp(FileList_B(i).name,['\d*'],'match'));
end
numArray=sort(numArray);

isSetDiff=any(setdiff(numArray, numArray_raw));


if isSetDiff ==0 
    for i =1:size(FileList_A,1)
        if i<73
            prevA = imread(strcat(str_A,'0',num2str(numArray_raw(i)), '.png'));
            prevB = imread(strcat(str_B,'0',num2str(numArray(i)), '.png'));
            maxed = max(prevA, prevB);
            imwrite(uint8(maxed),strcat(changedPath,'0',num2str(numArray(i)), '.png') );
        else
            prevA = imread(strcat(str_A,num2str(numArray_raw(i)), '.png'));
            prevB = imread(strcat(str_B,num2str(numArray(i)), '.png'));
            maxed = max(prevA, prevB);
            imwrite(uint8(maxed),strcat(changedPath,num2str(numArray(i)), '.png') );
        end
    end
end
