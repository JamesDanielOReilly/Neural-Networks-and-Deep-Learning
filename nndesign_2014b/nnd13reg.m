function nnd13reg(cmd,arg1)
%NND13REG Generalization demonstration.
%  This demonstration requires the Neural Network Toolbox.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% $Revision: 1.8 $
% First Version, 8-31-95.

%==================================================================

% CONSTANTS
me = 'nnd13reg';
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
  ab_bar = H(3);              % lr slider bar
  ab_text = H(4);             % lr text
  fa_axis = H(5);             % function approximation axis
  fa_ptr = H(6);              % function approximation plot handles
  i_bar = H(7);               % Noise Standard Deviation slider bar
  i_text = H(8);              % Noise Standard Deviation text
  fa_plot = H(9);
  ff_plot = H(10);
  func_test = H(11);
  b1_plot = H(12);
  b2_plot = H(13);
  point_ptr = H(14);
  train_button = H(15);
end

%==================================================================
% Activate the window.
%
% ME() or ME('')
%==================================================================

if strcmp(cmd,'')
  if ~isempty(fig)
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

  % NEW DEMO FIGURE
  fig = nndemof2(me,'DESIGN','Regularization','','Chapter 13');
  set(fig, ...
    'windowbuttondownfcn',nncallbk(me,'down'), ...
    'BackingStore','off',...
    'nextplot','add');
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);

  % ICON
  nndicon(13,458,363,'shadow')

  % REGULARIZATION RATIO
  ab = 0.25;
  x = 20;
  y = 115;
  len = 320;
  text(x,y,'Regularization Ratio:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  ab_text = text(x+len,y,sprintf('%4.2g',ab),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-38,'0',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+len,y-38,'1',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  ab_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''ab'')'],...
    'min',0,...
    'max',1,...
    'value',ab);

  % NOISE STANDARD DEVIATION SLIDER BAR
  i = 1;
  x = 20;
  y = 55;
  len = 320;
  text(x,y,'Noise Standard Deviation:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
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

  % FUNCTION APPROXIMATION
  i=1;
  tp = 2;
  P = [-1:.1:1];
  T = sin(2*pi*P/tp) + randn(size(P))*0.2*i;
  pp = [-1:.01:1];
  tt = sin(2*pi*pp/tp);
  fa_axis = nnsfo('a2','Function Approximation','Input','Target','');
  set(fa_axis,...
    'position',[50 160 270 170],...
    'ylim',[-2 2])
  fa_plot =  plot(P,T,'ok');
  set(fa_plot,'MarkerSize',9);
  hold on
  func_test = plot(pp,tt,'k');
  ff_plot = plot(pp,tt,'b');
  b1_plot = plot(P,T,'ok');
  set(b1_plot,'visible','off');
  b2_plot = plot(P,T,'+k');
  set(b2_plot,'visible','off');
  set(ff_plot,'LineWidth',2);
  hold off

  % BUTTONS
  train_button=uicontrol(...
    'units','points',...
    'position',[400 145 60 20],...
    'string','Train',...
    'callback',[me '(''train'')']);
  uicontrol(...
    'units','points',...
    'position',[400 110 60 20],...
    'string','Contents',...
    'callback','nndtoc')
  uicontrol(...
    'units','points',...
    'position',[400 75 60 20],...
    'string','Close',...
    'callback',[me '(''close'')'])

  % DATA POINTERS
  fa_ptr = uicontrol('visible','off','userdata',fa_plot);

  % DATA POINTER: CURRENT POINT
  point_ptr = nnsfo('data');
  set(point_ptr,'userdata',[P T pp tt]);

  % SAVE WINDOW DATA AND LOCK
  H = [fig_axis desc_text ab_bar ab_text fa_axis fa_ptr i_bar i_text ...
       fa_plot ff_plot func_test b1_plot b2_plot point_ptr train_button];
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
    'Click the [Train]',...
    'button to train the',...
    'network on the noisy',...
    'data points at left.',...
    '',...
    'Use the slide bars',...
    'to choose the',...
    'Regularization Ratio',...
    'and the Noise',...
    'Standard Deviation',...
    'of the function.')
    

%==================================================================
% Respond to Regularization Ratio slider.
%
% ME('ab')
%==================================================================

elseif strcmp(cmd,'ab')
  
  ab = round(get(ab_bar,'value')*1000)/1000;
  %ab = round(ab);
  set(ab_text,'string',sprintf('%4.3g',ab))
  
  set(func_test,'ydata',get(ff_plot,'ydata'));
  set(b1_plot,'visible','off');
  set(b2_plot,'visible','off');

%==================================================================
% Respond to Noise Standard Deviation slider.
%
% ME('i')
%==================================================================

elseif strcmp(cmd,'i')
  
  i = get(i_bar,'value');
  i = round(i);
  set(i_text,'string',sprintf('%g',i))
  
  set(fig,'nextplot','add')
  %delete(get(fa_axis,'children'))
  tp = 2;
  P = [-1:.1:1];
  T = sin(2*pi*P/tp) + randn(size(P))*0.2*i;
  pp = [-1:.01:1];
  tt = sin(2*pi*pp/tp);
  set(point_ptr,'userdata',[P T pp tt]);
  
  set(fa_plot,'ydata',T);
  set(ff_plot,'ydata',tt);
  set(func_test,'ydata',tt);
  set(b1_plot,'ydata',T,'visible','off');
  set(b2_plot,'ydata',T,'visible','off');
  %axes(fa_axis)
  %plot(P,T,'+','color',nnred);
  %set(get(fa_axis,'ylabel'),...
  %  'string','Target')
  set(fig,'nextplot','new')

%==================================================================
% Respond to train button.
%
% ME('train')
%==================================================================

elseif strcmp(cmd,'train') & ~isempty(fig) & (nargin == 1)

  set(train_button,'enable','off');
  set(ab_bar,'enable','off');
  set(i_bar,'enable','off');

  set(fig,'nextplot','add')
  
  set(fig,'pointer','watch')

  i = round(get(i_bar,'value'));
  %P = -2:(.4/i):2;
  %T = 1 + sin(i*pi*P/4);
  %[R,Q] = size(P);
  %P2 = -2:(.04/i):2;
  %[R,Q2] = size(P2);

  ab = round(get(ab_bar,'value')*1000)/1000;
  
  tp = 2;
  
  temp = get(point_ptr,'userdata');
  P=temp(1:21);
  T=temp((21+1):21*2);
  pp=temp((21*2+1):(21*2+201));
  tt=temp((21*2+201+1):end);

  trainParam = nnd13train_marq('pdefaults');
  trainParam.mingrad = 1e-7;
  trainParam.ro = ab;
  trainParam.max_epoch = 500;
  trainParam.S1 = 20;
  trainParam.seed = 70312;

  temp = cputime;
  temp = temp-fix(temp);
  temp = temp*100000;
  randn('seed',temp);


  TT.P = pp;
  TT.T = tt;
  [net,tr] = nnd13train_marq(trainParam,P,T,[],TT,func_test,[],[],0.01,b1_plot,b2_plot,[]);

  set(fig,'pointer','arrow')
  set(train_button,'enable','on');
  set(ab_bar,'enable','on');
  set(i_bar,'enable','on');
  
end


