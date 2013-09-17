function [] = sinMod(sig, params)

% [S,F,T,P] = spectrogram(sig, params.N, params.N - params.H, params.Nfft);
% 
% S = 20*log10(abs(S)+eps);
% % S = abs(S);
% temp = floor(size(S,1)/2);
% S = S(1:temp,:);
% F = F/abs(max(F))*params.fs;
% F = F(1:temp);
% figure('name', params.filename)
% imagesc(T, F, S)
% axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')
% title('Log magnitude spectrum')

% N = size(S,2);
% 
% An = zeros(1,size(S,1));
% 
% T = 30;

numFrames = floor((length(sig) - (params.N - params.H)) / params.H);

startIdx = 1;
endIdx   = params.N;

for n = 1:numFrames
    
    FFT(:,n) = abs(fft(sig(startIdx:endIdx), params.Nfft));
    
    [maxVal maxLoc] = max(FFT(:,n));
    
    maxAmpDb(n) = 20*log10(maxVal);
    maxFreq(n)  = maxLoc;
    
    if n == 1
        [startIdx endIdx] = updateIdx(startIdx, endIdx, params.H);
        continue
    else
%         lookLeft(maxAmpDb, maxFreq, n, FFT);
    end
    
    [startIdx endIdx] = updateIdx(startIdx, endIdx, params.H);

    %{
    [Fn Tn] = max(abs(S(:,n)));
    
    Wn(1) = Tn;
    An(1) = 20*log10(abs(S(Tn,n)));
    
    t0 = Tn;
    t  = 1;
    
    sprintf('Wn = %d; An = %d; t0 = %d\n', Wn, An, t0)

    if t0 == 1
        continue
    else
        while An(t - t0) < An(1) - T

            [Fn Tn]    = max(abs(S(:,t0 - t)));
            An(t0 - t) = 20*log10(abs(S(Tn, n)));
            
            [Fn Tn]    = max(abs(S(:,t0 + t)));
            An(t0 + t) = 20*log10(abs(S(Tn, n)));

            t = t + 1;

        end
    end
    %}

end

% FFT = FFT(1:params.Nfft/2,:);

end

function [startIdx, endIdx] = updateIdx(startIdx, endIdx, H)

    startIdx = startIdx + H;
    endIdx   = endIdx + H;

end

function [] = lookLeft(amp, freq, n, FFT)

%     thresh = amp(n-1) - 30;

    temp = 20*log10(FFT(freq(n-1), n));
    

end