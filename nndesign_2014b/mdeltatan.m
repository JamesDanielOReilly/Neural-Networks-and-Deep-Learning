function d = mdeltatan(a,d,w)
%DELTATAN Logistic Delta Function for Marquardt.
%         Returns the delta values for a layer of
%         tan-sigmoid neurons for use with Marquardt
%         backpropagation.
%         (See MDELTALIN,MDELTALOG,LEARN_MARQ,TANSIG)
%         
%         MDELTATAN(A), A is an SxQ matrix.
%         Returns a matrix of delta vectors for an OUTPUT
%         layer of tan-sigmoid neurons with outputs A
%         for the network.
%
%         MDELTATAN(A,D,W), A is an S1xQ matrix,
%           D is an S2xQ matrix, W is an S2xS1 matrix.
%         Returns a matrix of delta vectors for a HIDDEN
%         layer of tan-sigmoid neurons with outputs A
%         which had been passed through a weight matrix W
%         to another layer with delta vectors D.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if nargin < 1 | nargin > 3 | nargin == 2
  error('Wrong number of arguments.');
end

[s1,q]=size(a);

if nargin == 1
  d = -kron((ones-(a.*a)),ones(1,s1)).*kron(ones(1,s1),eye(s1));
else
  d = (ones-(a.*a)).*(w'*d);
end
