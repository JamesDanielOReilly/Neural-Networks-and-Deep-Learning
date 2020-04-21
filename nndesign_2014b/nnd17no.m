function nnd17no(cmd,arg1)
% nnd17no Function approximation demonstration.
% This demonstration requires the Neural Network Toolbox.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

% $Revision: 1.8 $
% First Version, 8-31-95.

%==================================================================

% CONSTANTS
me = 'nnd17no';
max_t = 0.5;
w_max = 10;
p_max = 2;
circle_size = 6;

% FLAGS
change_func = 0;

% DEFAULTS
if nargin == 0, cmd = ''; else cmd = lower(cmd); end

% FIND WINDOW IF IT EXISTS
fig = nndfgflg(me);
  
% GET WINDOW DATA IF IT EXISTS
if ~isempty(fig)
  H = get(fig,'userdata');
  fig_axis = H(1);            % window axis
  desc_text = H(2);           % handle to first line of text sequence
  s1_bar = H(3);              % lr slider bar
  s1_text = H(4);             % lr text
  fa_axis = H(5);             % function approximation axis
  fa_ptr = H(6);              % function approximation plot handles
  i_bar = H(7);               % Difficulty slider bar
  i_text = H(8);              % Difficuly text
  lls_radiob = H(9);
  ols_radiob = H(10);
  rand_radiob = H(11);
  W1_ptr = H(12);
  B1_ptr = H(13);
  W2_ptr = H(14);
  B2_ptr = H(15);
  but_train = H(16);
  fb_axis = H(17);
end

%==================================================================
% Activate the window.
%
% ME() or ME('')
%==================================================================

if strcmp(cmd,'')
  if fig
    figure(fig)
    set(fig,'visible','on')
  else
    feval(me,'init')
  end

%==================================================================
% Close the window.
%
% ME() or ME('')
%==================================================================

elseif strcmp(cmd,'close') & ~isempty(fig)
  delete(fig)

%==================================================================
% Initialize the window.
%
% ME('init')
%==================================================================

elseif strcmp(cmd,'init') & isempty(fig)

  % CHECK FOR NNT
  % ODJ 12/23/07 Check for NN Toolbox removed
  %if ~nntexist(me), return, end

  % CONSTANTS
  W1 = [10; 10];
  b1 = [-5;5];
  W2 = [1 1];
  b2 = [-1];

  % NEW DEMO FIGURE
  fig = nndemof2(me,'DESIGN','Nonlinear Optimization','','Chapter 17');
  set(fig, ...
    'windowbuttondownfcn',nncallbk(me,'down'), ...
    'BackingStore','off',...
    'nextplot','add');
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);

  % ICON
  nndicon(17,458,363,'shadow')

  % HIDDEN NEURONS SLIDER BAR
  s1 = 4;
  x = 20;
  y = 55;
  len = 150;
  text(x,y,'Number of Hidden Neurons:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  s1_text = text(x+len,y,num2str(s1),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-38,'2',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+len,y-38,'9',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  s1_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''s1'')'],...
    'min',2,...
    'max',9,...
    'value',s1);

  % PROBLEM DIFFICULTY SLIDER BAR
  i = 1;
  x = 200;
  y = 55;
  len = 150;
  text(x,y,'Difficulty Index:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  i_text = text(x+len,y,num2str(i),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-38,'1',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+len,y-38,'9',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  i_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''i'')'],...
    'min',1,...
    'max',9,...
    'value',i);


  uipanel(...
    'Units','points',...
    'Title',{  'Select Initialization Method' },...
    'backg',nnltgray,...
    'Tag','uipanel1',...
    'Clipping','on',... 
    'Position',[15 70 340 40]);

  lls_radiob = uicontrol(...
    'units','points',...
    'position',[20 80 100 16],...
    'style','radiobutton',...
    'backg',nnltgray,...
    'string','Linear Least Squares',...
    'callback',[me '(''lls'')'],...
    'value',0,...
    'FontSize',8);
  ols_radiob = uicontrol(...
    'units','points',...
    'position',[130 80 120 16],...
    'style','radiobutton',...
    'backg',nnltgray,...
    'string','Orthogonal Least Squares',...
    'callback',[me '(''ols'')'],...
    'value',0,...
    'FontSize',8);
  rand_radiob = uicontrol(...
    'units','points',...
    'position',[255 80 85 16],...
    'style','radiobutton',...
    'backg',nnltgray,...
    'string','Random weights',...
    'callback',[me '(''rand'')'],...
    'value',0,...
    'FontSize',8);

  W1_ptr = uicontrol('visible','off','userdata',[]);
  B1_ptr = uicontrol('visible','off','userdata',[]);
  W2_ptr = uicontrol('visible','off','userdata',[]);
  B2_ptr = uicontrol('visible','off','userdata',[]);

  % FUNCTION APPROXIMATION
  i = 1;
  P = -2:(.4/i):2;
  T = 1 + sin(pi*P/4);

  fa_axis = nnsfo('a2','Function Approximation','','Target','');
  set(fa_axis,...
    'position',[50 220 270 120],...
    'ylim',[0 2])
  %fa_plot =  plot(P,T,'color',nndkblue,'linewidth',3);
  fa_plot =  plot(P,T,'color',nnblue,'linewidth',3);
  set(fa_axis,'ylim',[-2 4])

  fb_axis = nnsfo('a2','','Input','a^1','');
  set(fb_axis,...
    'position',[50 160 270 40],...
    'ylim',[-0.1 1.1])
  fb_plot = plot([P(1) P(end)],[0 0],'k');
    
  % BUTTONS
  but_train = uicontrol(...
    'units','points',...
    'position',[400 120 60 20],...
    'string','Train',...
    'callback',[me '(''train'')'],...
    'enable','off');
  uicontrol(...
    'units','points',...
    'position',[400 90 60 20],...
    'string','Contents',...
    'callback','nndtoc')
  uicontrol(...
    'units','points',...
    'position',[400 60 60 20],...
    'string','Close',...
    'callback',[me '(''close'')'])

  % DATA POINTERS
  fa_ptr = uicontrol('visible','off','userdata',fa_plot);

  % SAVE WINDOW DATA AND LOCK
  H = [fig_axis desc_text s1_bar s1_text fa_axis fa_ptr i_bar i_text ...
      lls_radiob ols_radiob rand_radiob W1_ptr B1_ptr W2_ptr B2_ptr ...
      but_train fb_axis];
  set(fig,'userdata',H,'nextplot','new')

  % INSTRUCTION TEXT
  feval(me,'instr');

  % LOCK WINDOW
  set(fig,'nextplot','new','color',nnltgray);

  nnchkfs;

%==================================================================
% Display the instructions.
%
% ME('instr')
%==================================================================

elseif strcmp(cmd,'instr') & ~isempty(fig)
  nnsettxt(desc_text,...
    'Use the slide bars',...
    'to choose the',...
    'number of neurons',...
    'in the hidden layer',...
    'and the difficulty',...
    'of the function.',...
    '',...
    'Select a Weight',...
    'Initialization Method',...
    '',...
    'Click the [Train]',...
    'button to train the',...
    'Radial-basis',...
    'network on the',...
    'function at left.',...
    ''...
    );
    

%==================================================================
% Respond to linear least squares Initialization.
%
% ME('lls')
%==================================================================

elseif strcmp(cmd,'lls')
  set(lls_radiob,'value',1);
  set(ols_radiob,'value',0);
  set(rand_radiob,'value',0);

  range=[-2 2];
  S1 = round(get(s1_bar,'value'));
  i = round(get(i_bar,'value'));
  delta = (range(2)-range(1))/(S1-1);
  %b=sqrt(S1)/delta;
  b=1.6652/delta;
  W10 = (range(1):delta:range(2))+0.01;
  W10 = W10(1:(end))';
  B10 = b*ones(size(W10));
  npts=S1;
  d1 = (range(2)-range(1))/(npts-1);
  p = range(1):d1:range(2);
  t = 1+sin(i*pi*p/4);
  QQ = length(p);
  pp = repmat(p,S1,1); 
  n1 = abs(pp-W10*ones(1,QQ)).*(B10*ones(1,QQ));
  a1 = exp(-n1.^2);
  Z = [a1;ones(1,QQ)];
  ro=0;
  x=pinv(Z*Z'+ro*eye(S1+1))*Z*t';
  W20 = x(1:end-1)';
  B20 = x(end);
  
  set(W1_ptr,'userdata',W10);
  set(B1_ptr,'userdata',B10);
  set(W2_ptr,'userdata',W20);
  set(B2_ptr,'userdata',B20);
  
  cmd='update_plot';
  
  
%==================================================================
% Respond to linear Orthogonal squares Initialization.
%
% ME('ols')
%==================================================================

elseif strcmp(cmd,'ols')
  set(lls_radiob,'value',0);
  set(ols_radiob,'value',1);
  set(rand_radiob,'value',0);

  range=[-2 2];
  S1 = round(get(s1_bar,'value'));
  i = round(get(i_bar,'value'));
  range=[-2 2];
  npts=S1;
  d1 = (range(2)-range(1))/(npts-1);
  p = range(1):d1:range(2);
  t = 1+sin(i*pi*p/4);
  c=p;
  n=S1;
  b = ones(size(c));
  [W10,B10,W20,B20] = rb_ols(p,t,c,b,n,0);
  
  set(W1_ptr,'userdata',W10);
  set(B1_ptr,'userdata',B10);
  set(W2_ptr,'userdata',W20);
  set(B2_ptr,'userdata',B20);
  
  cmd='update_plot';
  
%==================================================================
% Respond to random weights Initialization.
%
% ME('rand')
%==================================================================

elseif strcmp(cmd,'rand')
  set(lls_radiob,'value',0);
  set(ols_radiob,'value',0);
  set(rand_radiob,'value',1);

  S1 = round(get(s1_bar,'value'));
  i = round(get(i_bar,'value'));
  W10 = 2*rand(S1,1)-1;
  B10 = 2*rand(S1,1)-1;
  W20 = 2*rand(1,S1)-1;
  B20 = 2*rand(1,1)-1;
    
  set(W1_ptr,'userdata',W10);
  set(B1_ptr,'userdata',B10);
  set(W2_ptr,'userdata',W20);
  set(B2_ptr,'userdata',B20);
  
  cmd='update_plot';
  
    
%==================================================================
% Respond to hidden neuron slider.
%
% ME('i')
%==================================================================

elseif strcmp(cmd,'s1')
  
  i = get(i_bar,'value');
  s1 = get(s1_bar,'value');
  s1 = round(s1);
  set(s1_text,'string',sprintf('%g',s1))

  set(fig,'nextplot','add')
  delete(get(fa_axis,'children'))
  P = -2:(.4/i):2;
  T = 1 + sin(i*pi*P/4);
  axes(fa_axis)
  %plot(P,T,'color',nndkblue,'linewidth',3);
  plot(P,T,'color',nnblue,'linewidth',3);
  set(get(fa_axis,'ylabel'),...
    'string','Target')

  axes(fb_axis)
  delete(get(fb_axis,'children'))
  fb_plot = plot([P(1) P(end)],[0 0],'k');

  set(fig,'nextplot','new')

  set(lls_radiob,'value',0);
  set(ols_radiob,'value',0);
  set(rand_radiob,'value',0);
  set(but_train,'enable','off');  
  
  
%==================================================================
% Respond to difficulty index slider.
%
% ME('i')
%==================================================================

elseif strcmp(cmd,'i')
  
  i = get(i_bar,'value');
  i = round(i);
  set(i_text,'string',sprintf('%g',i))
  
  set(fig,'nextplot','add')
  delete(get(fa_axis,'children'))
  P = -2:(.4/i):2;
  T = 1 + sin(i*pi*P/4);
  axes(fa_axis)
  %plot(P,T,'color',nndkblue,'linewidth',3);
  plot(P,T,'color',nnblue,'linewidth',3);
  set(get(fa_axis,'ylabel'),...
    'string','Target')

  axes(fb_axis)
  delete(get(fb_axis,'children'))
  fb_plot = plot([P(1) P(end)],[0 0],'k');

  set(fig,'nextplot','new')

  set(lls_radiob,'value',0);
  set(ols_radiob,'value',0);
  set(rand_radiob,'value',0);
  set(but_train,'enable','off');  
  
  
%==================================================================
% Respond to train button.
%
% ME('train')
%==================================================================

elseif strcmp(cmd,'train') & ~isempty(fig) & (nargin == 1)

  set(but_train,'enable','off');  
    
  set(fig,'nextplot','add')
  
  set(fig,'pointer','watch')
  
  i = round(get(i_bar,'value'));

  P = -2:(.4/i):2;
  Pfine = -2:(.4/1000):2;
  T = 1 + sin(i*pi*P/4);
  [R,Q] = size(P);
  P2 = P;
  [R,Q2] = size(P2);
  [R,Q2fine] = size(Pfine);

  S1 = round(get(s1_bar,'value'));
  R = 1;
  S2 = 1;

  W10=get(W1_ptr,'userdata');
  B10=get(B1_ptr,'userdata');
  W20=get(W2_ptr,'userdata');
  B20=get(B2_ptr,'userdata');
  

  err_goal = 0.005;
  max_epoch = 200;
  mingrad=0.001;
  mu_initial=.01;
  v=10;
  maxmu=1e10;

  axes(fa_axis)
  %set(get(fa_axis,'children'));
  delete(get(fa_axis,'children'))
  
  delete(get(fb_axis,'children'))

  %A = W20*logsig(W10*P2+B10*ones(1,Q2))+B20*ones(1,Q2);
  pp2 = repmat(P2,S1,1);
  pp2fine = repmat(Pfine,S1,1);
  % If size of Input weights smaller than requested weights, we adjust W10
  if length(W10)<S1
      W10=[W10; zeros(S1-length(W10),1)];
      B10=[B10; zeros(S1-length(B10),1)];
      W20=[W20 zeros(S1-length(W20),1)];     
  end
  n12fine = abs(pp2fine-W10*ones(1,Q2fine)).*(B10*ones(1,Q2fine));
  a12fine = exp(-n12fine.^2);
  n12 = abs(pp2-W10*ones(1,Q2)).*(B10*ones(1,Q2));
  a12 = exp(-n12.^2);
  A = W20*a12 + B20*ones(1,Q2);
  Target = plot(P,T,'-','color',nnred,'linewidth',3);
  %Target = plot(P,T,'-','color',nndkblue,'linewidth',3);

  AA = A;
  %ind = find((AA < -0.01) | (AA > 2.01));
  %if length(ind)
  %  AA(ind) = AA(ind)+NaN;
  %end

  temp=[(W20'*ones(1,Q2)).*a12; B20*ones(1,Q2)];
  fa_plot2 = plot(P,temp,':k');
  
  Attempt = plot(P2,AA,'-','color',nndkblue,'linewidth',2);
  %Attempt = plot(P2,AA,'-','color',nnred,'linewidth',2);

  axes(fb_axis)
  fb_plot = plot(pp2fine(1,:),a12fine,'k');

  drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%% BEGINNING OF MARTIN'S CODE

% DEFINE SIZES
RS = S1*R; RS1 = RS+1; RSS = RS + S1; RSS1 = RSS + 1;
RSS2 = RSS + S1*S2; RSS3 = RSS2 + 1; RSS4 = RSS2 + S2;

%%%%%%%%%%%%%%%%%%%%%%%%%%

W1=W10;B1=B10;W2=W20;B2=B20;
dW1=W10;dB1=B10;dW2=W20;dB2=B20;

%%%%%%%%%%%%%%%%%%%%%%%%%%

mu=mu_initial;
ii=eye(RSS4);
meu=zeros(max_epoch,1);
mer=meu;grad=meu;
%A1 = logsig(W1*P+B1*ones(1,Q));
A1 = exp(-(abs(pp2-W1*ones(1,Q2)).*(B1*ones(1,Q2))).^2);
%A2 = W2*A1+B2*ones(1,Q);
A2 = W2*A1 + B2*ones(1,Q2);
E1 = T-A2;
%f1=sum(sum(E1.*E1));
f1=sum(sum(E1.*E1));
%flops(0);

% MAIN LOOP

t1=clock;
tstnan=0;
for k=1:max_epoch,
  mu=mu/v;
  mer(k)=f1;
  meu(k)=mu;
  tst=1;

% FIND JACOBIAN
  A1 = kron(A1,ones(1,S2));
  D2 = nnmdlin(A2);
  %D1 = nnmdlog(A1,D2,W2);
  SS2=-2*(abs(pp2-W1*ones(1,Q2)).*(B1*ones(1,Q2))).*A1.*(W2'*D2);
  den=abs(pp2-W1*ones(1,Q2));
  flg=den~=0;
  den=den+~flg;
  D1 = SS2.*((B1*ones(1,Q2)).*(W1*ones(1,Q2)-pp2)).*flg./den;
  D1b = SS2.*abs(pp2-W1*ones(1,Q2));
  %jac1 = nnlmarq(kron(P,ones(1,S2)),D1);
  jac1 = D1';
  jac2 = nnlmarq(A1,D2);
  %jac=[jac1,D1',jac2,D2'];
  jac=[jac1,D1b',jac2,D2'];

% CHECK THE MAGNITUDE OF THE GRADIENT
  E1=E1(:);
  je=jac'*E1;
  grad(k)=norm(je);
  if grad(k)<mingrad,
    mer=mer(1:k);
    meu=meu(1:k);
    grad=grad(1:k);
    disp('Training has stopped.')
    disp('Local minumum reached. Gradient is close to zero.')
    fprintf('Magnitude of gradient = %g.\n',grad(k));
    set(but_train,'enable','on');  
    break
  end

% INNER LOOP, INCREASE mu UNTIL THE ERRORS ARE REDUCED
  jj=jac'*jac;
  while tst>0,
    dw=-(jj+ii*mu)\je;
    % ODJ Under some conditions we may get NaN in dw, so we exit
    if isnan(dw)
      tstnan=1;
      tst=0;
    else
      dW1(:)=dw(1:RS);
      dB1=dw(RS1:RSS);
      dW2(:)=dw(RSS1:RSS2);
      dB2=dw(RSS3:RSS4);
      W1n=W1+dW1;B1n=B1+dB1;W2n=W2+dW2;
      B2n=B2+dB2;
      %A1 = logsig(W1n*P+B1n*ones(1,Q));
      A1 = exp(-(abs(pp2-W1n*ones(1,Q)).*(B1n*ones(1,Q))).^2);
      %A2 = W2n*A1+B2n*ones(1,Q);
      A2 = W2n*A1 + B2n*ones(1,Q);
      E2 = T-A2;
      %f2=sum(sum(E2.*E2));  
      f2=sum(sum(E2.*E2));  
      if f2>=f1,
        mu=mu*v;

%  TEST FOR MAXIMUM mu
        if (mu > maxmu),
          mer=mer(1:k);
          meu=[meu(1:k);mu];
          grad=grad(1:k);
          disp('Maximum mu exceeded.')
          fprintf('mu = %g.\n',mu);
          fprintf('Maximum allowable mu = %g.\n',maxmu);
          set(but_train,'enable','on');  
          break;
        end
      else
        tst=0;
      end
    end            
  end
  
  if tstnan
      set(but_train,'enable','on');  
      break;
  end

%  TEST IF THE ERROR REACHES THE ERROR GOAL
  if f2<=err_goal,
    f1=f2;
    W1=W1n;B1=B1n;W2=W2n;B2=B2n;
    mer=[mer(1:k);f2];
    meu=[meu(1:k);mu];
    grad=grad(1:k);
    disp('Training has stopped. Goal achieved.')
    set(but_train,'enable','on');  
    break; 
  end

  if(mu>maxmu),
    set(but_train,'enable','on');  
    break;
  end

  W1=W1n;B1=B1n;W2=W2n;B2=B2n;E1=E2;
  f1=f2;

  %%%%%%%%%%%%%%%%%%%%%%%%% PLOTTING ALTERED BY MARK
  if (R==1)&(S2==1),
    n12fine = abs(pp2fine-W1*ones(1,Q2fine)).*(B1*ones(1,Q2fine));
    a12fine = exp(-n12fine.^2);
    n12 = abs(pp2-W1*ones(1,Q2)).*(B1*ones(1,Q2));
    a12 = exp(-n12.^2);
    %A = W2*logsig(W1*P2+B1*ones(1,Q2))+B2*ones(1,Q2);
    A = W2*a12 + B2*ones(1,Q2);
    set(Attempt,'color',nnltyell);
    set(Attempt,'visible','off');
    %set(Target,'color',nnred);
    set(Target,'color',nndkblue);

    temp=[(W2'*ones(1,Q2)).*a12; B2*ones(1,Q2)];
    for ktemp=1:length(fa_plot2)
       set(fa_plot2(ktemp),'ydata',temp(ktemp,:));     
    end
    for ktemp=1:length(fb_plot)
       set(fb_plot(ktemp),'ydata',a12fine(ktemp,:));     
    end
   %fa_plot2 = plot(P,temp,':k');
      
    AA = A;
    ind = find((AA < -0.01) | (AA > 2.01));
    if length(ind)
      AA(ind) = AA(ind)+NaN;
    end
    set(Attempt,'ydata',AA);
    set(Attempt,'color',nndkblue,'visible','on');
    %set(Attempt,'color',nnred,'visible','on');
    drawnow
  end
  
  pause(0.025);

end

%%%%%%%%%%%%%%%%%%%%%%%%%% END OF MARTIN'S CODE

    n12 = abs(pp2-W1*ones(1,Q2)).*(B1*ones(1,Q2));
    a12 = exp(-n12.^2);
    %A = W2*logsig(W1*P2+B1*ones(1,Q2))+B2*ones(1,Q2);
    A = W2*a12 + B2*ones(1,Q2);
    set(Attempt,'color',nnltyell);
    set(Attempt,'visible','off');
    %set(Target,'color',nnred);
    set(Target,'color',nndkblue);

    temp=[(W2'*ones(1,Q2)).*a12; B2*ones(1,Q2)];
    for ktemp=1:length(fa_plot2)
       set(fa_plot2(ktemp),'ydata',temp(ktemp,:));     
    end
    %fa_plot2 = plot(P,temp,':k');
      
    AA = A;
    ind = find((AA < -0.01) | (AA > 2.01));
    if length(ind)
      AA(ind) = AA(ind)+NaN;
    end
    set(Attempt,'ydata',AA);
    set(Attempt,'color',nndkblue,'visible','on');
    %set(Attempt,'color',nnred,'visible','on');
    drawnow

  set(fig,'nextplot','new')
  
  if (k==max_epoch),
    disp('Training has stopped.')
    disp('Maximum number of epochs was reached.')
    fprintf('epochs = %g.\n',k);
    fprintf('Final error = %g.\n',f2);
  end

  %set(lls_radiob,'value',0);
  %set(ols_radiob,'value',0);
  %set(rand_radiob,'value',0);
  
  set(fig,'pointer','arrow')
  set(but_train,'enable','on');  

end



if strcmp(cmd,'update_plot')
  set(fig,'nextplot','add')
  delete(get(fa_axis,'children'))
  P = -2:(.4/i):2;
  Pfine = -2:(.4/1000):2;
  T = 1 + sin(i*pi*P/4);
  axes(fa_axis)
  %plot(P,T,'color',nndkblue,'linewidth',3);
  plot(P,T,'color',nnblue,'linewidth',3);
  set(get(fa_axis,'ylabel'),...
    'string','Target')

  delete(get(fb_axis,'children'))

  [R,Q2] = size(P);
  [R,Q2fine] = size(Pfine);
  pp2 = repmat(P,S1,1);
  pp2fine = repmat(Pfine,S1,1);

  if length(W10)<S1
      W10=[W10; zeros(S1-length(W10),1)];
      B10=[B10; zeros(S1-length(B10),1)];
      W20=[W20 zeros(S1-length(W20),1)];     
  end
  n12fine = abs(pp2fine-W10*ones(1,Q2fine)).*(B10*ones(1,Q2fine));
  a12fine = exp(-n12fine.^2);
  n12 = abs(pp2-W10*ones(1,Q2)).*(B10*ones(1,Q2));
  a12 = exp(-n12.^2);
  %A = W20*exp(-(abs(pp2-W10*ones(1,Q2)).*(B10*ones(1,Q2))).^2) + B20*ones(1,Q2);
  A = W20*a12 + B20*ones(1,Q2);
  %set(Attempt,'color',nnltyell);
  %set(Attempt,'visible','off');
  %set(Target,'color',nnred);

  AA = A;
  %ind = find((AA < -0.01) | (AA > 2.01));
  %if length(ind)
  %  AA(ind) = AA(ind)+NaN;
  %end
  
  temp=[(W20'*ones(1,Q2)).*a12; B20*ones(1,Q2)];
  fa_plot2 = plot(P,temp,':k');
  
  Attempt = plot(P,AA,'-','color',nndkblue,'linewidth',2);
  %Attempt = plot(P,AA,'-','color',nnred,'linewidth',2);
  %set(Attempt,'ydata',AA);
  %set(Attempt,'color',nndkblue,'visible','on');

  axes(fb_axis)
  fb_plot = plot(pp2fine(1,:),a12fine,'k');
  
  drawnow

  set(but_train,'enable','on');

  set(fig,'nextplot','new')
end
