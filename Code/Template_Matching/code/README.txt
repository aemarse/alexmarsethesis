-------------------
README - TM_AVES.M
-------------------

Version	: 1.0 from December 2012
Author	: Juan Sebastian Ulloa

DESCRIPTION
% This algorithm finds Acropternix orthonyx vocalization on field recordings through a template matching approach. 
% INPUTS:
%       signal  - sound signal sampled at 44.1kHz and 16bits
%       th      - threshold value. Must be between 0 and 1.
%    
%   OUTPUTS:
%      [limits] - A vector with time limits were vocalazation are
%      present.
%
% Copyright Juan Sebastian Ulloa 2012 (lisofomia@gmail.com)


MATLAB release:	 	MATLAB 7.12 (R2011a)
Other requirements:	None

Run test: 		To try the algorithm, run the file test.m provided on the zip package