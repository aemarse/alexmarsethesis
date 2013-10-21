function [metadata] = txtRead(filenameIn, metadata)
%-Input args: txt filename to be read in, out filename to be written
%-Example of usage: txtTest('001.txt', '001.mat');

%-----ERROR CHECKING---------------------

%-Check the number of input args
if (nargin < 2)
    err = ['Usage example: txtTest(''001.txt'', metadata)'];
    disp(err);
    return
end

%-Make sure that both input args are strings
if ( ~ischar(filenameIn) )
    disp('First arguments must be strings...');
    err = ['Usage example: txtTest(''001.txt'')'];
    disp(err);
    return
end

%-----FILE HANDLING----------------------

%-Open the file
try
    fid = fopen(filenameIn);
catch
    disp('Could not open file');
    return
end

%-Read the txt file in
txtIn = textscan(fid, '%f32%f32%s', 'endofline');

%-Close the file
fclose(fid);

%-Get the number of events in the txt file
numEvents = size(txtIn{1},1);

%-Make the struct
for i = 1:numEvents
    %-Get the start time, end time, and label
    metadata.txtEvents(i).onsetStartTime = txtIn{1}(i);
    metadata.txtEvents(i).onsetEndTime = txtIn{2}(i);
    metadata.txtEvents(i).label = txtIn{3}{i};
end

end