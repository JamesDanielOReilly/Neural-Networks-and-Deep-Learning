function nnd13es(cmd,data)
%NND13ES Steepest descent demonstration.

% $Revision: 1.6 $
% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% First Version, 8-31-95.

%==================================================================

% BRING UP FIGURE IF IT EXISTS

me = 'nnd13es';
fig = nndfgflg(me);
if length(get(fig,'children')) == 0, fig = 0; end
if nargin == 0, cmd = ''; end

% CONSTANTS
max_update = 20;
xlim = [-1 1]; dx = 0.1;
ylim = [-1.5 1.5]; dy = 0.2;
zlim = [0 12];
xpts = xlim(1):dx:xlim(2);
ypts = ylim(1):dy:ylim(2);
[X,Y] = meshgrid(xpts,ypts);
xtick = [-1 -0.5 0 0.5 1];
ytick = [-1.5 -1 -0.5 0 0.5 1 1.5];
ztick = [0 6 12];
circle_size = 8;

% CREATE FIGURE ========================================================

if fig == 0

  % CONSTANTS
  di = 1;
  di_min = 0.1;
  di_max = 3;

  % STANDARD DEMO FIGURE
  fig = nndemof(me,'DESIGN','Early Stopping','','Chapter 13');
  %str = [me '(''down'',get(0,''pointerloc''))'];
  %set(fig,'windowbuttondownfcn',str);
  
  % UNLOCK AND GET HANDLES
  
  set(fig,'nextplot','add','pointer','watch')
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);
  
  % ICON
  nndicon(13,458,363,'shadow')
    
  % SLIDER
  y = 40;
  text(30,y,'Noise Standard Deviation:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  di_slider = uicontrol(...
    'units','points',...
    'position',[190 y-7 160 16],...
    'style','slider',...
    'min',di_min,...
    'max',di_max,...
    'callback',[me '(''di'')'],...
    'value',di);
  text(190,y-20,sprintf('%4.1f',di_min),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(350,y-20,sprintf('%4.0f',di_max),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right')
  di_text = text(270,y-20,['(' num2str(di) ')'],...
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

  %nseed = 4687;
  randn('seed',nseed)
  %nseed2 = rand('seed');
  rand('seed',nseed+13484)

  pp0 = [xlim(1):.01:xlim(2)];
  tt0 = sin(2*pi*pp0/T); % + randn(size(pp0))*0.2;
  pp = [xlim(1)+(dx/2):dx:xlim(2)-(dx/2)];
  tt = sin(2*pi*pp/T) + randn(size(pp))*0.2;
  p = [xlim(1):dx:xlim(2)];
  t = sin(2*pi*p/T) + randn(size(p))*0.2;
  
  func_test = plot(pp0,tt0,'k');
  hold on
  func_plot = plot(pp0,tt0,'b');
  %func_val = plot(pp,tt,'^k');
  func_val = plot(pp,tt,'k');
  set(func_val,'visible','off');
  func_target = plot(p,t,'ob');
  val_points = plot(pp,tt,'^k');
  hold off
  set(func_plot,'LineWidth',2);

  text(3.7,1.15,'Circles','fontweight','bold')
  text(3.7,0.9,'Training Data')
  text(3.7,0.25,'Triangles','fontweight','bold')
  text(3.7,0,'Validation Data')

  % RIGHT AXES
  right = nnsfo('a3','Performance Indexes','Iteration','F');
  axis([1 100 1e-1 1e3])
  mer_plot = plot([1 101],[1 1],'b');
  hold on
  perf_plot = plot([1 101],[1 1],'k');
  hold off
  set(right,'xscale','log','yscale','log')
  % Small adjustment to x label due to movement due to log scale
  pos=get(get(right,'xlabel'),'position');
  set(get(right,'xlabel'),'position',[pos(1) pos(2)+0.005 pos(3)])
  %set(right, ...
  %  'xlim',xlim,'xtick',xtick, ...
  %  'ylim',ylim,'ytick',ytick);

  % TEXT
  nnsettxt(desc_text, ...
    'EARLY STOPPING',...
    'Select the Noise Standard Deviation of the training points below. Then by selecting the',...
    'train button, the training over the training points will be executed. The training',...
    'and validation performance indexes will be presented at the right. You will notice',...
    'that without early stopping the validation error will increase.')

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
  point_ptr = nnsfo('data');
  set(point_ptr,'userdata',[]);
  
  % DATA POINTER: PATH
  path_ptr = nnsfo('data');
  set(path_ptr,'userdata',[]);
  set(point_ptr,'userdata',[p t pp tt]);

  % SAVE HANDLES, LOCK FIGURE
  H = [fig_axis desc_text left right marker_ptr point_ptr path_ptr ...
    di_slider di_text func_plot func_test mer_plot perf_plot ...
    func_target train_button func_val val_points];
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
point_ptr = H(6);
path_ptr = H(7);
di_slider = H(8);
di_text = H(9);
func_plot = H(10);
func_test = H(11);
mer_plot = H(12);
perf_plot = H(13);
func_target = H(14);
train_button = H(15);
func_val=H(16);
val_points = H(17);

% COMMAND: DOWN

cmd = lower(cmd);
  
% COMMAND: DI

if strcmp(cmd,'di')
  
  di = get(di_slider,'value');
  set(di_text,'string',['(' sprintf('%4.2f',round(di*100)*0.01) ')' ])
  set(func_val,'visible','off');
  cmd = 'draw';
end

% COMMAND: DRAW

if strcmp(cmd,'draw')

  T = 2;
  % GET DATA
  di = get(di_slider,'value');
  point = get(point_ptr,'userdata');
  if length(point) == 0
     set(fig,'nextplot','new','pointer','arrow')
     return
  end
  temp = get(point_ptr,'userdata');
  p=temp(1:21);
  t=temp((21+1):21*2);
  pp0 = [xlim(1):.01:xlim(2)];
  tt0 = sin(2*pi*pp0/T);
  pp=temp((21*2+1):(21*2+20));
  %tt=temp((21*2+20+1):end);
  tt = sin(2*pi*pp/T) + randn(size(pp))*0.2*(di);
  t = sin(2*pi*p/T) + randn(size(p))*0.2*(di);
  set(point_ptr,'userdata',[p t pp tt]);

  set(func_target,'ydata',t);
  set(func_val,'ydata',tt);
  set(val_points,'ydata',tt);
  set(func_test,'ydata',tt0);
  set(mer_plot,'xdata',[1 101],'ydata',[1 1]);
  set(perf_plot,'xdata',[1 101],'ydata',[1 1]);
  
  drawnow

end

% COMMAND: TRAIN

if strcmp(cmd,'train')
  set(train_button,'enable','off');
  set(di_slider,'enable','off');
  T = 2;
  temp = get(point_ptr,'userdata');
  p=temp(1:21);
  t=temp((21+1):21*2);
  %pp=temp((21*2+1):(21*2+201));
  %tt=temp((21*2+201+1):end);
  VV.P=temp((21*2+1):(21*2+20));
  VV.T=temp((21*2+20+1):end);
  VV.stop=false;        % We don't stop for validation
  TT.P = [-1:0.01:1];
  TT.T = sin(2*pi*TT.P/T); % + randn(size(VV.P))*0.2;
  trainParam = nnd13train_marq('pdefaults');
  trainParam.mingrad = 1e-8;
  trainParam.ro = 0;
  trainParam.show = 25;
  trainParam.max_epoch = 101;
  trainParam.S1 = 20;
  trainParam.mu_initial = 10;
  trainParam.v = 2;
  trainParam.seed = 70312;

  % For plot without early
  [net,tr] = nnd13train_marq(trainParam,p,t,VV,TT,func_test,perf_plot,mer_plot,0.1,[],[],func_val); 
  set(train_button,'enable','on');
  set(di_slider,'enable','on');
end

% LOCK FIGURE
set(fig,'nextplot','new','pointer','arrow')
