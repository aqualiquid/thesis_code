function [ finalized_img ] = aNN_determine( img_3D, net)
    
% [net, pr] =gen_ANN(xlsfileTP, xlsfileFP, numOfHidden);

    temp_origin_img=img_3D;
    
    % Classification
    classificationCRT = 0.3; 
    CC = bwconncomp(img_3D);
    lb_prop = regionprops3(img_3D);

    
    % rendering sample
    for i=1: (CC.NumObjects)
        % initializing the sample matrix
        sample=[];
        outputSample=0;
        
        % VERY IMPORTANT, sequence is very crucial
        sample =[ lb_prop(i).MajorAxisLength, lb_prop(i).FirstAxisLength, lb_prop(i).SecondAxisLength, lb_prop(i).ThirdAxisLength, ...
            lb_prop(i).MeridionalEccentricity, lb_prop(i).EquatorialEccentricity, lb_prop(i).Area, lb_prop(i).MaxIntensity, ...
            lb_prop(i).MeanIntensity, lb_prop(i).std2PixelIntensity, lb_prop(i).Surface3D, ...
            lb_prop(i).Surface3Ddensity, lb_prop(i).Surface3Destimate, lb_prop(i).MeanBreadth, lb_prop(i).MeanBreadthEstimate, ...
            lb_prop(i).MeanBreadthDensity, lb_prop(i).Euler3D];
       
% load simplecluster_dataset
% net = patternnet(20);
% net = train(net,simpleclusterInputs,simpleclusterTargets);
% simpleclusterOutputs = sim(net,simpleclusterInputs);
% plotroc(simpleclusterTargets,simpleclusterOutputs)
     
        outputSample = net(sample')';
        if (outputSample< classificationCRT)
            % find current labled region and make them 0(BLACK)
            fprintf(1,'cc_stat row of %d is deleted. \n', i);
            img_3D(CC.PixelIdxList{i})=0;         
        end
    end
    finalized_img=img_3D;
end

