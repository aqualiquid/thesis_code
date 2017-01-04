function [] = postprocessing_batched(final_path_FileList,FinalPath, strPath, idxstart)
% postprociessing(postFileList, post_path, str_path, idxstart)

tic;

FileList = dir(final_path_FileList);
% number of FileList
N = size(FileList,1);
temp_image3D=gen_3Dslices( FileList, N, FinalPath );
temp_image3D =imfill(temp_image3D, 'holes');
% xyImage = mean(temp_image3D, 3);
origin_3D_temp = temp_image3D;

% PROJECTION STEP
xyImage = mean(temp_image3D, 3);
otsu_img = otsu(xyImage);
otsu_newimg=imdilate(otsu_img,strel('disk',1));
% CC = bwconncomp(mat2gray(otsu_newimg));
[B,L] = bwboundaries(mat2gray(otsu_newimg), 'noholes');
lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
% lb_prop = regionprops(CC, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
angle_chattered_const = ([lb_prop.Orientation] < -12) & ([lb_prop.Orientation] > -16) & ...
    ([lb_prop.Eccentricity] > 0.940);
member_selected = ismember(L,find(angle_chattered_const));  
otsu_img( member_selected ==1 ) = 0;
[y x] = find(member_selected);

for i=1:size(x)
    temp_image3D(y(i),x(i),:)=0;
end

% END of PROJECTION STEP 


% % % % bridging strand 
for j=2:N-2
    % initializing boolean variable for validation bridging
    previmg=temp_image3D(:,:,j-1);
    nextimg=temp_image3D(:,:,j+1);
    nxtnxtimg= temp_image3D(:,:,j+2); %NEWLY INSERTED
    currentimg=temp_image3D(:,:,j);
    
    [prev_stat, current_satat, next_stat, nxtnxt_stat, nOfbx_prev, nOfbx_current, nOfbx_next, nOfbx_nxtnxt]= ...
        stat_call(previmg,nextimg,currentimg, nxtnxtimg);

    % validating for unsegmented layer 
    % (if and only if x-1 and x+1 isexist, then x is exist)
    % for more info, http://stackoverflow.com/questions/7940047/how-to-get-a-rectangular-subimage-from-regionpropsimage-boundingbox-in-matlab
    for k=1:nOfbx_prev
        
        setUpperbound_x=size(previmg,1);
        setUpperbound_y=size(previmg,2);
        setLowerbond_xy = 1;
        
        
        % Due to 'ROUND' procedure, we should set the lower bound or
        % upperbound
        
        % if lower bound is less than 1; 
        if prev_stat(k).BoundingBox(2) < setLowerbond_xy
            x_boundbox_start = setLowerbond_xy;
        else 
            x_boundbox_start = round(prev_stat(k).BoundingBox(2));
        end
        
        % if upper bound of x is greater than maximum size of X;
        if round(prev_stat(k).BoundingBox(2)+prev_stat(k).BoundingBox(4)) > setUpperbound_x
            x_boundbox_end = setUpperbound_x;
        else
            x_boundbox_end = round(prev_stat(k).BoundingBox(2)+prev_stat(k).BoundingBox(4));
        end
        
        % if lower bound is less than 1; 
        if prev_stat(k).BoundingBox(1) < setLowerbond_xy
            y_boundbox_start = setLowerbond_xy;
        else
            y_boundbox_start = round(prev_stat(k).BoundingBox(1));
        end
        
        % if upper bound of y is greater than maximum size of Y;
        if round(prev_stat(k).BoundingBox(1)+prev_stat(k).BoundingBox(3)) > setUpperbound_y
            y_boundbox_end = setUpperbound_y;
        else
            y_boundbox_end = round(prev_stat(k).BoundingBox(1)+prev_stat(k).BoundingBox(3));
        end
        
        
        
        prev_subImage= previmg(x_boundbox_start:x_boundbox_end, ...
             y_boundbox_start:y_boundbox_end);
        crnt_subImage = currentimg(x_boundbox_start:x_boundbox_end, ...
             y_boundbox_start:y_boundbox_end);
        next_subImage = nextimg(x_boundbox_start:x_boundbox_end, ...
             y_boundbox_start:y_boundbox_end);
        nxtnxt_subImage = nxtnxtimg(x_boundbox_start:x_boundbox_end, ...
             y_boundbox_start:y_boundbox_end);
%                  prev_subImage= previmg(floor(prev_stat(k).BoundingBox(2):prev_stat(k).BoundingBox(2)+prev_stat(k).BoundingBox(4)),...
%              floor(prev_stat(k).BoundingBox(1):prev_stat(k).BoundingBox(1)+prev_stat(k).BoundingBox(3)));
    
        if ( sum(prev_subImage(:))~=0 && sum(next_subImage(:))~=0 && sum(crnt_subImage(:))==0)
            % current subimage will be the union of x-1 and x+1
            crnt_subImage = max(prev_subImage, next_subImage);           
            % filling current image with intersection btween (x-1) and (x+1)
            currentimg(x_boundbox_start:x_boundbox_end, ...
                y_boundbox_start:y_boundbox_end) = crnt_subImage;
            % replaced modified image with original image (current layer)
            temp_image3D(:,:,j) = currentimg;
        elseif ( sum(prev_subImage(:))~=0 && sum(nxtnxt_subImage(:))~=0 && ...
                sum(next_subImage(:))==0 && sum(crnt_subImage(:))==0)
            % current subimage will be the union of x-1 and x+2
            crnt_subImage = max(prev_subImage, nxtnxt_subImage);      
            currentimg(x_boundbox_start:x_boundbox_end, ...
                y_boundbox_start:y_boundbox_end) = crnt_subImage;
            nextimg(x_boundbox_start:x_boundbox_end, ...
                y_boundbox_start:y_boundbox_end) = crnt_subImage;                                        
        end  
    end
end

CC = bwconncomp(temp_image3D);
THRESH_SIZE=10000;
% connected component segmentation from 3D volume
for i=1:size(CC.PixelIdxList,2)
     if size(CC.PixelIdxList{i},1) <THRESH_SIZE 
        temp_image3D(CC.PixelIdxList{i}) =0;
     end
end
disp('');




% image storring into file
% strPath = '../../test_data_1202/test_final_processed_10px/b-r/b-r_post_500px/';
for iStart=1:N % number 10 should be changed into 'td'
   
    current = temp_image3D(:,:,iStart);
    current = im2double(current);
    
    changedPath = strcat(strPath, int2str(iStart+idxstart), '.bmp');
    imwrite(current, changedPath);
end

t=toc;disp(['elapse time: ', num2str(t)]);
end
