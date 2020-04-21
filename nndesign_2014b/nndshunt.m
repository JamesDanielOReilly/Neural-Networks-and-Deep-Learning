function yprime = nndshunt(t,y)
%NNDSHUNT Calculates the derivative for a shunting network
%
%  NNDSHUNT(T,Y)
%    T - Time
%    Y - State
%  Returns dY.

% Copyright 1994-2015 Martin T. Hagan and Howard B. Demuth
% First Version, 8-31-95.

%==================================================================

global pp;
global pn;
global bp;
global bn;
global e;

yprime = (-y + (bp - y)*pp - (y + bn)*pn)/e;
