function [ path_FileList, path, included_path, xlsfileTP, xlsfileFP  ] = macFileList(  )
%UNTITLED3 Summary of this function goes here

    % Directory and file list of where you want to retrieve files
    % path_FileList = '/Users/Robert/Desktop/test_data_0420/cropped_chattered/dline/*.png';
    path_FileList = '/Users/Robert/Desktop/test_data_0420/cropped_chattered/cropped_2/*.png';
    % Direcotry name; it should be same as the directory name of path_FileList
    path = '/Users/Robert/Desktop/test_data_0420/cropped_chattered/cropped_2/';
    % Directory path where you want to store the processed files
    included_path = '/Users/Robert/Desktop/test_data_0420/cropped_chattered/cropped_2_proc/';
    % Directory of xlsfiels
    xlsfileTP='/Users/Robert/Desktop/xls/JUL22/proc_JUL22_aft_enhancedTP.xlsx'
    xlsfileFP='/Users/Robert/Desktop/xls/JUL22/proc_JUL22_aft_enhancedFP.xlsx'
end

