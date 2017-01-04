function [ modified_img ] = region_properties( input_img )
   
    modified_img = input_img;
    % these angles indicate 
    zero_angle = 0;
    maxAngle = -9;     %% PREVIOUSLY -10
    minAngle = -16;     %% PREVIOUSLY -19
    minSize = 2;
    maxSize =round((size(input_img,1)^2)/25);
    ltdEccentric = 0.9980;
    sloopy_Ecc = 0.9800;
    solidity_const= 0.55;
%     lmt_covx_percentage=0.62;

    [B,L] = bwboundaries(input_img,'noholes');
    lb_prop = regionprops(L, 'Solidity', 'PixelList', 'Orientation', 'Eccentricity', 'ConvexArea', 'Area');

% % % PREVIOUSLY     angle_constraint = ([lb_prop.Orientation]==zero_angle | [lb_prop.Orientation] < maxAngle) & ([lb_prop.Orientation] > minAngle);
    angle_zero_constraint = ([lb_prop.Orientation]==zero_angle);
    angle_chattered_const = ([lb_prop.Orientation] < maxAngle) & ([lb_prop.Orientation] > minAngle) & ([lb_prop.Eccentricity] > sloopy_Ecc);
    ecc_constraint = ([lb_prop.Eccentricity]> ltdEccentric);
    size_constraint = ([lb_prop.Area] < minSize | [lb_prop.Area] > maxSize);

    % Solidity equals 1 means that shape looks like rectanguar 
    % Solidity is ([lb_prop.Area]/[lb_prop.ConvexArea])
    solidity_constraint = ([lb_prop.Solidity] == 1.00 | [lb_prop.Solidity] < solidity_const);

    constraint = (angle_zero_constraint | ecc_constraint | size_constraint | ...
            solidity_constraint | angle_chattered_const); 
    denoise_selection = constraint;
    member_selected = ismember(L,find(denoise_selection));  

    
    modified_img( member_selected == 1 ) = 0;
end
