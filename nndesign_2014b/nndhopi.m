function yprime = nndhopi(t,y)
%NNDHOPI Calculates the derivative for sample Hopfield network
%
% NNDHOPI(t,y)
%   t - Current time
%   y - Current output
% Returns dy

% Copyright 1994-2015 Martin T. Hagan and Howard B. Demuth

global W;
global b;

% Assuming infinite Lambda:

yprime = 0.5*W*y + b;
