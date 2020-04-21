function c = nngrays
%NNGRAYS Grays used by Neural Network Toolbox GUI.
  
%  NNGRAYS returns a matrix of rgb triples for 46 grays.

% Mark Beale 6-4-94
% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

c = [0.9:-0.01:0.4]'*[1 0.97 0.97];
