% function [ net, pr ] = gen_ANN(xlsfileTP, xlsfileFP, numOfHidden)
 function [ net, pr ] = gen_ANN(xlsfileTP, numOfHidden)
% generating ANN
    
    % Define range 
    xlRange = 'A:Q';
    xlTrgRange = 'R:R';
    
    % generating fitnet
    net = fitnet(numOfHidden, 'trainlm');
    net.divideParam.trainRatio = .7;    
    net.divideParam.valRatio = .20; %.20
    net.divideParam.testRatio = .20; %.20
    
    % fetch Input from xls
    [numTP, txtTP, rawTP] =xlsread(xlsfileTP, 'Sheet1', xlRange);
    [numTargetTP, txtTargetTP, rawTargetTP] =xlsread(xlsfileTP,'Sheet1', xlTrgRange);
%     % fetch Target from xls
%     [numFP, txtFP, rawFP] =xlsread(xlsfileFP, 'Sheet1', xlRange);
%     [numTargetFP] =xlsread(xlsfileFP, 'Sheet1', xlTrgRange);
    
%     % concatenating matrices
%     matInput = [numTP; numFP];
%     matTarget = [numTargetTP; numTargetFP];
    matInput = numTP;
    matTarget =numTargetTP;
  
    % Validation
    % if number of feature are not same as the number of number of target
    assert( (size(matInput,1) == size(matTarget,1)), 'number of feature vectors are not same as the number of target');
    
    % Otherwise, proceeed the process
    [net, pr] =train(net, matInput', matTarget');
    
    
    
    y = net(matInput');
    e =  matTarget' - y;
    figure, ploterrhist(e,'bins')
  
%     disp('');
% houseOutputs = net(houseInputs);
% trOut = net(pr.trainInd);
% vOut = net(pr.valInd);
% tsOut = net(pr.testInd);
% trTarg = net(pr.trainInd);
% vTarg = net(pr.valInd);
% tsTarg = net(pr.testInd);
% plotregression(trTarg,trOut,'Train',vTarg,vOut,'Validation',...
% tsTarg,tsOut,'Testing')
 end

 
 
 
 
% for i = 1:size(testxls,1)
%      for j=1:size(testxls_prev,1)
%          if (testxls(i,1) == testxls_prev(j,1)) &&(testxls(i,2) == testxls_prev(j,2))&& (testxls(i,5) == testxls_prev(j,5))
%              testxls(i,:) =testxls_prev(j,:);
%          end
%      end
% end
%  

