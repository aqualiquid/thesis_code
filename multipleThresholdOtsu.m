function [ multi_thrsh ] = multipleThresholdOtsu(input_img, thrsh_lv )
%   Otsu's multiple threshold

    thresh = multithresh(input_img,thrsh_lv);
    multi_thrsh = imquantize(input_img,thresh);
%     multi_thrsh = mat2gray(multi_thrsh);

%     imshow(multi_thrsh, [])
end

