function [  path_FileList, path, included_path, xlsfileTP, xlsfileFP ] = WinFileList(  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    % Directory and file list of where you want to retrieve files
    % path_FileList = '/Users/Robert/Desktop/test_data_0420/cropped_chattered/dline/*.png';
    path_FileList = '\\WOOS-MBP\Robert\Desktop\test_data_0420\cropped_chattered\cropped_2\*.png';
    % Direcotry name; it should be same as the directory name of path_FileList
    path = '\\WOOS-MBP\Robert\Desktop\test_data_0420\cropped_chattered\cropped_2\';
    % Direcory path where you want to store the processed files
    included_path = '\\WOOS-MBP\Robert\Desktop\test_data_0420\cropped_chattered\cropped_2_proc\';
    % Directory for xlsfiles
    xlsfileTP='\\WOOS-MBP\Robert\Desktop\xls\JUL22\proc_JUL22_aft_enhancedTP.xlsx'
    xlsfileFP='\\WOOS-MBP\Robert\Desktop\xls\JUL22\proc_JUL22_aft_enhancedFP.xlsx'
end

