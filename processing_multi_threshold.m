function [ manipulated ] = processing_multi_threshold(input_img,TRG_LV)
    % Otsu's multiple threshold  ->>>>>> Indeed, preserved origianl input
    % if TRG_LV =0 then threshold only MAXLV.
    % if TRG_LV =1 then threshold MAXLV and (MAXLV-1)
   
    LV_MULT_THRSH =5;
    multi_thrsh = gather(otsu(gpuArray(input_img), LV_MULT_THRSH));
    MAXLV= max(multi_thrsh(:));
    % Threshold 
    multi_thrsh(multi_thrsh<(MAXLV)-(TRG_LV))=0; %not applicable? 
    
    
    % Preserving step (if current is 0 then origin is 0)
    input_img( multi_thrsh == 0 ) = 0;
     
    % for return variable 
    manipulated = input_img;
    
    

end

