function [prev_stat,current_stat,next_stat,nxtnxt_stat,num_of_boundingbox_previmg,num_of_boundingbox_currentimg,num_of_boundingbox_nextimg, num_of_boundingbox_nxtnxtimg] = stat_call(previmg, currentimg, nextimg, nxtnxtimg)
    % previous region properties
    prev_conn = bwconncomp(previmg);
    prev_stat = regionprops(prev_conn); 
    num_of_boundingbox_previmg = size(prev_stat,1);
    
    % current region properties
    current_conn = bwconncomp(currentimg);
    current_stat = regionprops(current_conn); 
    num_of_boundingbox_currentimg = size(current_stat,1);
    
    % next region properties
    next_conn = bwconncomp(nextimg);
    next_stat = regionprops(next_conn); 
    num_of_boundingbox_nextimg = size(next_stat,1);
    
      
    % next after next region properties
    nxtnxt_conn = bwconncomp(nxtnxtimg);
    nxtnxt_stat = regionprops(nxtnxt_conn); 
    num_of_boundingbox_nxtnxtimg = size(nxtnxt_stat,1);
    
end