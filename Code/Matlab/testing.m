%-NEXT STEPS
%--implement minPkDist and minPkHt to improve peak picking
%--incoporate w/ sineMod2

load('/Users/aemarse/Documents/devel/Thesis/Code/Matlab/testing.mat');

currUp = 0;
pastUp = 0;
currDn = 0;
pastDn = 0;

pkCnt = 1;

for i = 1:length(xFFT)
    
    currVal = xFFT(i);
    
    if i == 1
        pastVal = currVal;
        continue;
    end
    
    if currVal >= pastVal
        currUp = 1;
        currDn = 0;
    elseif currVal < pastVal && pastUp == 1
        currUp = 0;
        currDn = 1;
        pkLoc(pkCnt)  = i-1;
        pkVal(pkCnt)  = xFFT(i-1);
        pkCnt = pkCnt + 1;
    end
    
    pastVal = currVal;
    pastUp  = currUp;
    pastDn  = currDn;
    
end

% [pkVals, pkLocs] = sort(pkVal,'descend');
% 
% topPks = peaks();

plot(xFFT); hold on; plot(pkLoc, pkVal, 'rx');

blah = 0;