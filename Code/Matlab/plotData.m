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

T = features.SPEC.T;
F = features.SPEC.F;
S = features.SPEC.S;

% [T, F, sFinal] = getSpectrum(sig, N, hopSize, fftSize);

figure
imagesc(T, F, S)
axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')

end