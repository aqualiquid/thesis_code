function [ nuevo ] = remov_blob_px( input_img )
% Remove blob that lower than given pixel value 
   
   THRESH_PX = 115;
   nuevo = zeros(size(input_img,1));
   % normalize each pixel between 0 to 255
   nuevo(:) = (input_img - min(input_img(:)))*255/(max(input_img(:)) - min(input_img(:)));
   nuevo(nuevo<THRESH_PX) = 0;
   
end

