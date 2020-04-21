function f=nnstuded
%NNSTUDED Neural Network Design utility function.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

% Returns 1 if Student Edition MATLAB is being used.

c = version;
f=0;
if length(c) >= 7
  if lower(c(1:7)) == 'student'
    f = 1;
  end
end
