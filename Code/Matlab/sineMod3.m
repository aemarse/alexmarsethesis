function [] = sineMod3(sig, params)

%-Params
N    = params.win.N;
H    = params.win.H;
Nfft = params.win.Nfft;
fs   = params.file.fs;

%-Get the spectrogram
[S,F,T,P] = spectrogram(sig, N, N-H, Nfft, fs);

S = abs(S); %-take the magnitude spectrum

%-Plot the spectrogram
% imagesc(T, F, S)
% axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')

% F1 = F*513/22050; %-normalize F to be in terms of bin numbers

NS = 1; %-num of syllables

numFrames = size(S,2);

cont = 1;
forw = 1;
back = 1;

%-Loop through num of time frames
% for i = 1:numFrames
    
    for h = 1:NS
    
        [amp idx] = max(max(S));
        
        Wn(1) = idx;
        An(1) = 20*log10(amp);
        
        curr = idx;
        forw = curr + 1;
        back = curr - 1;
        
        while cont == 1
            
            if forw < size(S,2)
                forw = forw + 1;
            elseif back > 0
                back = back - 1;
            else
                cont == 0;
            end
            
        end
        
    end
    
    
%     %-Loop through the number of syllables
%     for h = 1:NS
%         
%         [amp bin] = max(S(:,i)); %-Get the max amp value and its bin #
%         
%         Fn(h) = F(bin); %-Store the freq val for the max bin
%         Tn(h) = T(bin); %-Store the time val for the max bin
%         
%         Wn(1) = Fn(h); %-Frequency
%         An(1) = 20*log10(S(bin,i)); %-Amplitude
% 
%         
%    
%     end
    

% end

figure
plot(Fn);

end