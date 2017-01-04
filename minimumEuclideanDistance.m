
% % Connecting between two blobs, TEST stage
clear; close all; clc;
tic;
strPath = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/5300to5700/test/*.png';
FileList = dir(strPath);
N = size(FileList,1);
strPath = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/5300to5700/test/';
temp_image3D=gen_3Dslices( FileList, N, strPath );


% ****IMPORTANT*****, please DEFINE the variable of THRSH_LENGTH in order
% to connect the disconnected joints. 
% extract all the indicies below than threshold value
THRSH_LENGTH = 11;

% preallocation for speeding
centroid_info=[];
target_blob  =[];

CC = bwconncomp(temp_image3D);
cc_stat = regionprops(CC, 'PixelList', 'BoundingBox', 'Area', 'PixelIdxList');
t=toc;disp(['initializing time: ', num2str(t)]); tic;

for i=1:size(cc_stat,1)
    %validation
    if size(CC.PixelIdxList{i},1) == cc_stat(i).Area
        % extracting max size of the layer
        max_layer = max(cc_stat(i).PixelList(:,3));
        % extracting min size of the layer
        min_layer = min(cc_stat(i).PixelList(:,3));
        diff_z = abs(max_layer-min_layer);
        % if size of the CC is less than threshold, discard the CC
        if (cc_stat(i).Area > 200000) || (cc_stat(i).Area < 2000)
            temp_image3D(CC.PixelIdxList{i})=0;
        end
    else
        fprintf(1,'Wrong array assignment in array number %d\n', i)
    end
end

disp('');

% parfor iStart=1:N % number 10 should be changed into 'td'
%     TREHS_BWDIST =3; disk_SE=3;
%     current_img = imdilate(temp_image3D(:,:,iStart), strel('disk',disk_SE));
% %     bw_crt_img = zeros(size(current_img)); 
% %     bw_crt_img(current_img>0)=1;
%     new_bwdist = bwdist(current_img) <= TREHS_BWDIST;
%     new_bwdist(new_bwdist>0) =255;
%     temp_image3D(:,:,iStart) = new_bwdist;
% end

CC = bwconncomp(temp_image3D);
cc_stat = regionprops(CC, 'PixelList', 'BoundingBox', 'Area', 'PixelIdxList');


for i=1:size(cc_stat)
    % get min centroid
    [B_ccmin,L_ccmin] = bwboundaries(temp_image3D(:,:, min(cc_stat(i).PixelList(:,end))));
    [y_min x_min] = find(cc_stat(i).PixelList(:,end)==min(cc_stat(i).PixelList(:,end)));
    x_min_cord = cc_stat(i).PixelList(y_min(1),1);
    y_min_cord = cc_stat(i).PixelList(y_min(1),2);
    current_min_lb_num = L_ccmin(y_min_cord, x_min_cord);
    crnt_min_lb_prop = regionprops(L_ccmin, 'Centroid');
    min_centroid = crnt_min_lb_prop(current_min_lb_num);
    % 1st col;x-cord of the centroid, 2nd col; y-cord of the centroid
    % 3rd col;order of the segment, 4th z-cord of the centroid
    centroid_info=[centroid_info; struct2array(min_centroid) i  min(cc_stat(i).PixelList(:,end)) ];
    
    % get max centroid 
    [B_ccmax,L_ccmax] = bwboundaries(temp_image3D(:,:, max(cc_stat(i).PixelList(:,end))));
    [y_max x_max] = find(cc_stat(i).PixelList(:,end)==max(cc_stat(i).PixelList(:,end)));
    x_max_cord = cc_stat(i).PixelList(y_max(1),1);
    y_max_cord = cc_stat(i).PixelList(y_max(1),2);
    current_max_lb_num = L_ccmax(y_max_cord, x_max_cord);
    crnt_max_lb_prop = regionprops(L_ccmax, 'Centroid');
    max_centroid = crnt_max_lb_prop(current_max_lb_num);
    % 1st col;x-cord of the centroid, 2nd col; y-cord of the centroid
    % 3rd col;order of the segment, 4th z-cord of the centroid
    centroid_info=[centroid_info; struct2array(max_centroid) i  max(cc_stat(i).PixelList(:,end))];   
end
t=toc;disp(['retriving centroid info time: ', num2str(t)]);tic;

original_centroid =centroid_info; i=1;
% get minimum distance between current segment and target segment

for i=1:(size(centroid_info,1))
    modified_info = centroid_info(:,1:2);  
    if mod(i,2) == 0    %Even number
        modified_info(i-1,:)=Inf;        
    else                %Odd
        modified_info(i+1,:)=Inf;
    end          
    distance_mat = pdist2(modified_info(i,:), modified_info, 'euclidean');
    distance_mat(1,find(distance_mat==0))=Inf; 
    [dist idx] = min((distance_mat));
    % 1st col; order of the startpoint segment, 
    % 2nd col; order of the targetpoiont segment
    % 3rd col; distance between the startpoint and the targetpoint
    % 4th col(startpoint); x-cord, 5th col;y-cord, 6th col; z-cord
    % 7th col(targetpoint); x-cord,8th col;y-cord, 8th col; z-cord
    target_blob = [target_blob; centroid_info(i,3)   centroid_info(idx,3)  dist ...
        centroid_info(i,1) centroid_info(i,2)  centroid_info(i,4)...
        centroid_info(idx,1) centroid_info(idx,2)   centroid_info(idx,4)];   
end
t=toc;disp(['mapping distance map time: ', num2str(t)]); tic; 
% delete duplicated element
[~, ind] =unique(target_blob(:, 3), 'rows');
duplicate_ind = setdiff(1:size(target_blob, 1), ind);
target_blob=removerows(target_blob,duplicate_ind);

% extract all the indicies below than threshold value
% THRSH_LENGTH = 10;
idx_thresh= find(target_blob(:,3)<THRSH_LENGTH);

% % if the euclidean distance is within the threshold, then.
% % get current row's information
Cordinates=[];
for idxs=1:size(idx_thresh)
    
    % get the segment order of first and last
    sliceNum_startblob=target_blob(idx_thresh(idxs,1),1);
    sliceNum_endblob=target_blob(idx_thresh(idxs,1),2);
    
    % % extract centroid of the first blob 
    x1 = target_blob(idx_thresh(idxs,1),4); 
    y1 = target_blob(idx_thresh(idxs,1),5); 
    z1 = target_blob(idx_thresh(idxs,1),6);

    % % extract the centroid of the last blob 
    xEnd = target_blob(idx_thresh(idxs,1),7); 
    yEnd = target_blob(idx_thresh(idxs,1),8); 
    zEnd = target_blob(idx_thresh(idxs,1),9);
    
    % assining fist (x1,y1) coordinate to the array
    Cordinates=[x1 y1 z1];
    nOfsegments = (target_blob(idx_thresh(idxs,1),9)-target_blob(idx_thresh(idxs,1),6))-1;
    
    for num=1:nOfsegments    
        xn = ((num/(nOfsegments+1)) *abs(xEnd-x1)) +x1;
        yn = ((num/(nOfsegments+1)) *abs(yEnd-y1)) +y1;        
        zn = target_blob(idx_thresh(idxs,1),6)+num;
        Cordinates = [Cordinates; xn yn zn];
    end   
    Cordinates = [Cordinates; xEnd yEnd zEnd];
    
    % Get the target bounding box (starting point)
    temp_centroid_info=[];
    target_img= temp_image3D(:,:, Cordinates(1,3));
    [B_test,L_test] = bwboundaries(target_img);
    target_start_lb_prop = regionprops(L_test);
    for lb=1:size(target_start_lb_prop)
        temp_centroid_info=[temp_centroid_info; target_start_lb_prop(lb).Centroid];
    end
    % get the field number(stp_idx) of the CC
    stp_idx=find(temp_centroid_info(:,1)==Cordinates(1,1));
    
    if (size(stp_idx,1) > 0)
        %% now, get the bounding box information
        % set the lowerbound and upper bound
        setUpperbound_x=size(L_test,1);
        setUpperbound_y=size(L_test,2);
        setLowerbond_xy = 1;

        % Due to 'ROUND' procedure, we should set the boundary.
        % if lower bound is less than 1; 
        if target_start_lb_prop(stp_idx).BoundingBox(2) < setLowerbond_xy
            x_boundbox_start = setLowerbond_xy;
        else 
            x_boundbox_start = round(target_start_lb_prop(stp_idx).BoundingBox(2));
        end

        % if upper bound of x is greater than maximum size of X;
        if round(target_start_lb_prop(stp_idx).BoundingBox(2)+ ...
                target_start_lb_prop(stp_idx).BoundingBox(4)) > setUpperbound_x
            x_boundbox_end = setUpperbound_x;
        else
            x_boundbox_end = round(target_start_lb_prop(stp_idx).BoundingBox(2)+ ...
                target_start_lb_prop(stp_idx).BoundingBox(4));
        end

        % if lower bound is less than 1; 
        if target_start_lb_prop(stp_idx).BoundingBox(1) < setLowerbond_xy
            y_boundbox_start = setLowerbond_xy;
        else
            y_boundbox_start = round(target_start_lb_prop(stp_idx).BoundingBox(1));
        end

        % if upper bound of y is greater than maximum size of Y;
        if round(target_start_lb_prop(stp_idx).BoundingBox(1)+ ...
                target_start_lb_prop(stp_idx).BoundingBox(3)) > setUpperbound_y
            y_boundbox_end = setUpperbound_y;
        else
            y_boundbox_end = round(target_start_lb_prop(stp_idx).BoundingBox(1)+ ...
                target_start_lb_prop(stp_idx).BoundingBox(3));
        end

        % Cropped bounding box in the target image
        cropped_bdbox= target_img(x_boundbox_start:x_boundbox_end, ...
         y_boundbox_start:y_boundbox_end);

        % Get raius of temporary replacement
        bw_bdbox=bwconncomp(cropped_bdbox);
        props_bdbox=regionprops(bw_bdbox, 'Centroid', 'MajorAxisLength','MinorAxisLength');
        diameters = mean([props_bdbox.MajorAxisLength   props_bdbox.MinorAxisLength],2);
        radii = round(diameters/2);

        % ACUTALLY, (Y,X). Not (X,Y)
        y_centroid = round(Cordinates(1,1));x_centroid= round(Cordinates(1,2));

        % starting from i=2 to (n-1), where n is the size of 'Cordinates'
        for m=2:(size(Cordinates,1)-1)
            current_img2insert = temp_image3D(:,:, Cordinates(m, 3));
            current_y = round(Cordinates(m,1));
            current_x = round(Cordinates(m,2));

            % Shifted coordinates
            shifted_y = y_centroid - current_y;
            shifted_x = x_centroid - current_x;

            current_img2insert(x_boundbox_start-shifted_x:x_boundbox_end-shifted_x, ...
                    y_boundbox_start-shifted_y:y_boundbox_end-shifted_y) = cropped_bdbox;

            temp_image3D(:,:, Cordinates(m, 3)) = current_img2insert;
        end
    end

end

t=toc;disp(['concatenating time: ', num2str(t)]); tic;


% % % sponed = temp_image3D;
% % % % Denosing again PROJECTION STEP
% % % xyImage = mean(temp_image3D, 3);
% % % otsu_img = otsu(xyImage);
% % % otsu_newimg=imdilate(otsu_img,strel('disk',1));
% % % % CC = bwconncomp(mat2gray(otsu_newimg));
% % % [B,L] = bwboundaries(mat2gray(otsu_newimg), 'noholes');
% % % lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
% % % % lb_prop = regionprops(CC, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area', 'PixelIdxList');
% % % angle_chattered_const = ([lb_prop.Orientation] < -12) & ([lb_prop.Orientation] > -16) & ...
% % %     ([lb_prop.Eccentricity] > 0.940);
% % % member_selected = ismember(L,find(angle_chattered_const));  
% % % otsu_img( member_selected ==1 ) = 0;
% % % [y x] = find(member_selected);


% image storring into file
strPath = '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/5300to5700/test/';
for iStart=1:N % number 10 should be changed into 'td'
   
    current = temp_image3D(:,:,iStart);
    current = im2double(current);
    
    changedPath = strcat(strPath, int2str(iStart), '.png ');
    imwrite(current, changedPath);
end

t=toc;disp(['storing time: ', num2str(t)]);
