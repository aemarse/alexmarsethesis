function [F, dr1] = sineMod4(sig, params)

%-Params
N    = params.win.N;
H    = params.win.H;
Nfft = params.win.Nfft;
fs   = params.file.fs;

Nfft = 256;

%--------------------------------------------------------------------------
%                             Analysis
%--------------------------------------------------------------------------

S     = specgram(sig,Nfft);      % SP Toolbox routine (or use ifgram.m below)
[R,M] = extractrax(abs(S));      % find peaks in STFT *magnitude*
F     = R*fs/Nfft;               % Convert R from bins to Hz
tt    = [1:size(F,2)]*Nfft/2/fs; % default specgram step is NFFT/2 i.e. 128

%-Plot the spectrum and the extracted tracks
figure
subplot(2,1,1), specgram(sig,Nfft,fs);
hold on
plot(tt,F','r'); % the tracks follow the specgram peaks
xlabel('Time');ylabel('Frequency');title('Original spectrum w/ tracked peaks');

%--------------------------------------------------------------------------
%                            Resynthesis
%--------------------------------------------------------------------------

dr1 = synthtrax(F,M/64,fs,256,128); % Divide M by 64 to factor out window, FFT weighting
subplot(2,1,2), specgram(dr1,256,fs);
xlabel('Time');ylabel('Frequency');title('Resynthesized');
% sound(dr1,fs)
% sound(sig,fs)

end