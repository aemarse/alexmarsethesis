function [thePkVal, thePkLoc, onLoc, offLoc] = peakPick2(sig, params)

%-NEXT STEPS
%--implement minPkDist and minPkHt to improve peak picking
%--incoporate w/ sineMod2
%--do 1st derivative

%--------------------------------------------------------------------------
%                         Set the parameters
%--------------------------------------------------------------------------
currUp   = 0;
pastUp   = 0;
numPeaks = params.feat.numPeaks;
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

[thePkLoc I J] = unique(thePkLoc);
thePkVal       = thePkVal(I);

% backCnt = 1;
% forwCnt = 1;

enPerc = 15;
thresh = enPerc/100;

%-Now, figure out the onset and offset times for each peak
for i = 1:length(thePkLoc)
    
    onBool  = 0;
    offBool = 0;
    backCnt = 1;
    forwCnt = 1;
    currLoc = thePkLoc(i); %-Current peak location
    currVal = thePkVal(i); %-Current peak value
    
%     %-Until the onset and offset have been found
%     while (onBool == 0) && (offBool == 0)
%         
%         %-Break if we exceed the bounds of the original signal
%         if (currLoc - backCnt < 1) || (currLoc + forwCnt > length(sig))
%             break;
%         end
%         
%         %-If the onset loc still has not been found
%         if onBool == 0
%             %-Look back for the onset time
%             backVal = sig(currLoc-backCnt);
%         end
%         
%         %-If the onset loc still has not been found
%         if offBool == 0
%             %-Look forward for the onset time
%             forwVal = sig(currLoc+forwCnt);
%         end
%         
%         %-If the possible onset val < energy threshold (1/3 energy of peak)
%         if abs(backVal/currVal) <= thresh
%             onLoc(i)  = currLoc-backCnt; %-Set the onset location
%             onBool    = 1; %-Set the onset bool
%         end
%         
%         %-If the possible offset val < energy threshold (1/3 energy of peak)
%         if abs(forwVal/currVal) <= thresh
%             offLoc(i) = currLoc+forwCnt; %-Set the offset location
%             offBool   = 1; %-Set the offset bool
%         end
%         
%         %-Increment the counters
%         backCnt = backCnt + 1;
%         forwCnt = forwCnt + 1;
%         
%     end

%-Until the onset and offset have been found
    while (onBool == 0) || (offBool == 0)
        
        %-If we are still inside the start bound of the original signal
        if (currLoc - backCnt >= 1)
            %-If the onset loc still has not been found
            if onBool == 0
                %-Look back for the onset time
                backVal = sig(currLoc-backCnt);
                
                %-Zero crossing onset
%                 if backVal<=0
%                     zOnLoc(i) = currLoc-backCnt;
%                 end
                
                %-If the possible onset val < energy threshold (1/3 energy of peak)
                if abs(backVal/currVal) <= thresh
                    onLoc(i)  = currLoc-backCnt; %-Set the onset location
                    onBool    = 1; %-Set the onset bool
                end
            end
        end
        
        %-If we are still inside the end bound of the original signal
        if (currLoc + forwCnt <= length(sig))
            %-If the onset loc still has not been found
            if offBool == 0
                %-Look forward for the onset time
                forwVal = sig(currLoc+forwCnt);
         
                %-Zero crossing offset
%                 if forwVal<=0
%                     zOffLoc(i) = currLoc+forwCnt;
%                 end
                
                %-If the possible offset val < energy threshold (1/3 energy of peak)
                if abs(forwVal/currVal) <= thresh
                    offLoc(i) = currLoc+forwCnt; %-Set the offset location
                    offBool   = 1; %-Set the offset bool
                end
            end
        end
        
        %-Increment the counters
        backCnt = backCnt + 1;
        forwCnt = forwCnt + 1;
        
    end
    
end

% onLoc(onLoc==0)   = NaN;
% offLoc(offLoc==0) = NaN;

% offLoc = 0;

%-Get rid of the peaks 
% newPkCnt = 1;
% 
% for i = 2:2:length(pkLoc)
%     
%     pkDist = pkLoc(i) - pkLoc(i-1);
%     
%     %-If the peaks are too close together
%     if pkDist < minDist
%         
%         %-Count the one that is larger
%         if pkVal(i) > pkVal(i-1)
%             thePkLoc(newPkCnt) = pkLoc(i);
%             thePkVal(newPkCnt) = pkVal(i);
%         else
%             thePkLoc(newPkCnt) = pkLoc(i-1);
%             thePkVal(newPkCnt) = pkVal(i-1);
%         end
%         
%         newPkCnt = newPkCnt + 1;
%         
%     end
%     
% end

%-Sort the peaks by their values
% [pkVals, pkLocs] = sort(pkVal,'descend');

%-Save the proper number of peaks
% peaks = pkVals(1:numPeaks);
% locs  = pkLoc(pkLocs(1:numPeaks));

% plot(sig); hold on; plot(locs, peaks, 'rx');

end