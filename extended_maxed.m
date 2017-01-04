function [ temp ] = extended_maxed( input_img, THR_MAX )

    temp = input_img;
    
    mask_em = imextendedmax(temp, THR_MAX);
    temp( mask_em == 0 ) = 0;
% % %     % assigning pixels
% % %     [u v] = size(temp);
% % %     for i=1:u
% % %         for j=1:v
% % %             if (mask_em(i,j) == 0)
% % % %                     I(i,j)=0;
% % %                 temp(i,j)=0;
% % %             end
% % %         end
% % %     end

end

