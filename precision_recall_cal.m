function [num_no_intersection] = ...
    precision_recall_cal(img_stat,num_of_boundingbox, denom_img, intersec_img, prev_num_no_intersection)

for k=1:num_of_boundingbox
    
    setUpperbound_x=size(denom_img,1);
    setUpperbound_y=size(denom_img,2);
    setLowerbond_xy = 1;
    
    % Due to 'ROUND' procedure, we should set the lower bound or
    % upperbound
    
    % if lower bound is less than 1;
    if img_stat(k).BoundingBox(2) < setLowerbond_xy
        x_boundbox_start = setLowerbond_xy;
    else
        x_boundbox_start = round(img_stat(k).BoundingBox(2));
    end
    
    % if upper bound of x is greater than maximum size of X;
    if round(img_stat(k).BoundingBox(2)+img_stat(k).BoundingBox(4)) > setUpperbound_x
        x_boundbox_end = setUpperbound_x;
    else
        x_boundbox_end = round(img_stat(k).BoundingBox(2)+img_stat(k).BoundingBox(4));
    end
    
    % if lower bound is less than 1;
    if img_stat(k).BoundingBox(1) < setLowerbond_xy
        y_boundbox_start = setLowerbond_xy;
    else
        y_boundbox_start = round(img_stat(k).BoundingBox(1));
    end
    
    % if upper bound of y is greater than maximum size of Y;
    if round(img_stat(k).BoundingBox(1)+img_stat(k).BoundingBox(3)) > setUpperbound_y
        y_boundbox_end = setUpperbound_y;
    else
        y_boundbox_end = round(img_stat(k).BoundingBox(1)+img_stat(k).BoundingBox(3));
    end
    
    denom_subImage= denom_img(x_boundbox_start:x_boundbox_end, ...
        y_boundbox_start:y_boundbox_end);
    intersec_subImage = intersec_img(x_boundbox_start:x_boundbox_end, ...
        y_boundbox_start:y_boundbox_end);
    
    isDiff = abs(sum(intersec_subImage(:)));
    
    % if there is no intersection between bounding box of gt and sgmt
    if  sum(denom_subImage(:))~=0 && (isDiff<1)
        prev_num_no_intersection = prev_num_no_intersection +1;
    end  
end
    % redefine
    num_no_intersection=prev_num_no_intersection;

end