function [ mean_image ] = extract_meanI_seq(image3D, STEP_SIZE, sizeOfpad, sizeOfFilter, N )
    avg_cnt = 0;
    sumImage=zeros(N); 
    
    for i=1:STEP_SIZE:N
        avg_cnt = avg_cnt+1;
        I = image3D(:,:,i);
        I = im2double(I);

        % padding boundaries
        padI = padarray(I,sizeOfpad,mean(I(:)),'both');
        medPadI=medfilt2(padI, sizeOfFilter);
        outI =medPadI( (sizeOfpad(1,1)+1) : (size(medPadI,1)-sizeOfpad(1,1)), ...
            (sizeOfpad(1,1)+1) : (size(medPadI,1)-sizeOfpad(1,1)) );
        sumImage=sumImage + double(outI);
    end    
    mean_image = sumImage/avg_cnt;
end


% % % % EXAMPLE (Averaging multiple images)

% % % % % slight modiifcations to the last answer
% % % % if the files are named image1.tif, image2.tif,....image1000.tif)
% % % % im = imread('image1.tif');
% % % % for i = 2:1000
% % % % im = imadd(im,imread(sprintf('image%d.tif',i)));
% % % % end
% % % % im = im/1000;
% % % % imshow(im,[]);