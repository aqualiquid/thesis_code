clc;
close all;
clear;

% Brief Algorithm for applying a mask to the raw images
% 1. extracting a number from the file name (contour)
% 2. validation step (if a file name is existed in the folder, apply the
% mask to the contour)
sort_arry=[];

% basedpath   = ['..' filesep '0102NISSLDATA_RESIZED50P' filesep 'contour_0318' filesep];
basedpath   = ['..' filesep '0402RAT' filesep 'contour_0406' filesep];
FileList = dir(basedpath);
% number of FileList
N = size(FileList,1);
fprintf(1,'number of mask %d \n', round(N));
for i=1:N
    % extracting only files (not directory)
    if (FileList(i).isdir==0) && ~strcmpi(FileList(i).name, '.') ...
            && ~strcmpi(FileList(i).name, '..') && ~strcmpi(FileList(i).name, '.DS_Store')
        filename = char({FileList(i).name});  
        out=regexp(filename,'\d+','match');
        sort_arry = [sort_arry; strcat(out,'.png')];
    end
    
end
% insert dummy element for preventing a mask error (mask_idx+1)
sort_arry = [sort_arry; strcat('9999999999999','.png')];

% strpath = '../../0102NISSLDATA_RESIZED50p/masked/';
strpath = [ '..' filesep '0402RAT' filesep 'masked_0406' filesep];

% rawtargetpathDIR =[ '..' filesep '0102NISSLDATA_RESIZED50P' filesep 'resized_nissl0315' filesep];
rawtargetpathDIR =[ '..' filesep '0402RAT' filesep 'resized_nissl0406' filesep];

% rawtargetpath = '../../0102NISSLDATA_RESIZED50p/resized_nissl/*.png';
rawtargetpath  =[ '..' filesep '0402RAT' filesep 'resized_nissl0406' filesep '*.png'];
FileListApply = dir(rawtargetpath);
% sort the aray by numerical order (file name of 'sort_nat.m' is required.)
sortedFileName = sort_nat({FileListApply.name}');

% if the first img name is not matched with mask name then, error code.
% Otherswise, proceed to extract the mask and apply to the raw image
idx = 1;
% if strcmp(sort_arry(1), strcat(regexprep(sortedFileName(1),'.jpg',''), '.png') )==1
if strcmp(sort_arry(1), strcat(regexprep(sortedFileName(1),'.png',''), '.png') )==1
    for mask_idx = 1:size(sort_arry,1)
%         address_maskimg = strcat(basedpath,'contour_',sort_arry(mask_idx));
         address_maskimg = strcat(basedpath,sort_arry(mask_idx));
        % Due to the type of 'address_masking', which is 'cell', we have to
        % convert it to 'string' type. That is why address_masking{1}
        current_maskimg = imread(address_maskimg{1});
        address_img     = strcat(rawtargetpathDIR, sortedFileName(idx));
        current_img     = imread( address_img{1});           
        current_img(current_maskimg==0)=mean(nonzeros(current_img(:)));
%         changedPath = strcat(strpath, regexprep(sortedFileName(idx),'.jpg',''), '.png');
        changedPath = strcat(strpath, regexprep(sortedFileName(idx),'.png',''), '.png');
%         imwrite(uint8(current_img), changedPath{1});
        imwrite(uint8(current_img), changedPath{1});
        % increasing idx for getting in the raw image
        idx = idx +1;
            
        while ( ~strcmp(sort_arry(mask_idx), strcat(regexprep(sortedFileName(idx),'.png',''), '.png')) && ...
                str2double(regexprep(sortedFileName(idx),'.png','')) < str2double(regexprep(sort_arry(mask_idx+1), '.png', '')) )
            
%             address_maskimg = strcat(basedpath,'contour_',sort_arry(mask_idx));
            address_maskimg = strcat(basedpath,sort_arry(mask_idx));
            current_maskimg = imread(address_maskimg{1});
            address_img     = strcat(rawtargetpathDIR, sortedFileName(idx));
            current_img     = imread( address_img{1});   
            % replacing Background to the mean of the brain 
            current_img(current_maskimg==0)=mean(nonzeros(current_img(:)));
%             changedPath = strcat(strpath, regexprep(sortedFileName(idx),'.jpg',''), '.png');
            changedPath = strcat(strpath, regexprep(sortedFileName(idx),'.png',''), '.png');
%             imwrite(uint8(current_img), changedPath{1});
            imwrite(uint8(current_img), changedPath{1});
            idx = idx +1;
        end
    end        
else
    fprintf(1,'Terminate the progrm due to missmatch the idx number at %d',i);
    quit cancel;
end
