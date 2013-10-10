function x=plotgroups(F, G, S, C, tt, ff)
% x=plotgroups(F,G,S,C,tt,ff)  Plot groups of tracks on an sgram
%	Rows of F define track bin-freqs.  G has one 
%	column per track; each row is a boolean vector specifying
%	track membership.  S is the underlying spectrogram array.
%	Draw the tracks on the spectrogram, group them and number 
%	them.  C if specified defines the outline color.
%       tt and ff define time and freq axes, default to ennumeration.
% 1998may17 dpwe@icsi.berkeley.edu AHI
% $Header: $

% default color
%dclr = 'b';	% Blue
dclr = 'c';	% Cyan

doindex = 1;

if (nargin < 6)
  ff = 1:size(S,1);
end
if (nargin < 5)
  tt = 1:size(F,2);
end

if nargin < 4
  C = dclr;
  doindex=0;
  ixstr = '';
end

ngrp = size(G,1);

s = S;

ix = 1;
for gp = 1:ngrp
  if doindex
    ixstr = num2str(ix);
  end
  tks = find(G(gp,:));
  plottrax(F(tks,:), s, C, ixstr, '', tt, ff);
  ix = ix+1;
  % flag subsequent disptrax's not to redraw sgram
  s = [];
end

x = [];
