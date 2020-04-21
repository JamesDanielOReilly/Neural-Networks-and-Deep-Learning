function [w,b]=nnnwlog(s,p)
%NNNWLOG Calculates Nugyen-Widrow initial conditions.
%
%  S - Number of neurons.
%  P - Inputs.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

[r,q] = size(p);
pmin = min(p')';
pmax = max(p')';

pr = [pmin pmax];

magw = 0.7*s^(1/r);
w = magw*nnnormr(2*rand(s,r)-1);
if (s==1)
  b = 0;
else
  b = magw*linspace(-1,1,s)'.*sign(w(:,1));
end

% Adjust for input range
x = 2./(pr(:,2)-pr(:,1));
y = 1-pr(:,2).*x;

xp = x';
b = w*y+b;
w = w.*xp(ones(1,s),:);

%============================================
function n = nnnormr(m)
[mr,mc]=size(m);
if (mc == 1)
  n = m ./ abs(m);
else
  n = sqrt(ones./(sum((m.*m)')))'*ones(1,mc).*m;
end
