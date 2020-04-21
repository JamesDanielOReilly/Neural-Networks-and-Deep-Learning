function [net,tr] = nnd13train_marq(trainParam,P,T,VV,TT,func_test,perf_plot,mer_plot,pause_time,b1_plot,b2_plot,func_val)
% TRAIN_MARQ  
%       Marquardt Algorithm for an R-S1-S2 network
%       with tansigmoid hidden layer and linear
%       output layer.
%

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if isstr(trainParam)
  switch (trainParam)
    case 'pdefaults',
      trainParam = [];
	  trainParam.mu_initial = 0.01;
	  trainParam.v = 10;
	  trainParam.maxmu = 1e10;
	  trainParam.mu_initial = 0.01;
      trainParam.max_fail = 5;
	  trainParam.mingrad = 0.02;
      trainParam.max_epoch = 100;
      trainParam.err_goal = 0;
      trainParam.S1 = 5;
      trainParam.show = 25;
      trainParam.time = inf;
      trainParam.ro = 0;
	  net = trainParam;
    otherwise,
	  error('Unrecognized code.')
  end
  return
end

% Set parameters

S1 = trainParam.S1;
mu_initial = trainParam.mu_initial;
v = trainParam.v;
maxmu = trainParam.maxmu;
mu_initial = trainParam.mu_initial;
max_fail = trainParam.max_fail;
mingrad = trainParam.mingrad;
show = trainParam.show;
err_goal = trainParam.err_goal;
max_epoch = trainParam.max_epoch;
time = trainParam.time;
ro = trainParam.ro;
doValidationStop=true;
if (nargin>=4)
  doValidation = ~isempty(VV);
  if doValidation 
      if isfield(VV,'stop')
          doValidationStop=VV.stop;
      end
  end
else
  doValidation = false;
end
if (nargin>=5)
  doTest = ~isempty(TT);
else
  doTest = false;
end
this = 'nnd13train_marq';


% INITIALIZE NETWORK ARCHITECTURE
%================================

% Set input vector size R, layer sizes S1 & S2, batch size Q.

[R,Q] = size(P); 
[S2,Q] = size(T);

W10 = (2*rand(S1,R)-1)*0.5; B10 = (2*rand(S1,1)-1)*0.5;
W20 = (2*rand(S2,S1)-1)*0.5; B20 = (2*rand(S2,1)-1)*0.5;
%[W10,B10] = nnnwlog(S1,R);

% DEFINE SIZES
RS = S1*R; RS1 = RS+1; RSS = RS + S1; RSS1 = RSS + 1;
RSS2 = RSS + S1*S2; RSS3 = RSS2 + 1; RSS4 = RSS2 + S2;

% INITIALIZE PARAMETERS
W1=W10;B1=B10;W2=W20;B2=B20;
dW1=W10;dB1=B10;dW2=W20;dB2=B20;

flag_stop=0;
stop = '';
startTime = clock;
mu=mu_initial;
ii=eye(RSS4);
meu=zeros(max_epoch,1);
mer=meu;grad=meu;
A1 = nndtansig(W1*P,B1);
A2 = nndpurelin(W2*A1,B2);
if length(b1_plot)==1 & length(b2_plot)==1
  set(b1_plot,'ydata',A2,'visible','on')
  set(b2_plot,'ydata',A2,'visible','on')
end
E1 = T-A2;
x = getX(W1,B1,W2,B2);
%f1 = sum(sum(E1.*E1)) + ro*x'*x;
f1 = (sum(sum(E1.*E1))) + ro*x'*x;
perf = f1;

if (doValidation)
  A1v = nndtansig(W1*VV.P,B1);
  A2v = nndpurelin(W2*A1v,B2);
  E1v = VV.T-A2v;
  %vperf=sumsqr(E1v) + ro*x'*x;
  vperf=(sum(sum(E1v.*E1v))) + ro*x'*x;
  VV.perf = vperf; VV.net = getW(x,R,S1,S2); VV.numFail = 0;
  VV.numFail = 0; tr.epoch = 0;
end

% MAIN LOOP

for epoch = 1:max_epoch,

% FIND JACOBIAN
  A1 = kron(A1,ones(1,S2));
  D2 = mdeltalin(A2);
  D1 = mdeltatan(A1,D2,W2);
  jac1 = learn_marq(kron(P,ones(1,S2)),D1);
  jac2 = learn_marq(A1,D2);
  jac=[jac1,D1',jac2,D2'];

% CHECK THE MAGNITUDE OF THE GRADIENT
  E1=E1(:);
  je=jac'*E1;
  w = getX(W1,B1,W2,B2);
  grd = 2*je + 2*ro*w;
  normgX = norm(grd);

  % Save results
  tr.mer(epoch)=f1;
  if length(mer_plot)==1
      set(mer_plot,'xdata',[1:epoch],'ydata',tr.mer(1:epoch));
  end
  tr.meu(epoch)=mu;
  tr.grad(epoch)=normgX;
  if (doValidation)
    tr.vperf(epoch) = VV.perf;
  end

  if ~isempty(VV)
      A1v = nndtansig(W1*VV.P,B1);
      A2v = nndpurelin(W2*A1v,B2);
      set(func_val,'ydata',A2v,'visible','on');
  end
  A1v = nndtansig(W1*TT.P,B1);
  A2v = nndpurelin(W2*A1v,B2);
  set(func_test,'ydata',A2v);
  drawnow
  pause(pause_time)
  if (doTest)
    % We calculate testing to plot results
    E1v = TT.T-A2v;
    %tperf=sumsqr(E1v) + ro*x'*x;
    tperf=(sum(sum(E1v.*E1v))) + ro*x'*x;
    tr.tperf(epoch) = tperf;
    if length(perf_plot)==1
        set(perf_plot,'xdata',[1:epoch],'ydata',tr.tperf(1:epoch));
    end
  end

  % Stopping Criteria
  currentTime = etime(clock,startTime);
  if (f1 <= err_goal)
    stop = 'Performance goal met.';
  elseif (epoch == max_epoch)
    stop = 'Maximum epoch reached, performance goal was not met.';
  elseif (currentTime > time)
    stop = 'Maximum time elapsed, performance goal was not met.';
  elseif (normgX < mingrad)
    stop = 'Minimum gradient reached, performance goal was not met.';
  elseif (mu > maxmu)
    stop = 'Maximum MU reached, performance goal was not met.';
  elseif (doValidation) & (VV.numFail > max_fail) & doValidationStop
    stop = 'Validation stop.';
  end
  
  % Progress
  if isfinite(show) & (~rem(epoch,show) | length(stop))
  if isfinite(max_epoch) fprintf('Epoch %g/%g',epoch, max_epoch); end
  if isfinite(time) fprintf(', Time %4.1f%%',currentTime/time*100); end
  if isfinite(err_goal) fprintf(', %s %g/%g','Sum-squared Error',f1,err_goal); end
  if isfinite(mingrad) fprintf(', Gradient %g/%g',normgX,mingrad); end
  fprintf('\n')
  %flag_stop=plotperf(tr,goal,this,epoch);
  if length(stop)
      fprintf('%s, %s\n\n',this,stop); end
  end
 
  % Stop when criteria indicate its time
  if length(stop)
    if (doValidation)
    net = VV.net;
  end
    break
  end
  
% This section of code for checking the gradient calculation
if epoch==1,
  numParameters = length(w);
  A1v = nndtansig(W1*P,B1);
  A2v = nndpurelin(W2*A1v,B2);
  E1v = T-A2v;
  %perf=sumsqr(E1v) + ro*w'*w;
  perf=(sum(sum(E1v.*E1v))) + ro*w'*w;
  eps = 0.000001;
  X_temp = w;
  gX = zeros(numParameters,1);
  for j=1:numParameters,
    X_temp(j)=w(j)+eps;
   [net_temp] = getW(X_temp,R,S1,S2);
    A1v1 = nndtansig(net_temp.W1*P,net_temp.B1);
    A2v1 = nndpurelin(net_temp.W2*A1v1,net_temp.B2);
    E1v1 = T-A2v1;
    %perf1=sumsqr(E1v1) + ro*X_temp'*X_temp;
    perf1=(sum(sum(E1v1.*E1v1))) + ro*X_temp'*X_temp;
    X_temp(j)=w(j);
    gX(j) = (perf1-perf)/eps;
  end
  %(sum(sum((gX-grd).*(gX-grd)))) % Commented out MHB
end
% End of gradient checking


% INNER LOOP, INCREASE mu UNTIL THE ERRORS ARE REDUCED
  jj=jac'*jac;
  while mu < maxmu,
    dw=-(jj+ii*(mu+ro))\(je + ro*w);
    %dw=-(jj+ii*mu)\je;
    %dX = -(beta*jj + ii*(mu+alph)) \ (beta*je + alph*X);
    dW1(:)=dw(1:RS);
    dB1=dw(RS1:RSS);
    dW2(:)=dw(RSS1:RSS2);
    dB2=dw(RSS3:RSS4);
    W1n=W1+dW1;B1n=B1+dB1;W2n=W2+dW2;
    B2n=B2+dB2;
    A1 = nndtansig(W1n*P,B1n);
    A2 = nndpurelin(W2n*A1,B2n);
    E2 = T-A2;
    x = getX(W1n,B1n,W2n,B2n);
    %f2=sum(sum(E2.*E2)) + ro*x'*x;	
    f2=(sum(sum(E2.*E2))) + ro*x'*x;	

    if (f2 < f1) 
      W1=W1n;B1=B1n;W2=W2n;B2=B2n;E1=E2;
      f1=f2;
      w = x;
      mu = mu / v;
      if (mu < 1e-20)
        mu = 1e-20;
      end
      break   % Must be after the IF
    end
    mu = mu * v;
     					
  end

  if length(b1_plot)==1 & length(b2_plot)==1
    set(b1_plot,'ydata',A2,'visible','on')
    set(b2_plot,'ydata',A2,'visible','on')
  end
  
  if (doValidation)
    A1v = nndtansig(W1*VV.P,B1);
    A2v = nndpurelin(W2*A1v,B2);
    E1v = VV.T-A2v;
    %vperf=sumsqr(E1v) + ro*w'*w;
    vperf=(sum(sum(E1v.*E1v))) + ro*w'*w;
    if (vperf < VV.perf)
      VV.perf = vperf; VV.net = getW(w,R,S1,S2); VV.numFail = 0; tr.epoch = epoch+1;
    elseif (vperf > VV.perf)
      VV.numFail = VV.numFail + 1;
    end
  end

end

% truncate vectors
tr.mer=tr.mer(1:epoch);
tr.meu=tr.meu(1:epoch);
tr.grad=tr.grad(1:epoch);
if (doValidation)
  tr.vperf=tr.vperf(1:epoch);
end
if (doTest)
  tr.tperf=tr.tperf(1:epoch);
end

% Save Results
%=================
if (doValidation)
  net = VV.net;
else
  net.W1=W1; net.B1=B1; net.W2=W2; net.B2=B2;
end


%========================
function x = getX(W1,B1,W2,B2)
[S1,R] = size(W1);
[S2,S1] = size(W2);
RS = S1*R; RS1 = RS+1; RSS = RS + S1; RSS1 = RSS + 1;
RSS2 = RSS + S1*S2; RSS3 = RSS2 + 1; RSS4 = RSS2 + S2;

x(1:RS)=W1(:);
x(RS1:RSS)=B1;
x(RSS1:RSS2)=W2(:);
x(RSS3:RSS4)=B2;
x=x(:);

%===============================
function [net] = getW(x,R,S1,S2)

RS = S1*R; RS1 = RS+1; RSS = RS + S1; RSS1 = RSS + 1;
RSS2 = RSS + S1*S2; RSS3 = RSS2 + 1; RSS4 = RSS2 + S2;

net.W1 = zeros(S1,R);
net.W2 = zeros(S2,S1);
net.W1(:)=x(1:RS);
net.B1=x(RS1:RSS);
net.W2(:)=x(RSS1:RSS2);
net.B2=x(RSS3:RSS4);


