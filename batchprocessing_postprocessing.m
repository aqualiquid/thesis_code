function [] = batchprocessing_postprocessing(final_path_FileList,FinalPath,strPath, raw_path_FileList,raw_path)
 
    % THRESH_layer is the number for a NOISE REMOVAL (DEFAULT 60)
    THRESH_layer = 50;
    tic;
    FileList = dir(final_path_FileList);
    % number of FileList
    N = size(FileList,1);
    
    temp_image3D=gen_3Dslices( FileList, N, FinalPath );
    if sum(temp_image3D(:)) == 0
        return
    end
    

    origin_3D_temp = temp_image3D;
    t=toc;disp(['elapse time: ', num2str(t)]);

    %% PROJECTION STEP
    xyImage = mean(temp_image3D, 3);
    % % % % MANUALLY, thresholded
    xyImage(xyImage<20)=0;
    otsu_newimg=imdilate(uint8(xyImage),sstrel('disk',1));
%     otsu_newimg=gather(imdilate(gpuArray(uint8(xyImage)),strel('disk',1)));
    % CC = bwconncomp(mat2gray(otsu_newimg));
    [B,L] = bwboundaries(mat2gray(otsu_newimg), 'noholes');
    lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    % lb_prop = regionprops(CC, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    angle_chattered_const = ([lb_prop.Orientation] < -12) & ([lb_prop.Orientation] > -18) & ...
        ([lb_prop.Eccentricity] > 0.940) & ([lb_prop.Area] < 18000) &([lb_prop.Solidity]>0.45);
    member_selected = ismember(L,find(angle_chattered_const));  
    [y x] = find(member_selected);
    figure(1), imshow(member_selected); title('manually denoised');
    for i=1:size(x)
        temp_image3D(y(i),x(i),:)=0;
    end
    clear member_selected;clear B; clear L; clear xyImage; clear otsu_newimg; clear lb_prop;

    
    % re-denoised (otsu)
    xyImage = mean(origin_3D_temp, 3);
    otsu_img = otsu(xyImage);
%     otsu_newimg=gather(imdilate(gpuArray(uint8(otsu_img)),strel('disk',1)));
    otsu_newimg=imdilate(uint8(otsu_img),strel('disk',1));
    [B,L] = bwboundaries(mat2gray(otsu_newimg), 'noholes');
    lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    % lb_prop = regionprops(CC, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    angle_chattered_const = ([lb_prop.Orientation] < -12) & ([lb_prop.Orientation] > -16) & ...
        ([lb_prop.Eccentricity] > 0.940) & ([lb_prop.Area] < 18000) &([lb_prop.Solidity]>0.45);
    member_selected = ismember(L,find(angle_chattered_const));  
%      ( member_selected ==1 ) = 0;
    [y x] = find(member_selected);
    figure(2), imshow(member_selected); title('otsu denoised');
%     otsuFIG= member_selected;
    for i=1:size(x)
        temp_image3D(y(i),x(i),:)=0;
    end
    clear member_selected;clear B; clear L; clear xyImage; clear otsu_newimg; clear lb_prop;

    
    % re-denoised (nonzeros' extended h-max)
    xyImage = mean(origin_3D_temp, 3);
    maxImg = extended_maxed(xyImage, mean(nonzeros(xyImage(:))) );
    % CC = bwconncomp(mat2gray(otsu_newimg));
    [B,L] = bwboundaries(mat2gray(maxImg), 'noholes');
    lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    % lb_prop = regionprops(CC, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    angle_chattered_const = ([lb_prop.Orientation] < -12) & ([lb_prop.Orientation] > -16) & ...
        ([lb_prop.Eccentricity] > 0.940) & ([lb_prop.Area] < 18000) &([lb_prop.Solidity]>0.45);
    member_selected = ismember(L,find(angle_chattered_const));  
    otsu_img( member_selected ==1 ) = 0;
    [y x] = find(member_selected);
    figure(3), imshow(member_selected); title('mean of h-maxima denoised');
    for i=1:size(x)
        temp_image3D(y(i),x(i),:)=0;
    end
    clear member_selected;clear B; clear L; clear maxImg; clear xyImage; clear otsu_img; clear lb_prop;

    % re-denoised (DoG)
    xyImage = mean(origin_3D_temp, 3);
    dogImg = DoG_enhancement_removal(xyImage);
    % CC = bwconncomp(mat2gray(otsu_newimg));
    [B,L] = bwboundaries(mat2gray(dogImg), 'noholes');
    lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    % lb_prop = regionprops(CC, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
    angle_chattered_const = ([lb_prop.Orientation] < -12) & ([lb_prop.Orientation] > -16) & ...
        ([lb_prop.Eccentricity] > 0.940) & ([lb_prop.Area] < 18000) &([lb_prop.Solidity]>0.45);
    member_selected = ismember(L,find(angle_chattered_const));  
%     otsu_img( member_selected ==1 ) = 0;
    [y x] = find(member_selected);
    figure(4), imshow(member_selected); title('DoG peek denoised');
%     DoGFIG = member_selected;
    for i=1:size(x)
        temp_image3D(y(i),x(i),:)=0;
    end
    clear member_selected;clear B; clear L; clear dogImg; clear xyImage; clear lb_prop;


    %% END of PROJECTION STEP 
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

    % connected component segmentation from 3D volume
    CC = bwconncomp(temp_image3D);
%     cc_stat = regionprops(CC, 'PixelList', 'BoundingBox', 'Area', 'PixelIdxList');
    cc_stat = regionprops(CC, temp_image3D, 'PixelList', 'BoundingBox', 'Area', 'PixelIdxList', ...
        'MaxIntensity', 'MeanIntensity','MinIntensity', 'WeightedCentroid', 'PixelValues');
    for i=1:size(cc_stat,1)
        %validation 
        if size(CC.PixelIdxList{i},1) == cc_stat(i).Area
            % extracting max size of the layer
            max_layer = max(cc_stat(i).PixelList(:,3));
            % extracting min size of the layer
            min_layer = min(cc_stat(i).PixelList(:,3));
            diff_z = abs(max_layer-min_layer);
            % if size of the CC is less than threshold, discard the CC
            if (diff_z < THRESH_layer) || cc_stat(i).MaxIntensity <230
                temp_image3D(CC.PixelIdxList{i})=0;
            end
        else
            fprintf(1,'Wrong array assignment in array number %d\n', i)
        end
    end



    %% Post processing for knife edge removal (combined noise with other features)
    % This method is extracted from 'postprocessing_detail_removal.m'

    CC = bwconncomp(temp_image3D);
    cc_stat = regionprops(CC, 'PixelList', 'BoundingBox', 'Area', 'PixelIdxList');
    % Make replication of current volume
    origin_image3D = temp_image3D;
    for i=1:size(cc_stat,1)
        temp_image3D(CC.PixelIdxList{i})=0;
    end

    for j=1:size(cc_stat,1)
        temp_image3D(CC.PixelIdxList{j})= 255;
        current_xyImage = mean(temp_image3D, 3);

        [B,L] = bwboundaries(mat2gray(current_xyImage), 'noholes');
        lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
        angle_chattered_const = ([lb_prop.Orientation] < -12) & ([lb_prop.Orientation] > -18) & ...
            ([lb_prop.Eccentricity] > 0.940) & ([lb_prop.Area] < 18000) &([lb_prop.Solidity]>0.45);
        member_selected = ismember(L,find(angle_chattered_const));
        % If you want to see the result of 'member selected', activat the
        % following code (imshow).
    %     figure(1), imshow(member_selected); title('currently denoised'); 
        if (sum(member_selected(:)) > 0) 
            % make it 0 in the origin image
            origin_image3D(CC.PixelIdxList{j}) = 0;
        end    
        % Disable the current PixelIdxList in 3D volume
        temp_image3D(CC.PixelIdxList{j})= 0;
    end
    
    changed_image3d =origin_image3D;
    % call batchprocessing minimumEuclidean 
%     [ changed_image3d ] = batchprocessing_minimumEuclidean( origin_image3D );

    
%   ERASED on 3/20/2016 needs to be recovered    
%     for i=1:size(cc_stat,1)
%         %validation
%         if size(CC.PixelIdxList{i},1) == cc_stat(i).Area
%             if  cc_stat(i).Area <5000
%                 temp_image3D(CC.PixelIdxList{i})=0;
%             end
%         else
%             fprintf(1,'Wrong array assignment in array number %d\n', i)
%         end
%     end
    
    
    
    % 02/09/2016manually re-assigned

    raw_FileList = dir(raw_path_FileList);
%     N = size(raw_FileList,1);    
    
%     if size(raw_FileList,1) == N
        for iStart = 1:N;
%             FinalPath
%             [current_rawslice slice_idx] = load_slice(FileList, raw_path, iStart);
            [current_rawslice slice_idx] = load_slice(FileList, FinalPath, iStart);
            current = changed_image3d(:,:,iStart);
            current_rawslice(current==0) =0;

            changedPath = strcat(strPath, slice_idx, '.png');
            imwrite(uint8(current_rawslice), changedPath{1});

        end
%     end
    
    close all;
end