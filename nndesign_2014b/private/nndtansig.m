function a = nndtansig(n,b)

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if nargin > 1
  n = bsxfun(@plus,n,b);
end
a = 2 ./ (1 + exp(-2*n)) - 1;
i = find(~isfinite(a));
a(i) = sign(n(i));
