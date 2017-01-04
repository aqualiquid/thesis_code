
% Pleaes run this code after 'maskstack.m'
clc;	% Clear command window.
clear;	% Delete all variables.
close all;	% Close all figure windows except those created by imtool.
imtool close all;	% Close all figure windows created by imtool.
%% read data
start=1; sort=[];
% basedpath = './research_images/';
basedpath   = ['..' filesep 'research_images' filesep];
FinalPath = strcat(basedpath, 'ground_truth_0409_comp', filesep);
final_path_FileList = strcat(FinalPath, 'raw_img', filesep, '*.png');
FileList = dir(final_path_FileList);
% number of FileList
N = size(FileList,1);
fprintf(1,'number of mask %d \n', round(N/1));

% for i=1:25:N
for i=1:N
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
folder = fullfile(strcat(FinalPath, 'raw_img'));
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
set(gcf, 'Position', get(0,'Screensize')/2); % Maximize figure.

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
            close all;
    end
end


imwrite(binaryImage, strcat(FinalPath,'bw_img/',strtok(target_filename, '.'), '.png'));