function nnd13breg(cmd,data)
%NND13BREG Steepest descent demonstration.

% $Revision: 1.6 $
% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% First Version, 8-31-95.

%==================================================================

% BRING UP FIGURE IF IT EXISTS

me = 'nnd13breg';
fig = nndfgflg(me);
if length(get(fig,'children')) == 0, fig = 0; end
if nargin == 0, cmd = ''; end

% CONSTANTS
max_update = 20;
xlim = [-1 1]; 
ylim = [-1.5 1.5]; %dy = 0.2;
%zlim = [0 12];
%xpts = xlim(1):dx:xlim(2);
%ypts = ylim(1):dy:ylim(2);
%[X,Y] = meshgrid(xpts,ypts);
xtick = [-1 -0.5 0 0.5 1];
ytick = [-1.5 -1 -0.5 0 0.5 1 1.5];
%ztick = [0 6 12];
%circle_size = 8;

% CREATE FIGURE ========================================================

if fig == 0

  % CONSTANTS
  S1 = 20;
  S1_min = 2;
  S1_max = 40;
  % CONSTANTS
  di = 1;
  di_min = 0.1;
  di_max = 3;
  % CONSTANTS
  f = 1;
  f_min = 0.5;
  f_max = 4;
  % CONSTANTS
  dd = 21;
  dd_min = 10;
  dd_max = 40;
  
  dx = (xlim(2)-xlim(1))/(dd-1);
  dx2 = (xlim(2)-xlim(1))/round((dd/3)-1);
  
  % STANDARD DEMO FIGURE
  fig = nndemof(me,'DESIGN','Bayesian Regularization','','Chapter 13');
  %str = [me '(''down'',get(0,''pointerloc''))'];
  %set(fig,'windowbuttondownfcn',str);
  
  % UNLOCK AND GET HANDLES
  
  set(fig,'nextplot','add','pointer','watch')
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);
  
  % ICON
  nndicon(13,458,363,'shadow')
    
  % SLIDER NOISE STD INDEX
  x = 175;
  y = 25;
  text(x,y+20,'Noise STD:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  di_slider = uicontrol(...
    'units','points',...
    'position',[x y-7 110 16],...
    'style','slider',...
    'min',di_min,...
    'max',di_max,...
    'callback',[me '(''di'')'],...
    'value',di);
  text(x-5,y-15,sprintf('%4.1f',di_min),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+110,y-15,sprintf('%4.0f',di_max),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right')
  di_text = text(x+100,y+20,['' num2str(di) ''],...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','center');

  % SLIDER NUMBER OF HIDDEN NEURONS
  y = 85;
  text(x,y+20,'# Hidden Neurons:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  S1_slider = uicontrol(...
    'units','points',...
    'position',[x y-7 110 16],...
    'style','slider',...
    'min',S1_min,...
    'max',S1_max,...
    'callback',[me '(''S1'')'],...
    'value',S1);
  text(x-5,y-15,sprintf('%4.0f',S1_min),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+110,y-15,sprintf('%4.0f',S1_max),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right')
  S1_text = text(x+100,y+20,['' num2str(S1) ''],...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','center');

  % SLIDER FREQUENCY
  x = 300;
  y = 25;
  text(x,y+20,'frequency:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  f_slider = uicontrol(...
    'units','points',...
    'position',[x y-7 110 16],...
    'style','slider',...
    'min',f_min,...
    'max',f_max,...
    'callback',[me '(''f'')'],...
    'value',f);
  text(x-5,y-15,sprintf('%4.1f',f_min),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+110,y-15,sprintf('%4.0f',f_max),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right')
  f_text = text(x+100,y+20,['' num2str(f) ''],...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','center');

  % SLIDER NUMBER OF HIDDEN NEURONS
  y = 85;
  text(x,y+20,'# Data Points:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  dd_slider = uicontrol(...
    'units','points',...
    'position',[x y-7 110 16],...
    'style','slider',...
    'min',dd_min,...
    'max',dd_max,...
    'callback',[me '(''dd'')'],...
    'value',dd);
  text(x-5,y-15,sprintf('%4.0f',dd_min),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+110,y-15,sprintf('%4.0f',dd_max),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right')
  dd_text = text(x+100,y+20,['' num2str(dd) ''],...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','center');

  % LEFT AXES
  left = nnsfo('a2','Function','p','a^2');
  set(left, ...
    'xlim',xlim,'xtick',xtick, ...
    'ylim',ylim,'ytick',ytick);

  T = 2;
  seed = 4687;
  % Set random number seed, if needed
  temp = cputime;
  temp = temp-fix(temp);
  temp = temp*100000;
  randn('seed',temp);
  if(seed == 0)
     z=rand;
     nseed = randn('seed');
  else
     nseed = seed;
  end

  nseed = 4687;
  randn('seed',nseed)
  %nseed2 = rand('seed');
  rand('seed',nseed+13484)

  pp = [xlim(1):(dx/10):xlim(2)];
  tt = sin(2*pi*pp*f/T);
  p = [xlim(1):dx:xlim(2)];
  t = sin(2*pi*p*f/T) + randn(size(p))*0.2*di;
  % The UNION command is to secure last point
  pv = union([(xlim(1)+0.05):dx2:(xlim(2)-0.05)],(xlim(2)-0.05));
  %pv = [-.95 -.65 -.25 .25 .65 .95];
  tv = sin(2*pi*pv*f/T); % + randn(size(VV.P))*0.2;

  func_test = plot(pp,tt,'k');
  hold on
  func_plot = plot(pp,tt,'b');
  func_target = plot(p,t,'ok');
  b1_plot = plot(p,t,'ok');
  set(b1_plot,'visible','off');
  b2_plot = plot(p,t,'+k');
  set(b2_plot,'visible','off');
  hold off
  set(func_plot,'LineWidth',2);
  %F = (Y-X).^4 + 8*X.*Y - X + Y + 3;
  %F = min(max(F,zlim(1)),zlim(2));
  %[dummy,func_plot] = contour(xpts,ypts,F,[1.01 2 3 4 6 8 10]);
  
  %cont_color = [nnblack; nnred; nngreen];
  %for i=1:length(func_plot)
  %  set(func_plot(i),'edgecolor',cont_color(rem(i,3)+1,:),'linewidth',1);
  %end
  %text(0,1.3,'< CLICK ON ME >',...
  %  'horiz','center', ...
  %  'fontweight','bold',...
  %  'color',nndkblue);
  
  % RIGHT AXES
  right = nnsfo('a3','Performance Indexes','Iteration','F');
  axis([1 100 1e-1 1e3])
  mer_plot = plot([1 101],[1 1],'b');
  hold on
  gamk_plot = plot([1 101],[1 1],'r');
  perf_plot = plot([1 101],[1 1],'k');
  hold off
  set(right,'xscale','log','yscale','log')
  %set(right, ...
  %  'xlim',xlim,'xtick',xtick, ...
  %  'ylim',ylim,'ytick',ytick);

  % TEXT
  %nnsettxt(desc_text, ...
  %  'EARLY STOPPING',...
  %  'Select the Noise STD of the training points below. Then by selecting the',...
  %  'train button, the training over the training points will be executed. The training',...
  %  'and validation performance indexes will be presented at the right. You will notice',...
  %  'that without early stopping the validation error will increase.')
  nnsettxt(desc_text,...
    'Click the [Train] button to',...
    'train the network on the',...
    'noisy data points at left.',...
    '',...
    'Use the slide bars to choose',...
    'the Network Size, the Number',...
    'of Data Points, the Noise',...
    'Standard Deviation and the',...
    'frequency of the function.')
  text(150,250,'Training Error',...
    'color',get(mer_plot,'color'),...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  text(150,100,'Testing Error',...
    'color',get(perf_plot,'color'),...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')
  text(150,40,'Gamma',...
    'color',get(gamk_plot,'color'),...
    'fontw','bold',...
    'fontsize',10,...
    'horizontalalignment','left')

  % CREATE BUTTONS
  train_button = nnsfo('b3','Train');
  set(train_button, ...
    'callback',[me '(''train'')'])
  set(nnsfo('b4','Contents'), ...
    'callback','nndtoc')
  nnsfo('b5','Close');
  
  % DATA POINTER: MARKER
  marker_ptr = nnsfo('data');
  set(marker_ptr,'userdata',[]);
  
  % DATA POINTER: CURRENT POINT
  point_p_ptr = nnsfo('data');
  set(point_p_ptr,'userdata',[p]);
  point_t_ptr = nnsfo('data');
  set(point_t_ptr,'userdata',[t]);
  point_pp_ptr = nnsfo('data');
  set(point_pp_ptr,'userdata',[pp]);
  point_tt_ptr = nnsfo('data');
  set(point_tt_ptr,'userdata',[tt]);
  point_pv_ptr = nnsfo('data');
  set(point_pv_ptr,'userdata',[pv]);
  point_tv_ptr = nnsfo('data');
  set(point_tv_ptr,'userdata',[tv]);
  
  % DATA POINTER: PATH
  path_ptr = nnsfo('data');
  set(path_ptr,'userdata',[]);

  % SAVE HANDLES, LOCK FIGURE
  H = [fig_axis desc_text left right marker_ptr path_ptr ...
    di_slider di_text func_plot func_test b1_plot b2_plot mer_plot perf_plot ...
    func_target train_button S1_slider S1_text f_slider f_text dd_slider dd_text ...
    point_p_ptr point_t_ptr point_pp_ptr point_tt_ptr point_pv_ptr point_tv_ptr gamk_plot ];
  set(fig,'userdata',H)
  
  % LOCK FIGURE AND RETURN
  set(fig,'nextplot','new','pointer','arrow','color',nnltgray)

  nnchkfs;

  return
end

% SERVICE COMMANDS =======================================================

% UNLOCK FIGURE AND GET HANDLES
set(fig,'nextplot','add','pointer','watch')
H = get(fig,'userdata');
desc_text = H(2);
left = H(3);
right = H(4);
marker_ptr = H(5);
path_ptr = H(6);
di_slider = H(7);
di_text = H(8);
func_plot = H(9);
func_test = H(10);
b1_plot = H(11);
b2_plot = H(12);
mer_plot = H(13);
perf_plot = H(14);
func_target = H(15);
train_button = H(16); 
S1_slider = H(17);
S1_text = H(18);
f_slider = H(19);
f_text = H(20);
dd_slider = H(21);
dd_text = H(22);
point_p_ptr = H(23);
point_t_ptr = H(24);
point_pp_ptr = H(25);
point_tt_ptr = H(26);
point_pv_ptr = H(27);
point_tv_ptr = H(28);
gamk_plot = H(29);

% COMMAND: DOWN

cmd = lower(cmd);
  
% COMMAND: DI

if strcmp(cmd,'di')
  
  T = 2;
  di = get(di_slider,'value');
  set(di_text,'string',['' sprintf('%4.2f',round(di*100)*0.01) '' ])
  f = get(f_slider,'value');

  p = get(point_p_ptr,'userdata');
  t = sin(2*pi*p*f/T) + randn(size(p))*0.2*di;
  set(point_t_ptr,'userdata',[t]);

  cmd = 'draw';

elseif strcmp(cmd,'s1')
  
  S1 = round(get(S1_slider,'value'));
  set(S1_text,'string',['' sprintf('%g',S1) '' ])
  cmd = 'draw';

elseif strcmp(cmd,'dd')
  
  T = 2;
  dd = round(get(dd_slider,'value'));
  set(dd_text,'string',['' sprintf('%g',dd) '' ])
  f = get(f_slider,'value');
  di = get(di_slider,'value');
  dx = (xlim(2)-xlim(1))/(dd-1);
  dx2 = (xlim(2)-xlim(1))/round((dd/3)-1);
  pp = [xlim(1):(dx/10):xlim(2)];
  tt = sin(2*pi*pp*f/T);
  p = [xlim(1):dx:xlim(2)];
  t = sin(2*pi*p*f/T) + randn(size(p))*0.2*di;
  % The UNION command is to secure last point
  pv = union([(xlim(1)+0.05):dx2:(xlim(2)-0.05)],(xlim(2)-0.05));
  tv = sin(2*pi*pv*f/T); % + randn(size(VV.P))*0.2;

  set(point_p_ptr,'userdata',[p]);
  set(point_t_ptr,'userdata',[t]);
  set(point_pp_ptr,'userdata',[pp]);
  set(point_tt_ptr,'userdata',[tt]);
  set(point_pv_ptr,'userdata',[pv]);
  set(point_tv_ptr,'userdata',[tv]);

  cmd = 'draw';

elseif strcmp(cmd,'f')
  
  T = 2;
  f = get(f_slider,'value');
  set(f_text,'string',['' sprintf('%4.2f',round(f*100)*0.01) '' ])
  dd = round(get(dd_slider,'value'));
  di = get(di_slider,'value');
  dx = (xlim(2)-xlim(1))/(dd-1);
  dx2 = (xlim(2)-xlim(1))/round((dd/3)-1);
  pp = [xlim(1):(dx/10):xlim(2)];
  tt = sin(2*pi*pp*f/T);
  p = [xlim(1):dx:xlim(2)];
  t = sin(2*pi*p*f/T) + randn(size(p))*0.2*di;
  % The UNION command is to secure last point
  pv = union([(xlim(1)+0.05):dx2:(xlim(2)-0.05)],(xlim(2)-0.05));
  tv = sin(2*pi*pv*f/T); % + randn(size(VV.P))*0.2;

  set(point_p_ptr,'userdata',[p]);
  set(point_t_ptr,'userdata',[t]);
  set(point_pp_ptr,'userdata',[pp]);
  set(point_tt_ptr,'userdata',[tt]);
  set(point_pv_ptr,'userdata',[pv]);
  set(point_tv_ptr,'userdata',[tv]);

  cmd = 'draw';
end

% COMMAND: DRAW

if strcmp(cmd,'draw')

  T = 2;
  % GET DATA
  di = get(di_slider,'value');
  dd = round(get(dd_slider,'value'));
  f = get(f_slider,'value');
  dx = (xlim(2)-xlim(1))/(dd-1);
  
  p = get(point_p_ptr,'userdata');
  t = get(point_t_ptr,'userdata');
  pp = get(point_pp_ptr,'userdata');
  tt = get(point_tt_ptr,'userdata');
  pv = get(point_pv_ptr,'userdata');
  tv = get(point_tv_ptr,'userdata');
  %if length(point) == 0
  %   set(fig,'nextplot','new','pointer','arrow')
  %   return
  %end
  
  %pp = [xlim(1):(dx/10):xlim(2)];
  %tt = sin(2*pi*pp*f/T);
  %p = [xlim(1):dx:xlim(2)];
  %t = sin(2*pi*p*f/T) + randn(size(p))*0.2*(di);
  % The UNION command is to secure last point
  %pv = union([(xlim(1)+0.05):dx2:(xlim(2)-0.05)],(xlim(2)-0.05));
  %pv = [-.95 -.65 -.25 .25 .65 .95];
  %tv = sin(2*pi*pv*f/T); % + randn(size(VV.P))*0.2;

  %temp = get(point_ptr,'userdata');
  %p=temp(1:21);
  %t=temp((21+1):21*2);
  %pp=temp((21*2+1):(21*2+201));
  %tt=temp((21*2+201+1):(21*2+201*2)); 
  %pv=temp((21*2+201*2+1):(21*2+201*2+6));
  %tv=temp((21*2+201*2+7):(21*2+201*2+12));
  %t = sin(2*pi*p*f/T) + randn(size(p))*0.2*(di);
  %tt = sin(2*pi*pp*f/T);
  %tv = sin(2*pi*pv*f/T); % + randn(size(VV.P))*0.2;

  %set(point_ptr,'userdata',[p t pp tt pv tv]);

  set(func_target,'ydata',t);
  set(func_test,'ydata',tt);
  set(func_plot,'ydata',tt);
  set(func_target,'xdata',p);
  set(func_test,'xdata',pp);
  set(func_plot,'xdata',pp);
  set(mer_plot,'xdata',[1 101],'ydata',[1 1]);
  set(perf_plot,'xdata',[1 101],'ydata',[1 1]);
  set(gamk_plot,'xdata',[1 101],'ydata',[1 1]);
  set(b1_plot,'xdata',p,'visible','off');
  set(b2_plot,'xdata',p,'visible','off');
  set(b1_plot,'ydata',t,'visible','off');
  set(b2_plot,'ydata',t,'visible','off');
  
  drawnow

end

% COMMAND: TRAIN

if strcmp(cmd,'train')
  set(train_button,'enable','off');
  set(di_slider,'enable','off');
  set(S1_slider,'enable','off');
  set(f_slider,'enable','off');
  set(dd_slider,'enable','off');
  S1 = round(get(S1_slider,'value'));
  dd = round(get(dd_slider,'value'));
  f = get(f_slider,'value');
  T = 2;
  dx = (xlim(2)-xlim(1))/(dd-1);
  
  %temp = get(point_ptr,'userdata');
  %p=temp(1:(dd-1));
  %t=temp(((dd-1)+1):(dd-1)*2);
  %pp=temp(((dd-1)*2+1):(((dd-1)*2+1)+((dd-1)*10)));
  %tt=temp((((dd-1)*2+1)+((dd-1)*10)+1):(((dd-1)*2+1)+((dd-1)*10)*2));
  %pv=temp(((dd-1)*2+201*2+1):((dd-1)*2+201*2+6));
  %tv=temp(((dd-1)*2+201*2+7):((dd-1)*2+201*2+12));
  
  p = get(point_p_ptr,'userdata');
  t = get(point_t_ptr,'userdata');
  pp = get(point_pp_ptr,'userdata');
  tt = get(point_tt_ptr,'userdata');
  pv = get(point_pv_ptr,'userdata');
  tv = get(point_tv_ptr,'userdata');

  TT.P = pp; %[-1:(dx/10):1];
  TT.T = tt; %sin(2*pi*TT.P*f/T); % + randn(size(VV.P))*0.2;
  trainParam = nnd13train_br('pdefaults');
  trainParam.mingrad = 1e-8;
  trainParam.ro = 0;
  trainParam.show = 25;
  trainParam.max_epoch = 101;
  trainParam.S1 = S1;
  trainParam.mu_initial = 10;
  trainParam.v = 2;
  trainParam.seed = 70312;

  [net,tr] = nnd13train_br(trainParam,p,t,[],TT,func_test,perf_plot,mer_plot, ...
                           0.1,b1_plot,b2_plot,gamk_plot); 
  set(train_button,'enable','on');
  set(di_slider,'enable','on');
  set(S1_slider,'enable','on');
  set(f_slider,'enable','on');
  set(dd_slider,'enable','on');
end

% LOCK FIGURE
set(fig,'nextplot','new','pointer','arrow')
