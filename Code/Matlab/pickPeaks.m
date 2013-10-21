function [onsetBool, thePkLoc, thePkVal] = pickPeaks(sig, params)

numFrames = params.numFrames;

%-Initialize parameters
currUp   = 0;
pastUp   = 0;
pkCnt    = 1;
pkCnt1   = 1;
minDist  = params.fs*40/1000; %-the min distance b/t peaks

%-Initialize peak values
pkLoc     = 0;
pkVal     = 0;
onsetBool = zeros(1,numFrames);

for i = 1:numFrames
   
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
        
        currUp       = 0; %-Set the current direction
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

onsetBool(thePkLoc) = 1; %-Save the onsetBool

end