function [] = plotData(filename, N, hopSize, fftSize)

try
    [sig fs] = wavread(filename);
catch
    sprintf('Could not read in file %s\nDeleting...', filename)
    delete(filename);
    delete(sprintf('%s%s', filename(1:end-3), 'mat'));
    return
end

[T, F, sFinal] = getSpectrum(sig, N, hopSize, fftSize);

figure
imagesc(T, F, sFinal)
axis xy, colormap(jet), ylabel('Frequency'), xlabel('Time')

end