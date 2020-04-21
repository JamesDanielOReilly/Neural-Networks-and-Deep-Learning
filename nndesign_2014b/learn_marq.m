function jac = learn_marq(p,d)
%LEARN_MARQ  Marquardt Backpropagation Learning Rule
%           
%         (See PURELIN, LOGSIG, TANSIG)
%
%         jac = LEARN-MARQ(P,D)
%           P  - RxQ matrix of input vectors.
%           D  - SxQ matrix of sensitivity vectors.
%         Returns:
%           jac - a partial jacobian matrix.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if nargin ~= 2
  error('Wrong number of arguments.');
end

[s,q]=size(d);
[r,q]=size(p);

jac=kron(p',ones(1,s)).*kron(ones(1,r),d');

