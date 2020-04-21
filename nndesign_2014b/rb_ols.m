function [w1,b1,w2,b2,mf,of,indf] = rb_ols(p,t,c,b,n,genplot)
%RB_OLS Orthogonal least squares for SISO RBF network.
%
%  Synopsis
%
%    [w1,b1,w2,b2,mf,of,indf] = rb_ols(P,T,C,B,N)
%
%  Description
%
%    Demonstrates the operation of orthogonal least squares
%    for a radial basis network to fit a single-input/single-ouput
%    function. The algorithm shows the fit for a specified number
%    of iterations
%
%   rb_ols(P,T,C,B,N) takes these arguments,
%     P      - 1xQ matrix of Q inputs.
%     T      - 1xQ matrix of Q targets.
%     C      - Potential centers.
%     B      - First layer bias vector.
%     N      - Number of neurons to add.
%   and returns 
%     W1     - Trained first layer weights.
%     B1     - First layer biases.
%     W2     - Trained second layer weights.
%     B2     - Trained second layer bias.
%     MF     - Final orthogonalized regression matrix.
%     OF     - Error reduction at each iteration.
%     INDF   - Index to center chosen at each iteration.
%              The index of nc+1 is the bias.
%
%   The larger that SPREAD is the smoother the function approximation
%   will be.  Too large a spread means a lot of neurons will be
%   required to fit a fast changing function.  Too small a spread
%   means many neurons will be required to fit a smooth function,
%   and the network may not generalize well.  Call NEWRB with
%   different spreads to find the best value for a given problem.
%
%  Examples
%
%    Here we design a radial basis network given inputs P
%    and targets T.
%
%      P = [-1:.5:1];
%      T = [-1 0 1 0 -1];
%      c = p;
%      b = ones(size(c));
%      n = 2;
%      [w1,b1,w2,b2,mf,of,indf] = rb_ols(P,T,c,b,n);
%
%  Algorithm
%
%    Initially the RADBAS layer has no neurons.  The following steps
%    are repeated until the maximum number of neurons are reached:
%    1) The potential center which produces the greatest error reduction is found
%    2) A RADBAS neuron is added with weights equal to that vector.
%    3) The PURELIN layer weights are redesigned to minimize error.
%

% Copyright 1994-2015 Martin T. Hagan and Howard B. Demuth

%Initialization
p = p(:);
c = c(:);
b = b(:);
t = t(:);
q = length(p);
nc = length(c);
o = zeros(nc+1,1);
h = zeros(nc+1,1);
rr = eye(nc+1);
indexT = 1:nc+1;
if n>nc+1
    n=nc+1;
end;
bindex = [];
sst = t'*t;

%Compute the regression matrix
temp = p*ones(1,nc) - ones(q,1)*c';
btot = ones(q,1)*b';
uo = exp(-(temp.*btot).^2);
uo = [uo ones(q,1)];
u = uo;
m = u;

%First stage
for i=1:(nc+1),
    ssm = m(:,i)'*m(:,i);
    h(i) = m(:,i)'*t/ssm;
    o(i) = h(i)^2*ssm/sst;
end
[o1,ind1] = max(o);
of = o1;
hf(1) = h(ind1);

mf = m(:,ind1);
ssmf = mf'*mf;
u(:,ind1) = [];
if indexT(ind1)==(nc+1),
  bindex = 1;
  indf = [];
  % temp change to start loop
  k0=1;
else
  indf = indexT(ind1);
  % temp change to start loop
  k0=2;
end
indexT(ind1) = [];
m = u;

%Stage k
  % temp change to start loop
for k = 2:n,
%for k = k0:n,
  o = zeros(nc+2-k,1);
  h = zeros(nc+2-k,1);
  r = zeros(k,k,k);
  for i = 1:(q-k+1),
    for j = 1:(k-1),   
        r(i,j,k) = mf(:,j)'*u(:,i)/ssmf(j);
        m(:,i) = m(:,i) - r(i,j,k)*mf(:,j);
    end
    ssm = m(:,i)'*m(:,i);
    h(i) = m(:,i)'*t/ssm;
    o(i) = h(i)^2*ssm/sst;
  end
  [o1,ind1] = max(o);
  mf = [mf m(:,ind1)];
  ssmf(k) = m(:,ind1)'*m(:,ind1);
  of = [of o1];
  u(:,ind1) = [];
  hf(k) = h(ind1);
  for j = 1:(k-1),
    rr(j,k)=r(ind1,j,k);
  end
  if indexT(ind1)==(nc+1),
    bindex = k;
  else
    indf = [indf indexT(ind1)];
  end
  indexT(ind1) = [];
  m = u;
end


%Solve for the original weights
nn = length(hf);
xx = zeros(nn,1);
xx(nn) = hf(nn);
for i=(nn-1):-1:1,
  xx(i) = hf(i);
  for j=nn:-1:i+1,
    xx(i) = xx(i) - rr(i,j)*xx(j);
  end
end

%Put the parameters into the weight and bias
w1 = c(indf);
b1 = b(indf);
if isempty(bindex),
  b2 = 0;
  w2 = xx';
else
  w2 = xx([1:(bindex-1) (bindex+1):nn])';
  b2 = xx(bindex);
end

% Convert the index array to show the bias selection
% at the correct iteration.  Fill the uu array for
% later cross-checking of the computed weights.
if isempty(bindex),
  uu = uo(:,indf);
else
  indf = [indf(1:bindex-1) nc+1 indf(bindex:end)];
  uu = uo(:,indf);
end

% The next section contains tests to be sure that
% the OLS algorithm produced the correct x, and
% that the network response produces the expected error.
% They can be deleted, or commented out.

%if abs(xx)>0
%    x = inv(uu'*uu)*uu'*t;
%    aa=purelin(netsum(w2*radbas(netprod(dist(w1,p'),concur(b1,q))),concur(b2,q)));
%    error = t-aa';
%    fracError = sse(error)/sst;
%    expFracError = 1 - sum(of); 
%    percError=(x-xx)./abs(xx);
%    [x xx];
%end

if nargin==6
    if genplot==0
        return
    end
end
% New code to plot results
figure(1)
range(1)=min(p);
range(2)=max(p);
total = range(2)-range(1);
p2 = range(1):(total/1000):range(2);
Q2 = length(p2);
S1=length(w1);
pp2 = repmat(p2,S1,1);
n12 = abs(pp2-w1*ones(1,Q2)).*(b1*ones(1,Q2));
a12 = exp(-n12.^2);
a22 = w2*a12 + b2*ones(1,Q2);
%t_exact = sin(2*pi*freq*p2 + phase)+1;
temp=[(w2'*ones(1,Q2)).*a12; b2*ones(1,Q2)];
subplot(4,1,[1 2 3]), plot(p,t,'ok',p2,temp,':k');
%plot(t);
hold on
plot(p,t,'LineWidth',2)
plot(p,aa,'r')
hold off
subplot(4,1,4), plot(p2,a12,'k');

return
end


