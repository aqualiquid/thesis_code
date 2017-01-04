clc;close all; clear;
% I=imread('/Users/Robert/Desktop/test_data_1202/resized50p/resized_05395.jpg.png');
path_FileList = '../../test_data_1202/new_cropped_resized50p_1/*.png';
path = '../../test_data_1202/new_cropped_resized50p_1/';
FileList = dir(path_FileList);
N = size(FileList,1);

for iStart = 1:N;  
    I = load_slice(FileList, path, iStart);
    I(:) = (I - min(I(:)))*255/(max(I(:))- min(I(:)));
    sharpened = imsharpen(I);   
    Inew=I;
    Inew(sharpened<175)=0;
    Inew_dilate = imdilate(Inew,strel('disk',10)); 
    Inew_dilate= bwareaopen(Inew_dilate,1000);
    
    % I is the raw image
    E = entropyfilt(uint8(I));
    E(:) = (E - min(E(:)))*255/(max(E(:))- min(E(:)));

%     figure, imshow(E,[]);
    Eim = mat2gray(E);

    BWao = bwareaopen(im2bw(Eim, .6),5000);
    BWa1 =BWao;
    

    % get connected component of 'BWao'
    CC = bwconncomp(BWao);
    % % BWao(CC.PixelIdxList{1}) =false;
    % % BWao(CC.PixelIdxList{3}) =false;
    % % BWao(CC.PixelIdxList{4}) =false;

    THRESH_SIZE=10000;
    %connected component segmentation from 3D volume
    for i=1:size(CC.PixelIdxList,2)
         if size(CC.PixelIdxList{i},1) <THRESH_SIZE 
            BWao(CC.PixelIdxList{i}) =0;
         end
    end

    %NEWLY INSERTED
    BWa1(Inew_dilate~=0)=0;
%     BWa1 =bwareaopen(BWa1, 500);

    % TEST 1, -15 degree
    radian1=deg2rad(105);
    [filtered1, gb] = get_gaborfiltered_img(BWao, radian1);
    K1= filtered1;
    K1(:) = (K1 - min(K1(:)))*255/(max(K1(:))- min(K1(:)));
    se = strel('disk', 15);
    K1(K1<190)=0;
    K1_imd=imdilate(K1,se);
    % figure, imshowpair(BWao, K1_imd);

    BWa1(K1_imd~=0)=0;

    BWao1 =bwareaopen(BWao, 100);

    % % % % TEST 2, -13 degree
    % % % radian2 = 0.5729;% % % % TEST 2, -13.6 degree
    % % % [filtered2, gb] = get_gaborfiltered_img(BWao, radian2);
    % % % K2=filtered2;
    % % % K2(:) = (K2 - min(K2(:)))*255/(max(K2(:))- min(K2(:)));
    % % % se = strel('disk', 8);
    % % % K2(K2<190)=0;
    % % % K2_imd=imdilate(K2,se);
    % % % % figure, imshow(K1,[]);
    % % % BWao1(K2_imd~=0)=0;
    % % % Bwao2 =bwareaopen(BWao1, 1000);
    % 
    % T1=imread('
    % [I_SSD,I_NCC]=template_matching(T1,BWao);
    % I_SSD(:) = (I_SSD - min(I_SSD(:)))*255/(max(I_SSD(:))- min(I_SSD(:)));
    % I_SSD(I_SSD<185)=0;
    % se_template = strel('disk', 15);
    % k2=imdilate(I_SSD,se_template);
    % BWao(k2~=0)=0;


%     BWaopened =bwareaopen(BWao, 1000);


    % figure, imshow( bwareaopen(BWao, 3600), []);



    [B,L] = bwboundaries(BWaopened, 'noholes');
    lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area');
    neg_angle_chattered_const = ...
        ([lb_prop.Orientation] < -13) & ([lb_prop.Orientation] > -15) & ([lb_prop.Eccentricity] > 0.960);
    pos_angle_chattered_const = ...
        ([lb_prop.Orientation] < 81) & ([lb_prop.Orientation] > 71) & ([lb_prop.Eccentricity] > 0.960);
    denoise_selection = neg_angle_chattered_const|pos_angle_chattered_const;
    member_selected = ismember(L,find(denoise_selection));  
    BWaopened( member_selected == 1 ) = 0;
    % BWaopened=bwareaopen(BWaopened,2800);


    % % % % % 
    % % % % % T2=BWaopened(1660:1720,2730:2830,:);
%     T2=imread('/Users/Robert/Desktop/test_data_1202/images_report/template1.png');
%     [I_SSD,I_NCC]=template_matching(T2,BWaopened);
%     I_SSD(:) = (I_SSD - min(I_SSD(:)))*255/(max(I_SSD(:))- min(I_SSD(:)));
%     I_SSD(I_SSD<180)=0;
%     se_template = strel('disk', 50);
%     K3=imdilate(I_SSD,se_template);
%     BWaopened(K3~=0)=0;
%     % figure, imshow(BWaopened,[]);
%     BWaopened_modified= bwareaopen(BWaopened,2500);
    % % % % % 
    % % % % % 
    % % % % % % se90 = strel('line', 50, 90);
    % % % % % % se0 = strel('line', 50, 0);
    % % % % % BWsdil = imdilate(BWs, [se90 se0]);
    % % % % % figure, imshow(BWsdil), title('dilated gradient mask');
    % % % % % % seD = strel('diamond',2);BWdfill = imfill(BWsdil, 'holes');
    % % % % % % BWfinal = imerode(BWdfill,seD);
    % % % % % % figure, imshow(BWfinal,[]);

    BWaopened=bwareaopen(BWaopened,20000);



    %%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW
    %%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW%%% PLEASE REFINE THIS BELOW

    [B,L] = bwboundaries(BWaopened, 'noholes');
    lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area');
    area_const = ([lb_prop.Area] < 100000);
    denoise_selection = area_const;
    member_selected = ismember(L,find(denoise_selection));  
    BWaopened( member_selected == 1 ) = 0;

    BWsdil = imdilate(BWaopened, strel('disk',50));
    BWdfill = imfill(BWsdil, 'holes');
    seD = strel('diamond',6);
    BWfinal = imerode(BWdfill,seD);

    BWoutline = bwperim(BWfinal);
    Segout = I;

    Segout(BWoutline) = 255;
    figure, imshow(Segout), title('outlined original image');
end

