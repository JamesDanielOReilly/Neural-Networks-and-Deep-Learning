function nnd13esr(cmd,data)
%NND13ESR Steepest descent demonstration.

% $Revision: 1.6 $
% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% First Version, 8-31-95.

%==================================================================

% BRING UP FIGURE IF IT EXISTS

me = 'nnd13esr';
fig = nndfgflg(me);
if length(get(fig,'children')) == 0, fig = 0; end
if nargin == 0, cmd = ''; end

% CONSTANTS
max_update = 20;
xlim = [-0.5 1.5]; dx = 0.2;
ylim = [-1 1]; dy = 0.2;

t=(.01:.01:1)'*2*pi;
circ_x2=sin(t)*.02;
circ_y2=cos(t)*.02;
mx=3;
%  define problem

p1 = [1;1];  p2 = [-1;1];
t1 = 1; t2 = -1;
prob1 = 0.75;  prob2 = 0.25;
R = prob1*p1*p1' + prob2*p2*p2';
h = prob1*t1*p1 + prob2*t2*p2;
c = prob1*t1^2 + prob2*t2^2;
a = 2*R;
b = -2*h;

a1=[2 0;0 2];  b1 = zeros(2,1); c1 = 0;

%  plot the quadratic function

npts = 50;
x1 = xlim(1):(xlim(2)-xlim(1))/npts:xlim(2);
x2 = ylim(1):(ylim(2)-ylim(1))/npts:ylim(2);
[X,Y] = meshgrid(x1,x2);

%zlim = [0 12];
xpts = xlim(1):dx:xlim(2);
ypts = ylim(1):dy:ylim(2);
%[X,Y] = meshgrid(xpts,ypts);

xtick = [-2 0 2];
ytick = [-2 0 2];
ztick = [0 6 12];
circle_size = 8;

max_epoch = 100;

% CREATE FIGURE ========================================================

if fig == 0

  % CONSTANTS
  epoch = 1;
  epoch_min = 1;
  epoch_max = max_epoch;

  % CONSTANTS
  ro = 0;
  ro_min = 0;
  ro_max = 100;

  % STANDARD DEMO FIGURE
  fig = nndemof(me,'DESIGN','Early Stopping/Regularization','','Chapter 13');
  %str = [me '(''down'',get(0,''pointerloc''))'];
  %set(fig,'windowbuttondownfcn',str);
  
  % UNLOCK AND GET HANDLES
  
  set(fig,'nextplot','add','pointer','watch')
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);
  
  % ICON
  nndicon(13,458,363,'shadow')
    
  % SLIDER EPOCh
  x = 45;
  y = 40;
  text(x,y+15,'Epoch:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  epoch_slider = uicontrol(...
    'units','points',...
    'position',[x y-15 160 16],...
    'style','slider',...
    'min',epoch_min,...
    'max',epoch_max,...
    'callback',[me '(''epoch'')'],...
    'value',epoch);
  %temp=get(epoch_slider,'sliderstep');
  %set(epoch_slider,'sliderstep',[temp(1)/2 temp(2)]);
  text(x,y-28,sprintf('%4.0f',epoch_min),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+160,y-28,sprintf('%4.0f',epoch_max),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right')
  epoch_text = text(x+80,y-28,['(' num2str(epoch) ')'],...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','center');

  % SLIDER RO
  x = 245;
  text(x,y+15,'ro:',...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  ro_slider = uicontrol(...
    'units','points',...
    'position',[x y-15 160 16],...
    'style','slider',...
    'min',ro_min,...
    'max',ro_max,...
    'callback',[me '(''ro'')'],...
    'value',0);
  %temp=get(ro_slider,'sliderstep');
  %set(ro_slider,'sliderstep',[temp(1)/2 temp(2)]);
  text(x,y-28,sprintf('%4.0f',ro_min),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','left')
  text(x+160,y-28,'Inf',...   %sprintf('%4.0f',ro_max),...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','right')
  ro_text = text(x+80,y-28,['(' num2str(ro) ')'],...
    'color',nndkblue,...
    'fontw','bold',...
    'fontsize',12,...
    'horizontalalignment','center');

  % LEFT AXES
  left = nnsfo('a2','Early Stopping','x(1)','x(2)');
  set(left, ...
    'xlim',xlim,'xtick',xtick, ...
    'ylim',ylim,'ytick',ytick);
  F = (a(1,1)*X.^2 + (a(1,2)+a(2,1))*X.*Y + a(2,2)*Y.^2)/2 ...
         + b(1)*X + b(2)*Y +c;
  %F = (Y-X).^4 + 8*X.*Y - X + Y + 3;
%  F = min(max(F,zlim(1)),zlim(2));

  sol=-pinv(a)*b;

  %  if the function is above a maximum value set it to the maximum

  for i=1:(npts+1),
    for j=1:(npts+1),
      if(F(i,j)>mx),
        F(i,j)=mx;
      end
    end
  end

  %  Performance with just regularization

  F1 = (a1(1,1)*X.^2 + (a1(1,2)+a1(2,1))*X.*Y + a1(2,2)*Y.^2)/2 ...
         + b1(1)*X + b1(2)*Y +c1;

  sol1=-pinv(a1)*b1;

  %  if the function is above a maximum value set it to the maximum

  for i=1:(npts+1),
    for j=1:(npts+1),
      if(F1(i,j)>mx),
        F1(i,j)=mx;
      end
    end
  end

  %  create the contour plot

  ncnt = [0.02 0.07 0.15];
  [dummy,func_cont] = contour(x1,x2,F,ncnt);

  %[dummy,func_cont] = contour(xpts,ypts,F,[1.01 2 3 4 6 8 10]);
  cont_color = [nnblack; nnred; nngreen];
  for i=1:length(func_cont)
    set(func_cont(i),'edgecolor',cont_color(rem(i,3)+1,:),'linewidth',1);
  end
  %text(0,1.7,'< CLICK ON ME >',...
  %  'horiz','center', ...
  %  'fontweight','bold',...
  %  'color',nndkblue);
  
  hold on
  
  %  create second plot
  ncnt = [0.025 0.08 0.15];
  [dummy,func_cont1] = contour(x1,x2,F1,ncnt);
  for i=1:length(func_cont)
    set(func_cont1(i),'edgecolor',cont_color(rem(i,3)+1,:),'linewidth',1);
  end

  %  draw center points

  x10=sol(1);
  x20=sol(2);
  xc=circ_x2+x10;
  yc=circ_y2+x20;
  fill(xc,yc,'b','EdgeColor','b')

  x10=sol1(1);
  x20=sol1(2);
  xc=circ_x2+x10;
  yc=circ_y2+x20;
  fill(xc,yc,'b','EdgeColor','b')


  
  % RIGHT AXES
  right = nnsfo('a3','regularization','x(1)','x(2)');
  set(right, ...
    'xlim',xlim,'xtick',xtick, ...
    'ylim',ylim,'ytick',ytick);

  [dummy,func_cont] = contour(x1,x2,F,ncnt);
  for i=1:length(func_cont)
    set(func_cont(i),'edgecolor',cont_color(rem(i,3)+1,:),'linewidth',1);
  end

  hold on
  
  %  create second plot
  ncnt = [0.025 0.08 0.15];
  [dummy,func_cont1] = contour(x1,x2,F1,ncnt);
  for i=1:length(func_cont)
    set(func_cont1(i),'edgecolor',cont_color(rem(i,3)+1,:),'linewidth',1);
  end

  %  draw center points

  x10=sol(1);
  x20=sol(2);
  xc=circ_x2+x10;
  yc=circ_y2+x20;
  fill(xc,yc,'b','EdgeColor','b')

  x10=sol1(1);
  x20=sol1(2);
  xc=circ_x2+x10;
  yc=circ_y2+x20;
  fill(xc,yc,'b','EdgeColor','b')

  x1 = sol(1);
  x2 = sol(2);

  table_ro1=[];
  table_ro2=[];
  table_alpha=[];
  numpar=[];
  [ev,eval]=eig(a);
  for alpha=0:1/ro_max:1    %0:.1:1,
    beta = 1-alpha;

    Lx1 = x1; Lx2 = x2;

    % LEARNING PHASE
    grad=a*[x1;x2]+b;
    hessian=a;
    x=-inv(beta*a + alpha*a1)*(beta*b);

    if beta==0
      ro=inf;
    else
      ro=alpha/beta;
    end
    if ro==0
        ro_circle=plot([Lx1 x1],[Lx2 x2],'ko','linewidth',1);   
    end

    x1 = x(1);
    x2 = x(2);
    plot([Lx1 x1],[Lx2 x2],'b-','linewidth',1);

    table_ro1=[table_ro1; x1];
    table_ro2=[table_ro2; x2];
    table_alpha=[table_alpha alpha];
    
    lambda1=2*ro*(1/eval(1,1)-1);
    lambda2=2*ro*(1/eval(2,2)-1);
    
    if alpha~=0
        numpar=[numpar beta*lambda1/(beta*lambda1+2*alpha)+beta*lambda2/(beta*lambda2+2*alpha)];
    end

    %pause(0.2);
  end

  ro1_ptr = nnsfo('data');
  set(ro1_ptr,'userdata',table_ro1);
  
  ro2_ptr = nnsfo('data');
  set(ro2_ptr,'userdata',table_ro2);

  alpha_ptr = nnsfo('data');
  set(alpha_ptr,'userdata',table_alpha);
  
  %  draw path for steepest descent
  axes(left);
  x1 = 0;
  x2 = 0;
  lr = 0.05;

  table_epoch1=[];
  table_epoch2=[];
  numpar2=[];
  for epochs=1:max_epoch,

    Lx1 = x1; Lx2 = x2;

    % LEARNING PHASE
    grad=a*[x1;x2]+b;
    gx1=grad(1);
    gx2=grad(2);
    dx1=-lr*gx1;
    dx2=-lr*gx2;

    if epochs==1
       epoch_circle=plot([Lx1 x1],[Lx2 x2],'ko','linewidth',1);
    end
    table_epoch1=[table_epoch1; x1];
    table_epoch2=[table_epoch2; x2];
    x1 = x1 + dx1;
    x2 = x2 + dx2;
    plot([Lx1 x1],[Lx2 x2],'b-','linewidth',1);
    
    lambda1=(1-eval(1,1)^(1/epochs))/lr;
    lambda2=(1-eval(2,2)^(1/epochs))/lr;

    beta = 1-lr;
    numpar2=[numpar2 beta*lambda1/(beta*lambda1+2*alpha)+beta*lambda2/(beta*lambda2+2*alpha)];
    %pause(0.1)

  end

  epoch1_ptr = nnsfo('data');
  set(epoch1_ptr,'userdata',table_epoch1);
  
  epoch2_ptr = nnsfo('data');
  set(epoch2_ptr,'userdata',table_epoch2);

  % TEXT
  nnsettxt(desc_text, ...
    'EARLY STOPPING/REGULARIZATION',...
    'Click on the epoch slider to see the steepest descent trajectory.',...
    'Click on the ro slider to see the minimum of the regularized performance index.')

  % CREATE BUTTONS
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

  % SAVE HANDLES, LOCK FIGURE
  H = [fig_axis desc_text left right marker_ptr point_ptr path_ptr ...
    epoch_slider epoch_text ro_circle epoch_circle epoch1_ptr epoch2_ptr ro1_ptr ro2_ptr ro_slider ro_text alpha_ptr];
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
epoch_slider = H(8);
epoch_text = H(9);
ro_circle = H(10);
epoch_circle=H(11);
epoch1_ptr=H(12);
epoch2_ptr=H(13);
ro1_ptr=H(14);
ro2_ptr=H(15);
ro_slider=H(16);
ro_text=H(17);
alpha_ptr=H(18);

% COMMAND: EPOCH

if strcmp(cmd,'epoch')
  
  epoch = ceil(get(epoch_slider,'value'));
  set(epoch_text,'string',['(' sprintf('%4.0f',round(epoch*100)*0.01) ')' ])
  xx1=get(epoch1_ptr,'userdata');
  xx2=get(epoch2_ptr,'userdata');
  set(epoch_circle,'xdata',[xx1(epoch) xx1(epoch)],'ydata',[xx2(epoch) xx2(epoch)])
  cmd = 'draw';
  
% COMMAND: RO

elseif strcmp(cmd,'ro')
  
  ro = ceil(get(ro_slider,'value'));
  temp=get(alpha_ptr,'userdata');
  if temp(ro+1)==1
      temp=Inf;
  else
      temp=temp(ro+1)/(1-temp(ro+1));
  end
  set(ro_text,'string',['(' sprintf('%4.3f',temp) ')' ])
  xx1=get(ro1_ptr,'userdata');
  xx2=get(ro2_ptr,'userdata');
  set(ro_circle,'xdata',[xx1(ro+1) xx1(ro+1)],'ydata',[xx2(ro+1) xx2(ro+1)])
  cmd = 'draw';
end

% COMMAND: DRAW

if strcmp(cmd,'draw')

  % GET DATA
  lr = get(epoch_slider,'value');
  point = get(point_ptr,'userdata');
  if length(point) == 0
     set(fig,'nextplot','new','pointer','arrow')
     return
  end
  x = point(1);
  y = point(2);
  Fo = point(3);
  
  % FIND GRADIENT AT POINT
  gx = -4*(y-x)^3 + 8*y - 1;
  gy = 4*(y-x)^3 + 8*x + 1;
  grad = [gx; gy];

  % CREATE APPROXIMATION
  dX = X - x;
  dY = Y - y;
  Fa = grad(1)*dX + grad(2)*dY + Fo;

  % PLOT CONTOUR
  axes(right);
  delete(get(right,'children'))
  [dummy,func_cont] = contour(xpts,ypts,Fa,10);
  cont_color = [nnblack; nnred; nngreen];
  for i=1:length(func_cont)
    set(func_cont(i),'edgecolor',cont_color(rem(i,3)+1,:),'linewidth',1);
  end
  plot(x,y,'ok','markersize',circle_size);
  plot(x,y,'ow','markersize',circle_size+2);
  plot(x,y,'ok','markersize',circle_size+4);

  % OPTIMIZE
  xx = [x zeros(1,max_update)];
  yy = [y zeros(1,max_update)];
  for i=1:max_update
    gx = -4*(y-x)^3 + 8*y - 1;
    gy = 4*(y-x)^3 + 8*x + 1;
    nx = x-lr*gx;
    ny = y-lr*gy;
    xx(i+1) = nx;
    yy(i+1) = ny;
    x = nx;
    y = ny;
  end

  % REMOVE OLD PATH
  path = get(path_ptr,'userdata');
  delete(path);

  % PLOT PATH
  axes(right)
  plot(xx(1:2),yy(1:2),...
    'color',nnred);
  plot(xx(2),yy(2),'o',...
    'color',nndkblue');
  axes(left)
  path1 = plot(xx,yy,...
    'color',nnred);
  xx(1) = [];
  yy(1) = [];
  path2 = plot(xx,yy,'o',...
    'color',nndkblue');
  set(path_ptr,'userdata',[path1 path2])
  drawnow
end

% LOCK FIGURE
set(fig,'nextplot','new','pointer','arrow')
