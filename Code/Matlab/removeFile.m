function [result] = removeFile(filename)

r = input('Could not read in file...Enter ''1'' to delete it: ');
    
if r == 1
    delete(filename);
    delete(sprintf('%s%s', filename(1:end-3), 'mat'));
    result = 1;
else
    disp('Well...you may want to delete it later...peace and love!')
    result = 0;
end

end