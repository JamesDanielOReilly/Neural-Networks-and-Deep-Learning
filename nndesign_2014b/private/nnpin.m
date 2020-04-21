function y = nnpin(x,a,b,q)
%NNPIN Neural Network Design utility function.

%  NNPIN(X,A,B,Q)
%    X - Number or matrix.
%    A - Lower bound.
%    B - Upper bound.
%    Q - Quantization constant (optional).
%  Returns values in X pinned into the interval defined
%  by A and B and rounded to the nearest multiple of Q.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% First Version, 8-31-95.

%==================================================================

y = max(a,min(b,x));
y = round(y/q)*q;
