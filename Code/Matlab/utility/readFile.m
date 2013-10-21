function [sig fs filename] = readFile(filename, dataSet)

%--------------------------------------------------------------------------
%                         ABOUT THIS FUNCTION
%--------------------------------------------------------------------------
%-Written by Alex Marse (2013)

%-USAGE EXAMPLE:
%-[sig fs fileName] = readFile(filename, dataSet);

%-FUNCTIONALITY
%-This function will take a filename and dataSet as input, find the file,
%-and read in the file.

%-INPUTS
%-filename : the filename of the file to be read
%-dataSet  : the data set in which to find the file ('freesound', 'xeno_canto')

%-OUTPUTS
%-sig      : the signal
%-fs       : the sampling rate
%-filename : the filename w/ its full path (including directories)

%--------------------------------------------------------------------------
%                            Find the file
%--------------------------------------------------------------------------

%-Make the fileDir
fileDir  = ['/Volumes/ALEX/data/' dataSet '/'];

%-Get the folders in the dir
a = dir(fileDir);

b = struct2cell(a);

%-Start with the 4th, as the first 3 are hidden folders
for i = 4:size(b,2)
    tempDir = [fileDir b{1,i} '/'];
    
    x = struct2cell(dir(tempDir));
    
    for h = 1:size(x,2)
        if strcmp(x{1,h}, filename) %-Look for a matching filename
            theDir = tempDir; %-Save the directory the file is in
        end
    end
end

filename = sprintf('%s%s', theDir, filename); %-Make the full file name

if strcmp(filename(end-2:end), 'mp3')
    try
        [sig fs] = mp3read(filename); %-Attempt to read in the file
    catch
        r = removeFile(filename); %-If read fails, remove the file
        return
    end
elseif strcmp(filename(end-2:end), 'wav')
    try
        [sig fs] = wavread(filename);
    catch
        r = removeFile(filename);
        return
    end
else
    sprintf('Couldn''t read the file, for some unknown reason...must be a ghost!')
    return
end

end