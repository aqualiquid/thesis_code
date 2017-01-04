function [gt_stat,sgmt_stat,num_of_boundingbox_gt,num_of_boundingbox_sgmt] ...
    = val_stat_call(gt_img, sgmt_img)
    
    % previous region properties
    gt_conn = bwconncomp(gt_img);
    gt_stat = regionprops(gt_conn); 
    num_of_boundingbox_gt = gt_conn.NumObjects;
    
    % current region properties
    sgmt_conn = bwconncomp(sgmt_img);
    sgmt_stat = regionprops(sgmt_conn); 
    num_of_boundingbox_sgmt = sgmt_conn.NumObjects;
    
  
end