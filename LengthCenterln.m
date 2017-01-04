function [centerline_length] = LengthCenterln(ccrt_stat, temp_image3D)
centerline_length=[];

% find unique value of z-axis, which is idx number of z-axis value
unique_val=unique(ccrt_stat.PixelList(:,3));
% iterate until size of i-th's PixelIdxList
if size(unique_val,1) <= 1
    % current slice of i-th layer
    img_slice= temp_image3D(:,:,unique_val(1));
    %         [rows, cols] =ind2sub(size_img,ccrt_stat.PixelIdxList(1));
    [tf, idx] = ismember(unique_val(1), ccrt_stat.PixelList(:,3));
    %           get idx-th's index of row and col in i-th layer
    cols = ccrt_stat.PixelList(idx,1);
    rows = ccrt_stat.PixelList(idx,2);
    
    component_size1 = bwselect(img_slice,cols,rows);
    centroid_size1  = regionprops(component_size1,'centroid');
    centerline_length = [centerline_length;     0];
else
    loc_centroid=[];
    loc_centerline_length=0;
    for j=1:size(unique_val,1)
        img_slice= temp_image3D(:,:,unique_val(j));
        % find index from 3rd cols(z-axis) from ccrt_stat
        [tf, idx] = ismember(unique_val(j), ccrt_stat.PixelList(:,3));
        %           get idx-th's index of row and col in i-th layer
        cols = ccrt_stat.PixelList(idx,1);
        rows = ccrt_stat.PixelList(idx,2);
        selected_cc  = bwselect(img_slice,cols,rows);
        cntroid   = regionprops(selected_cc,'centroid');
        loc_centroid=[loc_centroid;     cntroid];
    end
    % calculate centerline's length of i-th connected component
    for k= 1:size(loc_centroid,1)-1
        prev = struct2cell(loc_centroid(k));
        next = struct2cell(loc_centroid(k+1));
       x1= prev{1}(1);   y1= prev{1}(2);   z1= unique_val(k);
       x2= next{1}(1);   y2= next{1}(2);   z2= unique_val(k+1);
       
       Pos=[x1 y1 z1;x2 y2 z2];
        distance_Pos = pdist(Pos,'euclidean');
        loc_centerline_length=distance_Pos + loc_centerline_length;
    end
    % [size(unique,1)-1] refers to length of z-axis
%     loc_centerline_length = loc_centerline_length + (size(unique_val,1)-1);
    centerline_length = [centerline_length; loc_centerline_length];
end

end
