function [] = convToWav()

theDir = sprintf('%s/*.mp3',pwd);
mp3s   = dir(theDir);

for i = 1:length(mp3s)

    filename = mp3s(i).name;
    
    try
        [sig fs, nbits] = mp3read(filename);
    catch
        sprintf('%s could not be read', filename)
        delete(filename);
        delete(sprintf('%s%s', filename(1:end-3), 'mat'));
    end
    
    newName = [filename(1:end-3) 'wav'];
    
    wavwrite(sig, fs, nbits, newName);
    
    delete(filename);

end

end