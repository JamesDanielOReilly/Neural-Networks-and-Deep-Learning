function nnd17ols(cmd,arg1)
%NND17OLS Orthogonal Least Squares.
%  This demonstration requires the Neural Network Toolbox.

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% $Revision: 1.8 $
% First Version, 8-31-95.

%==================================================================

% CONSTANTS
me = 'nnd17ols';
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
%  s1_bar = H(3);              % lr slider bar
  s1_text = H(3);             % lr text
  fa_axis = H(4);             % function approximation axis
  fa_ptr = H(5);              % function approximation plot handles
  fa_ptr2 = H(6);              % function approximation plot handles
  fa_ptr3 = H(7);              % function approximation plot handles
  fa_ptr4 = H(8);              % function approximation plot handles
  fb_axis = H(9);             % function approximation axis
  fb_ptr = H(10);              % function approximation plot handles
  sigma_bar = H(11);               % Difficulty slider bar
  sigma_text = H(12);              % Difficuly text
  npts_bar = H(13);               % Difficulty slider bar
  npts_text = H(14);              % Difficuly text
  freq_bar = H(15);               % Difficulty slider bar
  freq_text = H(16);              % Difficuly text
  phase_bar = H(17);               % Difficulty slider bar
  phase_text = H(18);              % Difficuly text
  bias_bar = H(19);
  bias_text = H(20);
  bias_checkbox = H(21);
  %w1_1_bar = H(23);
  %w1_1_text = H(24);
  s1calc_text = H(22);             % lr text
  rand_ptr = H(23);
  add_button = H(24);
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

  % NEW DEMO FIGURE
  fig = nndemof2(me,'DESIGN','RBF Orthogonal Least Sq.','','Chapter 17');
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
  S1 = 0;
  x = 20;
  y = 115;
  len = 100;
  text(x-10,y+12,'Hidden Neurons:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  text(x+10,y-20,'Calculated:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',9,...
    'horizontalalignment','left')
%  text(x-10,y,'Neurons',...
%    'color',nndkblue,...
%    'fontw','bold',...
%    'fontsize',10,...
%    'horizontalalignment','left')
  text(x+10,y-5,'Requested:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',9,...
    'horizontalalignment','left')
  s1_text = text(x+len-20,y-5,num2str(S1),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  s1calc_text = text(x+len-20,y-20,num2str(max([0 S1-1])),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  %text(x,y-38,'0',...
  %  'color',nndkblue,...
  %  'fontw','bold',...
  %  'fontsize',12,...
  %  'horizontalalignment','left')
  %text(x+len,y-38,'9',...
  %  'color',nndkblue,...
  %  'fontw','bold',...
  %  'fontsize',12,...
  %  'horizontalalignment','right');
  %s1_bar = uicontrol(...
  %  'units','points',...
  %  'position',[x y-25 len 16],...
  %  'style','slider',...
  %  'backg',nnltgray,...
  %  'callback',[me '(''s1'')'],...
  %  'min',0,...
  %  'max',9,...
  %  'value',S1);

  % standard deviation of noise to be added to training data sliding bar.
  sigma = 0; %0;
  x = 20;
  y = 55;
  len = 100;
  text(x,y,'Stdv noise:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  sigma_text = text(x+len,y,num2str(sigma),...
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
  sigma_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''sigma'')'],...
    'min',0,...
    'max',1,...
    'value',sigma);

  % Number of Points SLIDER BAR
  npts = 10;
  x = 130;
  y = 115;
  len = 100;
  text(x,y,'Number of Points:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  npts_text = text(x+len,y,num2str(npts),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-38,'2',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+len,y-38,'20',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  npts_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''npts'')'],...
    'min',2,...
    'max',20,...
    'value',npts);

  % frequency of the function to be fit sliding bar.
  freq = 1/2; %1/8;
  x = 130;
  y = 55;
  len = 100;
  text(x,y,'Function Freq.:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  freq_text = text(x+len,y,num2str(freq),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-38,'.25',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+len,y-38,'1',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  freq_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''freq'')'],...
    'min',0.25,...
    'max',1,...
    'value',freq);

  % phase of the function to be fit sliding bar.
  phase = 90;
  x = 240;
  y = 55;
  len = 100;
  text(x,y,'Function Phase:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  phase_text = text(x+len,y,num2str(phase),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-38,'0',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+len,y-38,'360',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  phase_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''phase'')'],...
    'min',0,...
    'max',360,...
    'value',phase);

  % FUNCTION APPROXIMATION
%  i=1;
%  P = -2:(.4/i):2;
%  T = 1 + sin(pi*P/4);
  
  % Initial parameters
  range = [-2 2];
  
  d1 = (range(2)-range(1))/(npts-1);
  p = range(1):d1:range(2);
  %t = sin(2*pi*(freq*p + phase/360))+1 + sigma*randn(size(p));
  randseq=randn(1,20);
  t = sin(2*pi*(freq*p + phase/360))+1 + sigma*randseq(1:length(p));
  c=p;
  b = ones(size(c));
  n=S1;
  
  [W1,b1,W2,b2,mf,of,indf] = rb_ols(p,t,c,b,n,0);
  S1=length(W1);
  
  %delta = (range(2)-range(1))/(S1-1);
  %b=sqrt(S1)/delta;
  
  total = range(2)-range(1);
  %W1 = range(1):delta:range(2);
  %W1 = W1(1:(end))';
  %b1 = b*ones(size(W1));
  Q = length(p);
  pp = repmat(p,S1,1); 
  if S1==0
      n1=0;
      a1=0;
      a2=0;
  else
      n1 = abs(pp-W1*ones(1,Q)).*(b1*ones(1,Q));
      a1 = exp(-n1.^2);
      a2 = W2*a1 + b2*ones(1,Q);
  end
  p2 = range(1):(total/1000):range(2);
  Q2 = length(p2);
  pp2 = repmat(p2,S1,1);
  if S1==0
      n12=0;
      a12=0;
      a22=0;
  else
      n12 = abs(pp2-W1*ones(1,Q2)).*(b1*ones(1,Q2));
      a12 = exp(-n12.^2);
      a22 = W2*a12 + b2*ones(1,Q2);
  end
  t_exact = sin(2*pi*(freq*p2 + phase/360))+1;
  if S1==0
      temp=0;
  else
      temp=[(W2'*ones(1,Q2)).*a12; b2*ones(1,Q2)];
  end
  %sse = sumsqr(t-a2);
  sse = sum(sum((t-a2).*(t-a2)));
  
  fa_axis = nnsfo('a2','Function Approximation','','a^2','');
  set(fa_axis,...
    'position',[50 220 270 120])
  %fa_plot =  plot(P,T,'+','color',nnred);
  fa_plot = plot(p,t,'ok');
  hold on
  fa_plot2 = plot(p2,temp,':k');
  fa_plot3 = plot(p2,t_exact,'b','LineWidth',2);
  fa_plot4 = plot(p2,a22,'r','LineWidth',1);
  hold off
  set(fa_axis,'ylim',[-2 4])
  
  fb_axis = nnsfo('a2','','p','a^1','');
  set(fb_axis,...
    'position',[50 160 270 40])
  fb_plot = plot(p2,a12,'k');
  
  % We change current axis to figure axis handle 
  axes(fig_axis)
  
  % bias of the function to be fit sliding bar.
  bias = 1;
  x = 240;
  y = 115;
  len = 100;
  text(x,y,'bias:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  bias_text = text(x+len,y,num2str(round(bias*100)/100),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  text(x,y-38,'0.1',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+len,y-38,'10',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right');
  bias_bar = uicontrol(...
    'units','points',...
    'position',[x y-25 len 16],...
    'style','slider',...
    'backg',nnltgray,...
    'callback',[me '(''bias'')'],...
    'min',0.1,...
    'max',10,...
    'value',bias,...
    'enable','off');
  bias_checkbox = uicontrol(...
    'units','points',...
    'position',[x+25 y-45 50 16],...
    'style','checkbox',...
    'backg',nnltgray,...
    'callback',[me '(''bias_checkbox'')'],...
    'string','bias auto',...
    'value',1);




  % Initial Center for the first basis function sliding bar.
%  w1_1 = W1(1);
%  x = 340;
%  y = 170;
%  len = 70;
%  text(x-25,y-35,'W1(1,1):',...
%    'color',nndkblue,...
%    'fontw','bold',...
%    'fontsize',10,...
%    'horizontalalignment','left')
%  w1_1_text = text(x+15,y-35,num2str(round(w1_1*100)/100),...
%    'color',nndkblue,...
%    'fontw','bold',...
%    'fontsize',12,...
%    'horizontalalignment','left');
%  text(x+20,y-20,'-2',...
%    'color',nndkblue,...
%    'fontw','bold',...
%    'fontsize',12,...
%    'horizontalalignment','left')
%  text(x+30,y-28+len,'2',...
%    'color',nndkblue,...
%    'fontw','bold',...
%    'fontsize',12,...
%    'horizontalalignment','right');
%  w1_1_bar = uicontrol(...
%    'units','points',...
%    'position',[x y-25 16 len],...
%    'style','slider',...
%    'backg',nnltgray,...
%    'callback',[me '(''w1_1'')'],...
%    'min',-2,...
%    'max',2,...
%    'value',w1_1);

  % BUTTONS
  uicontrol(...
    'units','points',...
    'position',[400 145 60 20],...
    'string','Reset',...
    'callback',[me '(''reset'')'])
  add_button=uicontrol(...
    'units','points',...
    'position',[400 115 60 20],...
    'string','Add Neuron',...
    'callback',[me '(''add'')']);
  uicontrol(...
    'units','points',...
    'position',[400 85 60 20],...
    'string','Contents',...
    'callback','nndtoc')
  uicontrol(...
    'units','points',...
    'position',[400 55 60 20],...
    'string','Close',...
    'callback',[me '(''close'')'])

  % DATA POINTERS
  fa_ptr = uicontrol('visible','off','userdata',fa_plot);
  fa_ptr2 = uicontrol('visible','off','userdata',fa_plot2);
  fa_ptr3 = uicontrol('visible','off','userdata',fa_plot3);
  fa_ptr4 = uicontrol('visible','off','userdata',fa_plot4);
  fb_ptr = uicontrol('visible','off','userdata',fb_plot);

  rand_ptr = uicontrol('visible','off','userdata',randseq);

  % SAVE WINDOW DATA AND LOCK
  H = [fig_axis desc_text s1_text fa_axis fa_ptr fa_ptr2 fa_ptr3 ...
       fa_ptr4 fb_axis fb_ptr sigma_bar sigma_text npts_bar npts_text ...
       freq_bar freq_text phase_bar phase_text ...
       bias_bar bias_text bias_checkbox s1calc_text rand_ptr add_button];
%       bias_bar bias_text bias_checkbox w1_1_bar w1_1_text s1calc_text];
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
    'Use the slider bars',...
    'to choose network',...
    'or function values',...
    '',...
    'Click [Add Neuron]',...
    'to increase size',...
    'of Hidden layer and',...
    'update plots',...
    '',...
    'Click [Reset] to',...
    'initialize menu values',...
    '',...
    'Blue - Function',...
    'Red - Network Response')
    

%==================================================================
% Respond to hidden neuron slider.
%
% ME('s1')
%==================================================================

%elseif strcmp(cmd,'s1')
  
%  if strcmp(get(s1_bar,'enable'),'off')
%      return
%  end
%  set(s1_bar,'enable','off');
%  s1 = get(s1_bar,'value');
%  s1 = round(s1);
%  set(s1_text,'string',sprintf('%g',s1))

%  cmd='update';
  
%==================================================================
% Respond to difficulty index slider.
%
% ME('sigma')
%==================================================================

elseif strcmp(cmd,'sigma')
  
  if strcmp(get(sigma_bar,'enable'),'off')
      return
  end
  set(sigma_bar,'enable','off');
  sigma = get(sigma_bar,'value');
  sigma = round(sigma*10)/10;
  set(sigma_text,'string',sprintf('%g',sigma))
  
  % With new sigma value, we change random sequence
  randseq = randn(1,20);
  set(rand_ptr,'userdata',randseq);

  set(s1_text,'string','0')
  set(s1calc_text,'string','0')

  cmd='update';
  
%==================================================================
% Respond to Number of Points slider.
%
% ME('npts')
%==================================================================

elseif strcmp(cmd,'npts')
  
  if strcmp(get(npts_bar,'enable'),'off')
      return
  end
  set(npts_bar,'enable','off');
  npts = get(npts_bar,'value');
  npts = round(npts);
  set(npts_text,'string',sprintf('%g',npts))
  
  set(s1_text,'string','0')
  set(s1calc_text,'string','0')
  cmd='update';
  
%==================================================================
% Respond to Frequency slider.
%
% ME('freq')
%==================================================================

elseif strcmp(cmd,'freq')
  
  if strcmp(get(freq_bar,'enable'),'off')
      return
  end
  set(freq_bar,'enable','off');
  freq = get(freq_bar,'value');
  freq = round(freq*100)/100;
  set(freq_text,'string',sprintf('%g',freq))
  
  set(s1_text,'string','0')
  set(s1calc_text,'string','0')
  cmd='update';
  
%==================================================================
% Respond to phase slider.
%
% ME('phase')
%==================================================================

elseif strcmp(cmd,'phase')
  
  if strcmp(get(phase_bar,'enable'),'off')
      return
  end
  set(phase_bar,'enable','off');
  phase = get(phase_bar,'value');
  phase = round(phase);
  set(phase_text,'string',sprintf('%g',phase))
  
  set(s1_text,'string','0')
  set(s1calc_text,'string','0')
  cmd='update';
  
  
%==================================================================
% Respond to bias slider.
%
% ME('bias')
%==================================================================

elseif strcmp(cmd,'bias')
  
  if strcmp(get(bias_bar,'enable'),'off')
      return
  end
  set(bias_bar,'enable','off');
  bias = get(bias_bar,'value');
  bias = round(bias*100)/100;
  set(bias_text,'string',sprintf('%g',bias))
  
  set(s1_text,'string','0')
  set(s1calc_text,'string','0')
  cmd='update';
  
  
%==================================================================
% Respond to bias checkbox.
%
% ME('bias_checkbox')
%==================================================================

elseif strcmp(cmd,'bias_checkbox')
  
  if get(bias_checkbox,'value') == 1
      set(bias_bar,'enable','off');
  else
      set(bias_bar,'enable','on');
      bias = get(bias_bar,'value');
      bias = round(bias*100)/100;
      set(bias_text,'string',sprintf('%g',bias))
  end
  
  set(s1_text,'string','0')
  set(s1calc_text,'string','0')
  cmd='update';
  
  
%==================================================================
% Respond to w1_1 slider.
%
% ME('w1_1')
%==================================================================

%elseif strcmp(cmd,'w1_1')
  
%  if strcmp(get(w1_1_bar,'enable'),'off')
%      return
%  end
%  set(w1_1_bar,'enable','off');
%  w1_1 = get(w1_1_bar,'value');
%  w1_1 = round(w1_1*10)/10;
%  set(w1_1_text,'string',sprintf('%g',w1_1))
  
%  cmd='update';

%==================================================================
% Respond to Add Neuron button.
%
% ME('add')
%==================================================================

elseif strcmp(cmd,'add')
  set(add_button,'enable','off')
  s1 = str2num(get(s1_text,'string'));
  s1 = round(s1);
  s1=s1+1;
  set(s1_text,'string',sprintf('%g',s1))
  %set(s1_bar,'value',s1)

  cmd='update';

%==================================================================
% Respond to reset button.
%
% ME('reset')
%==================================================================

elseif strcmp(cmd,'reset')
  
  if strcmp(get(sigma_bar,'enable'),'off') | strcmp(get(npts_bar,'enable'),'off') ...
     | (strcmp(get(bias_bar,'enable'),'off') & get(bias_checkbox,'value') == 0) ...
     | strcmp(get(freq_bar,'enable'),'off') | strcmp(get(phase_bar,'enable'),'off')
      return
  end
%  set(s1_bar,'enable','off');
  set(sigma_bar,'enable','off');
  set(npts_bar,'enable','off');
  set(bias_bar,'enable','off');
  set(freq_bar,'enable','off');
  set(phase_bar,'enable','off');
  S1 = 0;
%  set(s1_bar,'value',S1);
  set(s1_text,'string',sprintf('%g',S1))
  sigma = 0;
  set(sigma_bar,'value',sigma);
  set(sigma_text,'string',sprintf('%g',sigma))
  npts = 10;
  set(npts_bar,'value',npts);
  set(npts_text,'string',sprintf('%g',npts))
  freq = 1/2;
  set(freq_bar,'value',freq);
  set(freq_text,'string',sprintf('%g',freq))
  phase = 90;
  set(phase_bar,'value',phase);
  set(phase_text,'string',sprintf('%g',phase))
  range = [-2 2];
  %delta = (range(2)-range(1))/(S1-1);
  %bias=sqrt(S1)/delta;
  bias=1;
  set(bias_bar,'value',bias);
  set(bias_text,'string',sprintf('%g',round(bias*100)/100))
  %set(w1_1_bar,'value',range(1));
  %set(w1_1_text,'string',sprintf('%g',round(range(1)*10)/10))
  
  cmd='update';

end

%==================================================================
% Train and update the figures.
%
% ME('update')
%==================================================================

if strcmp(cmd,'update')
  S1=str2num(get(s1_text,'string'));
  npts=str2num(get(npts_text,'string'));
  phase=str2num(get(phase_text,'string'));
  freq=str2num(get(freq_text,'string'));
  sigma=str2num(get(sigma_text,'string'));
  bias=str2num(get(bias_text,'string'));
  %w1_1=str2num(get(w1_1_text,'string'));
  range = [-2 2];

  d1 = (range(2)-range(1))/(npts-1);
  p = range(1):d1:range(2);
  %t = sin(2*pi*(freq*p + phase/360))+1 + sigma*randn(size(p));
  randseq = get(rand_ptr,'userdata');
  t = sin(2*pi*(freq*p + phase/360))+1 + sigma*randseq(1:length(p));
  c=p;
  if get(bias_checkbox,'value') == 1
      b = ones(size(c));
  else
      b = ones(size(c))*bias;
  end
  n=S1;
  
  [W1,b1,W2,b2,mf,of,indf] = rb_ols(p,t,c,b,n,0);
  
  S1=length(W1);
  set(s1calc_text,'string',num2str(S1));
  %delta = (range(2)-w1_1)/(S1-1);
  %if get(bias_checkbox,'value') == 1
  %    b=sqrt(S1)/delta;
  %    bias=b;
  %    set(bias_text,'string',sprintf('%g',round(bias*100)/100))
  %else
  %    set(bias_bar,'value',bias);
  %    set(bias_text,'string',sprintf('%g',round(bias*100)/100))
  %    b=bias;       %sqrt(S1)/delta;
  %end
  
  total = range(2)-range(1);
  %W1 = w1_1:delta:range(2);
  %W1 = W1(1:(end))';
  %b1 = b*ones(size(W1));
  Q = length(p);
  pp = repmat(p,S1,1); 
  if S1==0
      n1=0;
      a1=0;
      a2=b2*ones(1,Q);
%      p2=0;
  else
      n1 = abs(pp-W1*ones(1,Q)).*(b1*ones(1,Q));
      a1 = exp(-n1.^2);
      a2 = W2*a1 + b2*ones(1,Q);
  end
  p2 = range(1):(total/1000):range(2);  
  Q2 = length(p2);  
  if S1==0
      pp2=0;
      n12=0;
      a12=0;
      a22=b2*ones(1,Q2);
  else
      pp2 = repmat(p2,S1,1);
      n12 = abs(pp2-W1*ones(1,Q2)).*(b1*ones(1,Q2));
      a12 = exp(-n12.^2);
      a22 = W2*a12 + b2*ones(1,Q2); 
  end
  t_exact = sin(2*pi*(freq*p2 + phase/360))+1;
  if S1==0
      temp=[b2*ones(1,Q2)];
  else
      temp=[(W2'*ones(1,Q2)).*a12; b2*ones(1,Q2)];
  end
  %sse = sumsqr(t-a2);
  sse = sum(sum((t-a2).*(t-a2)));
  
  set(fig,'nextplot','add')
  delete(get(fa_axis,'children'))
  axes(fa_axis)
  cc=get(fa_axis,'color');
  fa_plot = plot(p,t,'ok');
  hold on
  fa_plot2 = plot(p2,temp,':k');
  fa_plot3 = plot(p2,t_exact,'b','LineWidth',2);
  fa_plot4 = plot(p2,a22,'r','LineWidth',1);
  hold off
  set(fa_axis,'color',cc);
  set(get(fa_axis,'ylabel'),...
    'string','a^2','FontSize',12,'FontWeight','bold')
  set(get(fa_axis,'title'),...
    'string','Function Approximation','FontSize',12,'FontWeight','bold')
  set(fa_axis,'ylim',[-2 4])
  
  delete(get(fb_axis,'children'))
  axes(fb_axis)
  fb_plot = plot(p2,a12,'k');

  %fa_plot=get(fa_ptr,'userdata');
  %set(fa_plot,'xdata',p,'ydata',t);
  %fa_plot2=get(fa_ptr2,'userdata');
  %set(fa_plot2,'xdata',p2,'ydata',temp);
  %fa_plot3=get(fa_ptr3,'userdata');
  %set(fa_plot3,'xdata',p2,'ydata',t_exact);
  %fa_plot4=get(fa_ptr4,'userdata');
  %set(fa_plot4,'xdata',p2,'ydata',a22);

  %fb_plot=get(fb_ptr,'userdata');
  %set(fb_plot,'xdata',p2,'ydata',a12);

  % DATA POINTERS
  set(fa_ptr,'userdata',fa_plot);
  set(fa_ptr2,'userdata',fa_plot2);
  set(fa_ptr3,'userdata',fa_plot3);
  set(fa_ptr4,'userdata',fa_plot4);
  set(fb_ptr,'userdata',fb_plot);

  % SAVE WINDOW DATA AND LOCK
  H = [fig_axis desc_text s1_text fa_axis fa_ptr fa_ptr2 fa_ptr3 ...
       fa_ptr4 fb_axis fb_ptr sigma_bar sigma_text npts_bar npts_text ...
       freq_bar freq_text phase_bar phase_text ...
       bias_bar bias_text bias_checkbox s1calc_text rand_ptr add_button];
%       bias_bar bias_text bias_checkbox w1_1_bar w1_1_text s1calc_text];
  set(fig,'userdata',H,'nextplot','new')

  set(sigma_bar,'enable','on');
%  set(s1_bar,'enable','on');
  set(npts_bar,'enable','on');
  set(freq_bar,'enable','on');
  set(phase_bar,'enable','on');
  set(add_button,'enable','on')
%  set(w1_1_bar,'enable','on');
  if get(bias_checkbox,'value') == 0
      set(bias_bar,'enable','on');
  end
end

