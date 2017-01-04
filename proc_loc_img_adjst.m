function [ I2 ] = proc_loc_img_adjst(im ) 
    % enhancing image with N/4 window size
    sizeOfST = round(size(im,1)/4);
    testI=im;
    
    testbg =imopen(testI, strel('disk',sizeOfST));
    I2= testI-testbg;
    
    I2(:) = (I2 - min(I2(:)))*255/(max(I2(:)) - min(I2(:)));

end



% % %    grayImage = im;
% % %     % Get the dimensions of the image.  
% % %     % numberOfColorBands should be = 1.
% % %     [rows columns numberOfColorBands] = size(grayImage);
% % %     if numberOfColorBands > 1
% % %         grayImage = rgb2gray(grayImage);
% % %     end
% % %     % Display the original gray scale image.
% % %     subplot(2, 2, 1);
% % %     imshow(grayImage, []);
% % %     title('Original Grayscale Image');
% % %     % Enlarge figure to full screen.
% % %     set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% % %     % Give a name to the title bar.
% % %     set(gcf,'name','Demo by ImageAnalyst','numbertitle','off') 
% % %     % Close the image
% % %     se = strel('disk', 30);
% % %     closedImage = imclose(grayImage, se);
% % %     subplot(2, 2, 2);
% % %     imshow(closedImage, []);
% % %     title('Closed Image');
% % %     % Subtract to get the vessels alone.
% % %     vesselImage =  log(1+double(grayImage)) - log(1+double(closedImage));
% % %     subplot(2, 2, 3);
% % %     imshow(vesselImage, []);
% % %     title('Subtracted Image');
% % %     disp('');
% % % 




       
% % %     
% % %        analyzing max intensity of the current image
% % %     MAX = max(im(:));  
% % %     testI=imadjust(im, [0.3 0.87], [0 1]); 
    
    
    
    
    


% %     testI2 = adapthisteq(mat2gray(testI), 'ClipLimit', 0.002, 'Distribution','uniform');
% %     

    
% %      I2 = imtophat(im,strel('disk',sizeOfST));

% %     figure(10), imshow(I2,[]);