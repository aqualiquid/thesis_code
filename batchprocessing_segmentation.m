function [] = batchprocessing_segmentation(path_FileList,path,fullpath)
    % Create FileList
    FileList = dir(path_FileList);
    N = size(FileList,1);    
    % set DoG threshold EMPIRICAL RESULT, VERY SENSATIVE and Important
    sigma_enhancement=10;
    tic;
    for iStart = 1:N;  
        
        [current_slice slice_idx] = load_slice(FileList, path, iStart);

        Iblur = imgaussfilt(current_slice, 50);
        illum_corrected = 1 - ((1-current_slice)-(1-Iblur));
        illum_corrected = illumination_correction(mat2gray(illum_corrected), sigma_enhancement );
        illum_corrected(:) = (illum_corrected - min(illum_corrected(:)))*255/(max(illum_corrected(:))...
            - min(illum_corrected(:)));
        
%       w_correction = DoG_enhancement(illum_corrected);
%       ORIGINAL SEGMENTATION BELOW
        w_correction = processing_noise(illum_corrected);

        %validation 
        if mean(w_correction(:))> 45
            w_correction(w_correction<255) = 0;
        end
%         mkdir(strcat(fullpath,'segmented'));
        changedPath = strcat(fullpath,slice_idx,'.png');
        imwrite(uint8(w_correction), changedPath{1});
    end
    t=toc;disp(['elapse time: ', num2str(t)]);
end
