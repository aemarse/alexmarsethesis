function [freqs, amps] = getSineMod(onSpec, magSpec, params, onsets)

numOnFrames = params.numOnFrames;
numFrames   = size(magSpec,1);

onLoc = onsets.rms.thePkLoc;

TdB = 30;

for i = 1:numOnFrames

    [amp loc] = max(magSpec(onLoc(i),:));
    
    Wn(1) = loc;
    An(1) = 20*log10(amp);
    
    tsBool = 0;
    teBool = 0;
    back   = 1;
    forw   = 1;
    
    while tsBool == 0 || teBool == 0 %-While either of them is still unset
        
        %-If still within start bound
        if onLoc(i) - back >= 1
            %-Get the amplotude of Wn(1) of the forw frame
            ampBack = 20*log10(magSpec(onLoc(i)-back,Wn(1)));
            
            %-If the amplitude at this forward location is beneath thresh
            if ampBack < An(1) - TdB
                ts(i)  = onLoc(i) - back;
                tsBool = 1;
            end
            
            back = back + 1;
        else
            tsBool = 1;
        end
        
        %-If still within ending bound
        if onLoc(i) + forw <= numFrames
            %-Get the amplitude of Wn(1) of the back frame
            ampForw = 20*log10(magSpec(onLoc(i)+forw,Wn(1)));
            
            %-If the amplitude at this forward location is beneath thresh
            if ampForw < An(1) - TdB
                te(i)  = onLoc(i) + forw;
                teBool = 1;
            end
            
            forw = forw + 1;
        else
            teBool = 1;
        end
        
%         forw = forw + 1;
%         back = back + 1;
        
    end

end

freqs = 0;
amps  = 0;

end