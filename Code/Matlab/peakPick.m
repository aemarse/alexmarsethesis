function [peaks, locs] = peakPick(FFT, params)

%-NEXT STEPS
%--implement minPkDist and minPkHt to improve peak picking
%--incoporate w/ sineMod2
%--do 1st derivative

%--------------------------------------------------------------------------
%                         Set the parameters
%--------------------------------------------------------------------------
currUp   = 0;
pastUp   = 0;
currDn   = 0;
pastDn   = 0;
numPeaks = params.feat.numPeaks;
pkCnt    = 1;

%Initialize the values
pkLoc = 0;
pkVal = 0;

%--------------------------------------------------------------------------
%                           Find the peaks
%--------------------------------------------------------------------------

%-Loop through the fft frames
for i = 1:length(FFT)
    
    %-Grab the current value
    currVal = FFT(i);
    
    %-Make it so that we can look back
    if i == 1
        pastVal = currVal;
        continue;
    end
    
    %-Determine whether the current value is a peak
    if currVal >= pastVal
        currUp = 1;
        currDn = 0;
    elseif currVal < pastVal && pastUp == 1
        currUp       = 0;
        currDn       = 1;
        pkLoc(pkCnt) = i-1; %-Save the peak location
        pkVal(pkCnt) = FFT(i-1); %-Save the peak value
        pkCnt        = pkCnt + 1; %-Increment the peak counter
    end
    
    %-Save the current values as past values for the next iteration
    pastVal = currVal;
    pastUp  = currUp;
    pastDn  = currDn;
    
end

%-Sort the peaks by their values
[pkVals, pkLocs] = sort(pkVal,'descend');

%-Save the proper number of peaks
peaks = pkVals(1:numPeaks);
locs  = pkLoc(pkLocs(1:numPeaks));

% plot(FFT); hold on; plot(locs, peaks, 'rx');

end