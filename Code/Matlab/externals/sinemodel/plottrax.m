function plottrax(T,S,colr,tag, tkcolr, tt, ff)
% plottrax(T,S,colr,tag,tkcolr,tt,ff)   Plot spectrogram-derived tracks
%    T is an array of freq-bin-indexes defining tracks (from
%    extractrax); S is the underlying (linear) spectrogram;
%    Display the tracks over the spectrogram.
%    If S is empty, assume sgram already there.
%    If clr is specified, it's a color spec for the outline.
%    If tag is specified, label the group with it.
%    If tkcolr is given, label the tracks with it.
%    tt and ff are arguments for the time and frequency axes of the plot, 
%    default to simple enumeration.
% 1998may17 dpwe@icsi.berkeley.edu

[nr, nc] = size(S);
if (nargin < 7)
  ff = 1:nr;
end
if (nargin < 6)
  tt = 1:size(T,2);
end
if (nargin < 5)
  tkcolr = 'g';
else
  if isempty(tkcolr)
     tkcolr = 'g';
  end
end
if (nargin < 4)
  tag = '';
end
havetag = 1;
if (nargin < 3)
  colr = '';
end
if isempty(colr)
  havetag = 0;
end
if (nargin < 2)
  S = [];
end

if size(S,1) > 0
  % Have S - redraw sgram
  hold off
  imagesc(tt,ff,20*log10(abs(S))); axis xy
end

% Figure extent of axes, for scaling 'surrounding box' (if havetag)
ax = axis;
standoffpropy = 0.015;
standoffpropx = 0.002;
bxvoffs = round(standoffpropy*(ax(4)-ax(3)));
bxhoffs = round(standoffpropx*(ax(2)-ax(1)));
txhoffs = 0;
txvoffs = round(0.08 * (ax(4)-ax(3)));

hold on
plot(tt, T',tkcolr);	% tracks in green

% Add x's at track starts
[nr,nc] = size(T);
fz = isnan(T);
G = T.*fz(:, [1 [1:(nc-1)]]);
% Plot all 0->nonzero transitions
%xx=find( (G>0).*(1-isnan(G)));
% Plot just the first nonzero in each row
xx = ([1:nr])+nr*(-1+min((((1 - fz) .* (ones(nr,1)*[1:nc])) + fz.*(nc*ones(nr,nc)))'));
yy=G(xx);
xxx=floor(xx/nr);
plot(xxx,yy,'xg');   % Startpoints in green

% If have tag, indicate grouping
if havetag == 1
  cols = find(sum((T ~= 0).*(~isnan(T))));
  frqs = T(find(1-isnan(T)));
  % remove zeros
  frqs = frqs(find(frqs > 0));
  % plot box
%  bxvoffs = 2;
%  bxhoffs = 10;
  mnc = tt(min(cols))-bxhoffs;
  mxc = tt(max(cols))+bxhoffs;
  mnf = min(frqs)-bxvoffs;
  mxf = max(frqs)+bxvoffs;
  plot([mnc, mnc, mxc, mxc, mnc], [mnf, mxf, mxf, mnf, mnf], colr);
  % add text
%  txvoffs=10;
%  txhoffs=0;
  text(mnc+txhoffs, mxf+txvoffs, tag);
end

hold off
