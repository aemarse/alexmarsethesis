% function [index] = indexFinder(s, row)
% 
% Used in conjunction with addSyn.m
%
% Tae Hong Park
% Music Department
% Princeton University
%
% park@silvertone.princeton.edu

function [index] = indexFinder(s, row)

index = 1;
[r,c]=size(s);

while s(row,index) ~= 0
	if index < c
		index = index+1;
	else
		index = index +1;
		break
	end
end

index = index -1;

