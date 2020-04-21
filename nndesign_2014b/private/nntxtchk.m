function nntxtchk
%NNTXTCHK Neural Network Design utility function.

% Refresh screen when appropriate to get around PC text color bug.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

c = computer;
if strcmp(c(1:2),'PC')
  set(gcf,'Position',get(gcf,'Position'));
end
