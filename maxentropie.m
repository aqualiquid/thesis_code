% MODIFIED version -> Wookyung An (
%**************************************************************************
%**************************************************************************
%   
% maxentropie is a function for thresholding using Maximum Entropy
% 
% 
% input = I ==> Image in gray level 
% output =
%           I1 ==> binary image
%           threshold ==> the threshold choosen by maxentropie
%  
% F.Gargouri
%
%
%**************************************************************************
%**************************************************************************

% MAYBE, you can add DoG filter with segmented image where it doesn't not
% well segmented.

function [threshold I1]=maxentropie(I_origin,offset, flag)
    I = I_origin;
%     switch flag 
%         case 1
%             I = DoG_enhancement(I);  
%             I(:) = (I - min(I(:)))*255/(max(I(:)) - min(I(:))); 
%         case 0
%             disp('Not DoG enhancement applied');
%     end
    
    
    user_thresh = 255; % Make it disabled
    [n,m]=size(I);
    h=imhist(I);
    %normalize the histogram ==>  hn(k)=h(k)/(n*m) ==> k  in [1 256]
    hn=h/(n*m);
   
    %Cumulative distribution function
	c(1) = hn(1);
    for l=2:256
        c(l)=c(l-1)+hn(l);
    end
    
    
    hl = zeros(1,256);
    hh = zeros(1,256);
    for t=1:256
        %low range entropy
        cl=double(c(t));
        if cl>0
            for i=1:t
                if hn(i)>0
                    hl(t) = hl(t)- (hn(i)/cl)*log(hn(i)/cl);                      
                end
            end
        end
        
        %high range entropy
        ch=double(1.0-cl);  %constraint cl+ch=1
        if ch>0
            for i=t+1:256
                if hn(i)>0
                    hh(t) = hh(t)- (hn(i)/ch)*log(hn(i)/ch);
                end
            end
        end
    end
    
    % choose best threshold
    
	h_max =hl(1)+hh(1);
	threshold = 0;
    entropie(1)=h_max;
    for t=2:256
        entropie(t)=hl(t)+hh(t);
        if entropie(t)>h_max
            h_max=entropie(t);
            threshold=t-1;
        end
    end
    
    isValuelessthanThreshold = true;    
    if (threshold >user_thresh) || (std2(I)<4.00)
        % Display    
        I1 = zeros(size(I));
        I1(I<(abs(threshold-offset))) = 0;
        I1(I>(abs(threshold-offset))) = 255;
        imshow(I1)     
    else

        I1 = zeros(size(I));
        I1(I<(abs(threshold-(offset-10)))) = 0;
        I1(I>(abs(threshold-(offset-10)))) = 255;
        imshow(I1)   
        % if mean value is more than 50, then increasing threshold value
        % and Re-thresholding
        if mean(I1(:)) > 50 
            while(isValuelessthanThreshold)
                threshold = threshold+std2(I);  
                if threshold > user_thresh
                    isValuelessthanThreshold = false;
                end
            end
            % Re-thresholding
            I1(I<(threshold)) = 0;
            I1(I>(threshold)) = 255;
        end
        
    end
      
   disp('');     
end
    
    
  
    