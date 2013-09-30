function data = readData(filename)

% function data = readData(filename)
%
% reads text file data. data is separated by space and carriage returns
% return data is (rowJ, dataRowJ) 
%
% ampTime11   amp11   ampTime12  amp12  ...   ampTime1C
% freqTime21  freq21  freqTime22 freq22 ...	 ... 
% ...                                         ...
% ampTime1R   ... ...                         ampTimeRC		
% freqTime1R  ... ...                         freqTimeRC		
%
% Tae Hong Park
% Music Department
% Princeton University
%
% park@silvertone.princeton.edu
%  

fid = fopen(filename, 'r');
row			= 0;

while 1
	startPtr 	= 1;
	endPtr 		= startPtr-1;
	foundChar	= 0;
	space		   = 0;
	i				= 1;
	row			= row+1;
	ampCounter	= 1;
	
	line = fgetl(fid);

	if ~isstr(line) 
		break
	end
	
	while i < length(line)+1

		while space == 0
			if line(i) == ' '
				space = 1;				
			else
				endPtr = endPtr+1;
				foundChar = 1;
			end
			i = i+1;
			
			if i > length(line)
				break
			end
		end
		space = 0;

		if foundChar == 1		
			data(row, ampCounter) = str2num(line(startPtr:endPtr));
			ampCounter = ampCounter + 1;
			foundChar = 0;
			startPtr = endPtr+2;
			endPtr = startPtr-1;
			i = startPtr;
		end
	end
end

fclose(fid);

