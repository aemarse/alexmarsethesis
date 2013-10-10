function [groups,extents] = grouptrax(T,M)
% G = grouptrax(F,M)  Group sinusoid tracks by onset and durn
%	F and M define a set of track freqs and mags, resp; return a matrix 
%	of mutually-exclusive groups as the rows of G, which has one column
%	per row of [F;M].  G(gp, tk) = 1 means track tk is in group gp.
% 1998may17 dpwe@icsi.berkeley.edu AHI
% $Header: $

% Configuration constants

% Scaling factor for gaussian contribution of edge difference (in steps)
edgescale = 5.0;

% Scaling factor for gaussian contribution of normalized length diff
%lenscale = 0.5;
lenscale = 2.0;

% Threshold for product of gaussian inclusion score
groupthresh = 0.2;

% Minimum group size to be recorded
mingroupsize = 3;

%%%

% Find start and end of every track
[ntx,nc] = size(T);
extents = zeros(ntx, 2);
for tx = 1:ntx
  ixs = find(~isnan(T(tx,:)));
  extents(tx,:) = [min(ixs),max(ixs)];
end
% Hence, duration of each track
lengths = extents(:,2) - extents(:,1);

% Groups are represented by rows with one entry per track
groups = zeros(0,ntx);

% Use every track as the seed for a group; we'll prune repeats after.
for tx = 1:ntx
  % Figure all onset times relative to this track
  edgediffs = extents - (ones(ntx,1) * extents(tx,:));
  % proportional length differences
  lenratios = lengths / lengths(tx);
  % Grouping condition
  edgescore = exp(-((edgediffs(:,1)'/edgescale).^2));
  lenscore =  exp(-(((lenratios'-1.0)/lenscale).^2));
  group = (edgescore .* lenscore) > groupthresh;
  % Store groups with 3? or more members
  if sum(group) >= mingroupsize
    groups = [groups; group];
  end
end

% How many groups did we actually record?
ngrps = size(groups,1);
% How many tracks in each group?  (Prune for largest if overlap)
gpsize = sum(groups');

% Now filter the groups to avoid repeated tracks
% Vector of flags which we'll gradually erode
keepgroups = ones(ngrps,1);
% Loop over each group, gather all groups with overlapping tracks, choose
% largest
for gp = 1:ngrps
  % Only test this group if we haven't killed it yet
  if keepgroups(gp) == 1
    % which groups contain this track?
    gps = find(sum(groups(:,find(groups(gp,:)))') > 0);
    % Which one is the longest?
    biggest = find( gpsize(gps) == max(gpsize(gps)) );
%   fprintf(1,'gp %d overlaps %d groups, chose %d\n', gp, size(gps,2), gps(biggest(1)));
    % Get rid of them all...
    keepgroups(gps) = zeros(1, size(gps,2));
    % .. except the longest
    keepgroups(gps(biggest(1))) = 1;
  end
end

% Filter out the groups we didn't like to get return
groups = groups(find(keepgroups),:);
