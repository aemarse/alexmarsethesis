function [thePkVal, thePkLoc, onLoc, offLoc] = runPeakPicker(sig, params)

%--------------------------------------------------------------------------
%                         ABOUT THIS FUNCTION
%--------------------------------------------------------------------------
%-Written by Alex Marse (2013), with concepts borrowed from 
%-Dr. Tae Hong Park

%-USAGE EXAMPLE:
%-[thePkVal thePkLoc onLoc offLoc] = runPeakPicker(rms, params);

%-FUNCTIONALITY
%-This function does some basic peak picking. It loops through a signal, 
%-finds the peak locations, and looks to the left and to the right of that
%-location to find the onset and offset locations.

%-INPUTS
%-sig: the detection function
%-params: this is a struct containing info on the signal, such as fs

%-OUTPUTS
%-thePkVl:  array of values of all the peaks found
%-thePkLoc: array of index locations of all the peaks found
%-onLoc:    array of locations of all the onsets found
%-offLoc:   array of locations of all the offsets found

%--------------------------------------------------------------------------
%                         Set the parameters
%--------------------------------------------------------------------------
currUp   = 0;
pastUp   = 0;
pkCnt    = 1;
pkCnt1   = 1;

minDist = params.file.fs*40/1000; %-the min distance b/t peaks
% minDist = 500;

%Initialize the values
pkLoc = 0;
pkVal = 0;

%--------------------------------------------------------------------------
%                           Find the peaks
%--------------------------------------------------------------------------

%-Loop through the frames
for i = 1:length(sig)
    
    %-Grab the current value
    currVal = sig(i);
    
    %-Make it so that we can look back
    if i == 1
        pastVal = currVal;
        continue;
    end
    
    %-Determine whether the current value is a peak
    if currVal >= pastVal
        currUp = 1; %-Set the current direction
    elseif currVal < pastVal && pastUp == 1
        
        currUp       = 0; %-Set the current directoin
        pkLoc(pkCnt) = i-1; %-Save the peak location
        pkVal(pkCnt) = sig(i-1); %-Save the peak value
        
        if pkCnt > 1 %-If we've got more than one peak to compare
            
            pkDist = pkLoc(pkCnt) - pkLoc(pkCnt-1); %-Get the distance b/t them
            
            if pkDist < minDist %-If the distance is lower than the minDist
                
                %-Figure out which one is larger
                if pkVal(pkCnt) > pkVal(pkCnt-1);
                    thePkVal(pkCnt1) = pkVal(pkCnt);
                    thePkLoc(pkCnt1) = pkLoc(pkCnt);
                else
                    thePkVal(pkCnt1) = pkVal(pkCnt-1);
                    thePkLoc(pkCnt1) = pkLoc(pkCnt-1);
                end
                
                pkCnt1 = pkCnt1 + 1;
            end
            
        end
        
        pkCnt = pkCnt + 1; %-Increment the peak counter
    end
    
    %-Save the current values as past values for the next iteration
    pastVal = currVal;
    pastUp  = currUp;
    
end

[thePkLoc I J] = unique(thePkLoc); %-Get rid of repeating values
thePkVal       = thePkVal(I);

enPerc = 15; %-The percent of peak energy to look for in an onset/offset
thresh = enPerc/100; %-Converts the percent to a threshold between 0-1

%-Loop through peaks and find the onset and offset times for each peak
for i = 1:length(thePkLoc)
    
    onBool  = 0; %-Initialize the onset boolean to 0
    offBool = 0; %-Initialize the offset boolean to 0
    backCnt = 1; %-Initialize the look-back counter to 1
    forwCnt = 1; %-Initialize the look-forward counter to 1
    
    currLoc = thePkLoc(i); %-Current peak location
    currVal = thePkVal(i); %-Current peak value

%-Until the onset and offset have been found (both bools == 1)
    while (onBool == 0) || (offBool == 0)
        
        %-If we are still inside the start bound of the original signal
        if (currLoc - backCnt >= 1)
            %-If the onset loc still has not been found
            if onBool == 0
                %-Look back for the onset time
                backVal = sig(currLoc-backCnt);
                
                %-If the possible onset val < energy threshold (1/3 energy of peak)
                if abs(backVal/currVal) <= thresh
                    onLoc(i)  = currLoc-backCnt; %-Set the onset location
                    onBool    = 1; %-Set the onset bool
                end
            end
        else
            %-If unable to find an onset for some reason
            onBool = 1; %-Just set the onset bool to 1 to end while loop
        end
        
        %-If we are still inside the end bound of the original signal
        if (currLoc + forwCnt <= length(sig))
            %-If the onset loc still has not been found
            if offBool == 0
                %-Look forward for the onset time
                forwVal = sig(currLoc+forwCnt);
                
                %-If the possible offset val < energy threshold (1/3 energy of peak)
                if abs(forwVal/currVal) <= thresh
                    offLoc(i) = currLoc+forwCnt; %-Set the offset location
                    offBool   = 1; %-Set the offset bool
                end
            end
        else
            %-If unable to find an offset for some reason
            offBool = 1; %-Just set the offset bool to 1 to end while loop
        end
        
        %-Increment the counters
        backCnt = backCnt + 1;
        forwCnt = forwCnt + 1;
        
    end
    
end

%-Do some min peak height thresholding to get rid of the tiny peaks
minHt     = 0.00025; %-Minimum peak height threshold
pkIdx     = find(thePkVal > minHt); %-Absolute threshold (temporarily)
thePkLoc  = thePkLoc(pkIdx); %-Pk location
thePkVal  = thePkVal(pkIdx); %-Pk value
onLoc     = onLoc(pkIdx); %-Onset location on RMS det func
offLoc    = offLoc(pkIdx); %-Offset location on RMS det func

end