function a = nndpurelin(n,b)

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if nargin > 1
  n = bsxfun(@plus,n,b);
end
a = n;
