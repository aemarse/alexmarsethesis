function [] = plotData(sig, features, params, fs)

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
figure
subplot(2,1,1), plot(sig); ...
    axis tight; ...
    xlabel('Time'); ...
    ylabel('Amplitude');...
    title('Signal');

subplot(2,1,2), plot(features.RMS); ...
    axis tight; ...
    xlabel('Time'); ...
    ylabel('Intensity');...
    title('RMS');


%--------------------------------------------------------------------------
%                               Plot FFT
%--------------------------------------------------------------------------

[S, F, T] = spectrogram(sig, params.N, params.H, params.Nfft);

S = log10(abs(S)+eps);

temp = floor(size(S,1)/2);

S = S(1:temp,:);

F = F/abs(max(F))*fs;

F = F(1:temp);

figure
imagesc(T, F, S)
axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')

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