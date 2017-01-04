clc; close all; clear;

recall_info=[];
precison_info=[];

% path = ...
%     '/Users/Robert/Desktop/0102NISSLDATA_RESIZED50P/validation/attmpt_01_31_2016/';
path= ['..' filesep '0402RAT' filesep 'comparison' filesep];
gt_path         = strcat(path,'groundimg\');
segmented_path  = strcat(path,'WK\');
% segmented_path  = strcat(path,'jamesmodified\');

gt_FileList     = dir(strcat(gt_path,'*.png'));
sgmt_FileList   = dir(strcat(segmented_path, '*.png'));
numberOfGroundTruth=size(gt_FileList,1);

if(size(gt_FileList,1) ~= size(sgmt_FileList,1))
    error('Error. \n The number of gt must be matched with the number of sgmt.');
end

for iStart =1: size(gt_FileList,1)
    [gt_current gt_idx] = load_slice(gt_FileList, gt_path, iStart);
    [sgmt_current sgmt_idx] = load_slice(sgmt_FileList, segmented_path, iStart);
    sgmt_current(sgmt_current>1) =1; % code for BINARIZING 0 or 1
    
    % number of denominator (get CC number of sgmt)
    sgmt_CC = bwconncomp(sgmt_current);
    
    % initializing
    denominator = sgmt_CC.NumObjects;
    recall_num = 0;
    precision_num = 0;
    
    [gt_stat,sgmt_stat,num_of_boundingbox_gt,num_of_boundingbox_sgmt] ...
        = val_stat_call(gt_current, sgmt_current);
    
    % calculate recall
    adj_recall_num=precision_recall_cal(gt_stat,num_of_boundingbox_gt, gt_current, sgmt_current, recall_num);
    
    % calculate precision
    adj_precision_num=precision_recall_cal(sgmt_stat,num_of_boundingbox_sgmt, sgmt_current, gt_current, precision_num);
    
    
    recall_info = ...
        [recall_info; (num_of_boundingbox_gt-adj_recall_num)  num_of_boundingbox_gt ...
        (num_of_boundingbox_gt-adj_recall_num)/(num_of_boundingbox_gt)];
    
    precison_info = ...
        [precison_info; (num_of_boundingbox_sgmt-adj_precision_num)  num_of_boundingbox_sgmt ...
        (num_of_boundingbox_sgmt-adj_precision_num)/(num_of_boundingbox_sgmt)];
    

end


avg_recall   = sum(recall_info(:,3))/size(recall_info,1);
avg_precision = sum(precison_info(:,3))/size(precison_info,1);

numberOfGroundTruth
avg_precision
avg_recall

