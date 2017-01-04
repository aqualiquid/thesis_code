function [ img ] = denoised_cornerPX( img )
% Filling 4 coner pixels (top-left, top-right, bottom-left, bottom-right)
    [x y] =size(img);

    % Denosing top left
    if ( img(1,1) == 0  && (img(1,2) ~= 0 || img(2,1) ~= 0) ) 
        img(1,1) = (img(1,2)+img(2,1))/2;
    end
    
    % Denosing top right
    if ( img(1,y) == 0  && (img(2,y) ~= 0 || img(1,y-1) ~= 0) ) 
        img(1,y) = (img(2,y)+img(1,y-1))/2;
    end
    
    % Denosing bottom left
    if ( img(x,1) == 0  && (img(x-1,1) ~= 0 || img(x,2) ~= 0) ) 
        img(x,1) = (img(x-1,1)+img(x,2))/2;
    end
    
    % Denosing bottom right
    if ( img(x,y) == 0  && ( img(x-1,y) ~= 0 || img(x,y-1) ~= 0) ) 
        img(x,y) = (img(x-1,y)+img(x,y-1))/2;
    end 
    
    

end

