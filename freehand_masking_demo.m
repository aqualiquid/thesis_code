
% Pleaes run this code after 'maskstack.m'
clc;	% Clear command window.
clear;	% Delete all variables.
close all;	% Close all figure windows except those created by imtool.
imtool close all;	% Close all figure windows created by imtool.
%% read data
start=1; sort=[];
% final_path_FileList ='../../0102NISSLDATA_RESIZED50p/resized_nissl/*.jpg';
basedpath = '../../0102NISSLDATA_RESIZED50p/';
% FinalPath = '../../0102NISSLDATA_RESIZED50p/resized_nissl/';
FinalPath = strcat(basedpath, 'resized_nissl/');
final_path_FileList = strcat(FinalPath, '*.png');
FileList = dir(final_path_FileList);
% number of FileList
N = size(FileList,1);
fprintf(1,'number of mask %d \n', round(N/50));

for i=1:50:N
    filename = char({FileList(i).name});  
    sort = [sort; num2str(filename)];
end

%% drawing
prompt = 'number that you want to extract? ';
x = input(prompt);
target_filename = sort(x,:);

% Change the current folder to the folder of this m-file.
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end

workspace;	% Make sure the workspace panel is showing.
fontSize = 16;

% Read in a standard MATLAB gray scale demo image.
% folder = fullfile(matlabroot, '\toolbox\images\imdemos');
folder = fullfile(FinalPath);
baseFileName = target_filename;
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
% Check if file exists.
if ~exist(fullFileName, 'file')
	% File doesn't exist -- didn't find it there.  Check the search path for it.
	fullFileName = baseFileName; % No path this time.
	if ~exist(fullFileName, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
grayImage = imread(fullFileName);
imshow(grayImage, []);
axis on;
title('Original Grayscale Image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Ask user to draw freehand mask.
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));
hFH = imfreehand(); % Actual line of code to do the drawing.
% message = sprintf('');
binaryImage = hFH.createMask();
% totMask = false(sz);
iter_flag = true;
while (iter_flag)
    % Construct a questdlg with three options
    choice = questdlg('Do you need more contour?', ...
        'Yes','No');
    % Handle response
    switch choice
        case 'Yes'
            hFH = imfreehand();
%             position = wait( hFH );
            binaryImage = binaryImage | hFH.createMask();
%             xy = hFH.getPosition;
    %         disp([choice ' coming right up.'])
    %         dessert = 1;
        case 'No'
            iter_flag = false;

            xy = hFH.getPosition;
    end
end


imwrite(binaryImage, strcat(basedpath,'contour/contour_',target_filename));