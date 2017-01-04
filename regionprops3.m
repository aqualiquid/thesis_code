function output = regionprops3( img_input, varargin )
% regionprops3 measures the geometric properties of image objects in 
%  3D space. Objects are defined as connected pixels in 3D. This function 
%  uses regionprops to get pixellist from the binary image. If you'd like
%  to define objects connectivity on our own, use bwlabeln first. 
% 
%  output = regionprops3(img_img_input_img_input,properties) takes 3-D binary image or output 
%  from bwlabeln and returns measurement as specified by properties. If no
%  property is specified, the function will return all measurements by 
%  default.
%
%  output = regionprops3(img_img_input_img_input,'IsPixList', properties) takes an M x 3 matrix of
%  pixell list as img_input and returns measurements. 
%  
%  Properties can be a comma-separated list of strings such as: 
% 
%  'MajorAxis' : returns a unit vector thafet points in the
%  direction of the major axis
%  
%  'MajorAxisLength' : returns the length of the major axis
%
%  'Centroid' : returns the centroid of the object
%
%  'AllAxes' : returns measurements of all three principal axes of image
%   objects, including axis directions, eigenvalues and axis lengths, all
%   organized in descending axis length. 
%  
%  'Eccentricity' : returns Meriodional Eccentricity, defineds as the 
%   eccentricity of the section through the longest and the shortest axes
%   and Equatorial Eccentricity, defined as the eccentricity of the 
%   section through the second longest and the shortest axes. 
%  
%  Version 1.1.1
%  Copyright 2014 Chaoyuan Yeh

% addpath
basedpath   = ['.' filesep 'stat_measure' filesep];
addpath(basedpath);    

if sum(strcmpi(varargin,'IsPixList'));
    if isstruct(img_input)
        pixList = img_input;
    elseif length(size(img_input))== 2 && size(img_input,2) == 3;
        pixList.pixList = img_input;
    else
        error('Pixel list should be either an Mx3 matrix or a structured array of Mx3 matrix');
    end
else
    
%     [CC50 L50]= bwboundaries(img_input, 'noholes');
    
    CC = bwconncomp(img_input);
    pixList = regionprops(CC, 'PixelList');
%     area3D = regionprops(CC,  'Area');
    cc_stat = regionprops(CC, img_input, 'PixelList','Area', 'PixelList','PixelIdxList', ...
        'MaxIntensity', 'MeanIntensity','MinIntensity', 'PixelValues', 'Image');

end

flag = false;
if numel(varargin)-sum(strcmpi(varargin,'IsPixList')) == 0, flag = true; end
if ~isstruct(pixList), pixList.PixelList = pixList; end

for ii = 1:length(pixList)
    pixs = struct2array(pixList(ii));
    covmat = cov(pixs);
    [eVectors, eValues] = eig(covmat);
    eValues = diag(eValues);
    [eValues, idx] = sort(eValues,'descend');
    
%     if flag || sum(strcmpi(varargin,'MajorAxis')) 
%         output(ii).MajorAxis = eVectors(:,idx(1))';
%     end
    
    if flag || sum(strcmpi(varargin,'MajorAxisLength'))
        distMat = sum(pixs.*repmat(eVectors(:,idx(1))',size(pixs,1),1),2);
        output(ii).MajorAxisLength = range(distMat);
    end
    
%     if flag || sum(strcmpi(varargin,'AllAxes')) 
% %         output(ii).FirstAxis = eVectors(:,idx(1))';
% %         output(ii).SecondAxis = eVectors(:,idx(2))';
% %         output(ii).ThirdAxis = eVectors(:,idx(3))';
% %         output(ii).EigenValues = eValues'; 
%         distMat = sum(pixs.*repmat(eVectors(:,idx(1))',size(pixs,1),1),2);
%         output(ii).FirstAxisLength = range(distMat);
%         distMat = sum(pixs.*repmat(eVectors(:,idx(2))',size(pixs,1),1),2);
%         output(ii).SecondAxisLength = range(distMat);
%         distMat = sum(pixs.*repmat(eVectors(:,idx(3))',size(pixs,1),1),2);
%         output(ii).ThirdAxisLength = range(distMat);
%     end
    
%     if flag || sum(strcmpi(varargin,'Centroid')) 
%         output(ii).Centroid = mean(pixs,1);
%     end
    
%     if flag || sum(strcmpi(varargin,'Eccentricity'))
%         output(ii).MeridionalEccentricity = sqrt(1-(eValues(3)/eValues(1))^2);
%         output(ii).EquatorialEccentricity = sqrt(1-(eValues(3)/eValues(2))^2);
%     end
    
    %WK implementation
    if flag || sum(strcmpi(varargin,'PixelList'))
        output(ii).PixelList =pixList(ii).PixelList;
    end
    
    if flag || sum(strcmpi(varargin,'Area'))
        output(ii).Area  =cc_stat(ii).Area;
    end
    
%     if flag || sum(strcmpi(varargin,'PixelIdxList')) 
%         output(ii).PixelIdxList = cc_stat(ii).PixelIdxList;
%     end
    
    if flag || sum(strcmpi(varargin,'MaxIntensity')) 
        output(ii).MaxIntensity = cc_stat(ii).MaxIntensity;
    end
    
%     if flag || sum(strcmpi(varargin,'MinIntensity')) 
%         output(ii).MinIntensity = cc_stat(ii).MinIntensity;
%     end
%     
    if flag || sum(strcmpi(varargin,'MeanIntensity')) 
        output(ii).MeanIntensity = cc_stat(ii).MeanIntensity;
    end
    
    if flag || sum(strcmpi(varargin,'PixelValues')) 
        output(ii).std2PixelIntensity = std2(cc_stat(ii).PixelValues);
    end
    
    %%%%%3D property 
    %(surface)
%     if flag || sum(strcmpi(varargin,'Surface3D')) 
%         output(ii).Surface3D = imSurface(cc_stat(ii).Image);
%     end
    
%     if flag || sum(strcmpi(varargin,'Surface3Ddensity')) 
%         output(ii).Surface3Ddensity = imSurfaceDensity(cc_stat(ii).Image);
%     end
%     
%     if flag || sum(strcmpi(varargin,'Surface3Destimate')) 
%         output(ii).Surface3Destimate = imSurfaceDensity(cc_stat(ii).Image);
%     end

    
     %(Mean breadth)
%     if flag || sum(strcmpi(varargin,'MeanBreadth')) 
%         output(ii).MeanBreadth = imMeanBreadth(cc_stat(ii).Image);
%     end
% 
%     if flag || sum(strcmpi(varargin,'MeanBreadthEstimate')) 
%         output(ii).MeanBreadthEstimate = imMeanBreadthDensity(cc_stat(ii).Image);
%     end
%     
%     if flag || sum(strcmpi(varargin,'MeanBreadthDensity')) 
%         output(ii).MeanBreadthDensity = imMeanBreadthEstimate(cc_stat(ii).Image);
%     end
%     
%     
%     % Euler 3D
%     if flag || sum(strcmpi(varargin,'Euler3D')) 
%         output(ii).Euler3D = imEuler3d(cc_stat(ii).Image);
%     end
    
    % TIME TAKING PROCESS BELOW!!
    % Centerline Length, this is came from centerline_example
    if flag || sum(strcmpi(varargin,'LengthCenterline')) 
        output(ii).LengthCenterline = LengthCenterln(cc_stat(ii), img_input);
    end
    
%     
%     if flag || sum(strcmpi(varargin,'Vascular')) 
%    
%         figure(108), imshow3D(cc_stat(ii).Image);  
%         figure(199), imshow(mean(img_input,3));
%         streamline({cc_stat(ii).PixelList})
%         x = input('Do you think this is Vascualr? (TRUE(1)/FALSE(0)) ');
%         if x==1
%             result= 'true';
%         elseif x==0
%             result= 'false';
%         else
%             fprintf(1,'Invalid input at index number of %d \n ', ii);
%             x=null;
%         end
%   
%         output(ii).Vascular = result;
%         
%         
%         % ask continue
%         continue_ask = input('Continue? (Y(1)/N(0))');
%         if continue_ask==1
%             continue;
%         elseif continue_ask==0
%             return;
%         else
%             fprintf(1,'Invalid end point \n');
%         end
%     end





%     if flag || sum(strcmpi(varargin,'Euler3Ddensity')) 
%         output(ii).Euler3Ddensity = imEuler3dDensity(cc_stat(ii).Image);
%     end
%     
%     if flag || sum(strcmpi(varargin,'Euler3Destimate')) 
%         output(ii).Euler3Destimate = imEuler3dEstimate(cc_stat(ii).Image);
%     end    

     %(volume)
%     if flag || sum(strcmpi(varargin,'Volume3D')) 
%         output(ii).Volume3D = imVolume(cc_stat(ii).Image);
%     end
    
%     if flag || sum(strcmpi(varargin,'Volume3Ddesity')) 
%         output(ii).Volume3Ddesity = imVolumeDensity(cc_stat(ii).Image);
%     end
% 
%     if flag || sum(strcmpi(varargin,'Volume3Destimate')) 
%         output(ii).Volume3Destimate = imVolumeEstimate(cc_stat(ii).Image);
%     end
    

end

