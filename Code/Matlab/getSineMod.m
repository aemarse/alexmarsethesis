function [freqs, amps] = getSineMod(onSpec, magSpec, params, onsets)

numOnFrames = params.numOnFrames;
numFrames   = size(magSpec,1);

freqs = zeros(numOnFrames,1);
amps  = zeros(numOnFrames,numFrames);

onLoc = onsets.rms.thePkLoc;

TdB = 30; %-Threshold

for i = 1:numOnFrames

    [amp loc] = max(magSpec(onLoc(i),:)); %-Get the max
    
    Wn(1) = loc;           %-Save the initial freq bin
    An(1) = 20*log10(amp); %-Save the initial amplitude
    
    freqs(i) = Wn(1);
    
    %-Bools
    tsBool = 0;
    teBool = 0;
    
    %-Counters
    back   = 1;
    forw   = 1;
    
    %-While either of them is still unset
    while tsBool == 0 || teBool == 0
        
        %-If still within start bound
        if onLoc(i) - back >= 1
            
            %-Get the amplitude of Wn(1) of the forw frame
            ampBack = 20*log10(magSpec(onLoc(i)-back,Wn(1)));
            
            %-Save the amplitude at that location
            amps(i,onLoc(i)-back) = ampBack;
            
            %-If the amplitude at this forward location is beneath thresh
            if ampBack < An(1) - TdB
                ts(i)  = onLoc(i) - back; %-Save the start time
                tsBool = 1; %-Set boolean when we find ts
            end
            
            back = back + 1; %-Increment the back counter
            
        else
            tsBool = 1; %-Make sure we don't have an infinite loop
        end
        
        %-If still within ending bound
        if onLoc(i) + forw <= numFrames
            
            %-Get the amplitude of Wn(1) of the back frame
            ampForw = 20*log10(magSpec(onLoc(i)+forw,Wn(1)));
            
            %-Save the amplitude at that location
            amps(i,onLoc(i)+forw) = ampForw;
            
            %-If the amplitude at this forward location is beneath thresh
            if ampForw < An(1) - TdB
                te(i)  = onLoc(i) + forw; %-Save the start time
                teBool = 1; %-Set boolean when we find te
            end
            
            forw = forw + 1; %-Increment the forward counter
            
        else
            teBool = 1; %-Make sure we don't have an infinite loop
        end
        
    end

end

end