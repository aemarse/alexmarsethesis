function [] = convToWav()

sndDir = '/Volumes/ALEX/data/xeno_canto/';
theDir = sprintf('%s/*.mp3',sndDir);
mp3s   = dir(theDir);

for i = 1:length(mp3s)

    filename = sprintf('%s%s', sndDir, mp3s(i).name);
    
    try
        [sig fs, nbits] = mp3read(filename);
    catch
        disp(sprintf('%s could not be read', filename))
        delete(filename);
        delete(sprintf('%s%s', filename(1:end-3), 'mat'));
    end
    
    newName = [filename(1:end-3) 'wav'];
    
    sprintf('Writing %s', newName)
    wavwrite(sig, fs, nbits, newName);
    
    delete(filename);

end

end