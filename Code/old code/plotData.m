function [] = plotData(sig, features, params)

% try
%     [sig fs] = wavread(filename);
% catch
%     sprintf('Could not read in file %s\nDeleting...', filename)
%     delete(filename);
%     delete(sprintf('%s%s', filename(1:end-3), 'mat'));
%     return
% end
clf
close all

%--------------------------------------------------------------------------
%                               Plot RMS
%--------------------------------------------------------------------------
figure('name', params.file.filename)

numPlots = length(features) - 1;

subplot(3,1,1), plot(sig); ...
    axis tight; ...
    xlabel('Time'); ...
    ylabel('Amplitude');...
    title('Signal');

subplot(3,1,2), plot(features.RMS); ...
    axis tight; ...
    xlabel('Time'); ...
    ylabel('Intensity');...
    title('RMS');

subplot(3,1,3), plot(features.ZCR); ...
    axis tight; ...
    xlabel('Time'); ...
    ylabel('# ZCs per sec');...
    title('ZCR');

%--------------------------------------------------------------------------
%                               Plot FFT
%--------------------------------------------------------------------------

[S, F, T] = spectrogram(sig, params.win.N, params.win.H, params.win.Nfft);

S = 20*log10(abs(S)+eps);
% S = abs(S);

temp = floor(size(S,1)/2);

S = S(1:temp,:);

F = F/abs(max(F))*params.file.fs;

F = F(1:temp);

figure('name', params.file.filename)
imagesc(T, F, S)
axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')
title('Log magnitude spectrum')


%---BLAH----
% Nfft = params.Nfft;

% F = [0 : Nfft - 1] / Nfft;
% plot(F, abs(FFT));

% X = fftshift(features.FFT(1,:));
% F = [-Nfft/2:Nfft/2-1]/Nfft;
% plot(F,X),
% xlabel('frequency / f s')

% T = features.SPEC.T;
% F = features.SPEC.F;
% S = features.SPEC.S;

end