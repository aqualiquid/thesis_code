function [ image3D ] = gen_3Dslices( FileList, N, path )
    % Sorting FileList to natural order
    sortedFileName = sort_nat({FileList.name}');
    t=tic;
    parfor k = 1:N
        filename = char(sortedFileName(k)); 
        fullpath = strcat(path, filename);
        % parallel processing 
        image3D(:,:,k)=double(imread(fullpath));
    end
    tElapsed = toc(t);
    tElapsed
end

