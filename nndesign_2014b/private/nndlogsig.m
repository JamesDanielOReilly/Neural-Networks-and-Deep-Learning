function a = nndlogsig(n)

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

a = 1 ./ (1 + exp(-n));
i = find(~isfinite(a));
a(i) = sign(n(i));
