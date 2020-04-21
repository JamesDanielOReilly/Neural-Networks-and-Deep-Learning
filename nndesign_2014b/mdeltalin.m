function d = mdeltalin(a,d,w)
%MDELTALIN Logistic Delta Function for Marquardt.
%         Returns the delta values for a layer of
%         linear neurons.
%         (See MDELTALOG,MDELTATAN,LEARN_MARQ,PURELIN)
%         
%         MDELTALIN(A), 
%         Returns a matrix of delta vectors for an ouput
%         layer.
%
%         MDELTALIN(A,D,W), D is an S2xQ matrix,
%           W is an S2xS1 matrix.
%         Returns a matrix of delta vectors for a hidden
%         layer of linear neurons whose outputs have
%         been passed through a weight matrix W to another
%         layer with delta vectors D.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if nargin < 1 | nargin > 3 | nargin == 2
  error('Wrong number of arguments.');
  end

[na,ma]=size(a);

if nargin == 1
  d=-kron(ones(1,ma),eye(na));
else
  d = w'*d;
end

