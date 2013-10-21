function [result] = removeFile(filename)

%--------------------------------------------------------------------------
%                         ABOUT THIS FUNCTION
%--------------------------------------------------------------------------
%-Written by Alex Marse (2013)

%-USAGE EXAMPLE:
%-r = removeFile(filename);

%-FUNCTIONALITY
%-This function will take a filename as input, and remove the file.

%-INPUTS
%-filename : the filename of the file to be read (should be a full path)

%-OUTPUTS
%-result : 1 = success, 0 = failure

%--------------------------------------------------------------------------
%                           Remove the file
%--------------------------------------------------------------------------

%-Prompt the user to delete the file
r = input('Could not read in file...Enter ''1'' to delete it: ');

%-If the users chooses to delete it, do the deed
if r == 1
    delete(filename);
    delete(sprintf('%s%s', filename(1:end-3), 'mat'));
    result = 1;
else
    disp('Well...you may want to delete it later...')
    result = 0;
end

end