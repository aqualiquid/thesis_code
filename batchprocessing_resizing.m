function [] = batchprocessing_resizing(final_path_FileList,FinalPath,strPath, numbering, scale) 
% resizing function [default 25% scale]
    
    tic;
    FileList = dir(final_path_FileList);
    N = size(FileList,1);
    
    temp_image3D=gen_3Dslices( FileList, N, FinalPath );
    t=toc;disp(['elapse time: ', num2str(t)]);
    
    new_x = round(scale*size(temp_image3D,1)); 
    new_y = round(scale*size(temp_image3D,2)); 
    new_z = round(scale*size(temp_image3D,3)); 
    new_temp_image3D = imresize3d(temp_image3D,[],[new_x new_y new_z],'nearest','bound');
    
    

    if size(new_temp_image3D,3) == new_z
        parfor iStart = 1:size(new_temp_image3D,3)
            current_img = new_temp_image3D(:,:,iStart);

            changedPath = strcat(strPath, numbering, '_', num2str(iStart), '.png');
            imwrite(uint8(current_img), changedPath);
        end
    end

end