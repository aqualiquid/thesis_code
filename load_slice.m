function [slice slice_idx] = load_slice(FileList, path, idx)
    sortedFileName = sort_nat({FileList.name}');
%     filename = sortedFileName(idx).name;
    filename = sortedFileName(idx);
    fullpath = strcat(path, filename);
    fprintf(1, 'current path is  %s \n', fullpath{1});
    slice = double(imread(char(fullpath)));
    slice_idx =  (regexprep(filename,'.png',''));

end
