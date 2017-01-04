

function [member_selected]=removing_bg_noise(I)

% clc;
% close all;
% clear;
% test_img = '../../test_data_1202/test_final_processed_10px/b-r/4.png';
% I = imread(test_img);
% figure, imshow(I);

extended_50img = extended_maxed(I,50);
% extended_55img = extended_maxed(I,55);
extended_60img = extended_maxed(I,60);
% extended_65img = extended_maxed(I,65);
% % 
%     figure, imshow(extended_60img,[]);
%     figure, 
%     subplot(2,2,1), imshow(extended_50img,[]); title('extended_50img');
%     subplot(2,2,2), imshow(extended_55img,[]); title('extended_55img');
%     subplot(2,2,3), imshow(extended_60img,[]); title('extended_60img');
%     subplot(2,2,4), imshow(extended_65img,[]); title('extended_65img');

[CC50 L50]= bwboundaries(extended_50img, 'noholes');
[CC60 L60]= bwboundaries(extended_60img, 'noholes');
selected50 = selection_ismember(L50);
selected60 = selection_ismember(L60);
member_selected = max(selected50,selected60);
member_selected = bwareaopen(member_selected, 1000);
% % lb_prop = regionprops(L50, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area');
% % 
% % size_constraint = ([lb_prop.Area] < 50000);
% % solidity_constraint = ([lb_prop.Solidity] > 0.5 );
% % 
% % constraint = (size_constraint | solidity_constraint );
% % 
% % denoise_selection = constraint;
% % member_selected50 = ismember(L50,find(denoise_selection));  
% % member_selected50 = ismember(L60,find(denoise_selection));  
% % max(
% extended_50img( member_selected == 1 ) = 0;

% figure, imshow(member_selected,[]);

end
