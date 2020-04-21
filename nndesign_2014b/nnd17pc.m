function [ret1,ret2,ret3,ret4,ret5]=nnd17pc(cmd,arg1,arg2,arg3,arg4,arg5)
%NND17PC Network function demonstration.
%
%  This demonstration requires either the MININNET functions
%  on the NND disk or the Neural Network Toolbox.
%
%  NND17PC
%  Opens demonstration with default values.
%
%  NND17PC(cmd,arg1,arg2,arg3,arg4,arg5)
%    cmd - Command to be executed.
%  Sets network parameters accordingly.
%

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% $Revision: 1.7 $

%==================================================================

% CONSTANTS
me = 'nnd17pc';
max_t = 0.5;
w_max = 3;
p_max = 5;
div=15;

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
  meters = H(3:11);            % parameter axes
  indicators = H(12:20);      % paramter indicators
  func_axis = H(21);          % network function axis
  func_line = H(22);          % network function line
  func_axis2 = H(23);          % network function axis 2
  func_line2 = H(24);          % network function line
  values_ptr = H(25);         % Network parameter, input & output values
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
  %if ~nnfexist(me), return, end

  % CONSTANTS
  W1 = [1 -1;-1 1];
  b1 = [1;1];
  W2 = [2 2];
  b2 = [-1];
  p = 0;
  a = W2(1)*exp(-((p-W1(1)).*b1(1)).^2) + W2(2)*exp(-((p-W1(2)).*b1(2)).^2) + b2;
  values = [W1(1,1) b1(1) W2(1) W1(2,1) b1(2) W2(2) b2 W1(1,2) W1(2,2) p a];

  % NEW DEMO FIGURE
  fig = nndemof2(me,'DESIGN','RBF Pattern Classification','','Chapter 17');
  set(fig, ...
    'windowbuttondownfcn',nncallbk(me,'down'), ...
    'BackingStore','off',...
    'nextplot','add');
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);

  % ICON
  nndicon(17,458,363,'shadow')

  % NETWORK POSITIONS
  x1 = 40;     % input
  x2 = x1+90;  % 1st layer dotprod
  x3 = x2+40;  % 1st layer transfer function (radbas)
  x7 = x2-40;  % 1st layer dist
  x4 = x3+100; % 2nd layer dotprod
  x5 = x4+40;  % 2nd layer transfer function (radbas)
  x6 = x5+50;  % output
  y1 = 265;    % top neuron
  y2 = y1-20;  % input & output neuron
  y3 = y1-40;  % bottom neuron
  sz = 15;     % size of icons
  wx = 50;     % weight vertical offset (from 1st layer)
  wy = 35;     % weight horizontal offset (from middle)

  % NETWORK INPUT
  nndtext(x1-10,y1,'p1');
  nndtext(x1-10,y3,'p2');
  plot([x7-sz x1 NaN x7-sz x1],[y1 y1 NaN y3 y3],'linewidth',2,'color',nnred);

  % TOP NEURON
  plot([x7 x7 x3 nan x2 x2],[y1+sz*2 y1 y1 nan y1+sz*2 y1],'linewidth',2,'color',nnred);
  nndsicon('dist',x7,y1,sz)
  nndsicon('dotprod',x2,y1,sz)
  nndsicon('radbas',x3,y1,sz)
  nndtext(x7-25,y1+sz*2,'W1(1,:)');
  nndtext(x2+2,y1+sz*2+11,'1');
  nndtext(x2+10,y1+sz*2,'b1(1)','left');

  % BOTTOM NEURON
  plot([x7 x7 x3 nan x2 x2],[y3-sz*2 y3 y3 nan y3-sz*2 y3],'linewidth',2,'color',nnred);
  nndsicon('dist',x7,y3,sz)
  nndsicon('dotprod',x2,y3,sz)
  nndsicon('radbas',x3,y3,sz)
  nndtext(x7-25,y3-sz*2,'W1(2,:)');
  nndtext(x2+2,y3-sz*2-13,'1');
  nndtext(x2+10,y3-sz*2,'b1(2)','left');

  % OUTPUT NEURON
  plot([x3+sz x4-10 x3+sz],[y1 y2 y3],'linewidth',2,'color',nnred);
  plot([x4 x4 x6],[y2-sz*2 y2 y2],'linewidth',2,'color',nnred);
  plot([x6-10 x6 x6-10],[y2-7 y2 y2+7],'linewidth',2,'color',nnred);
  nndsicon('sum',x4,y2,sz)
  nndsicon('purelin',x5,y2,sz);
  nndtext(x3+wx,y2+wy,'W2(1,1)');
  nndtext(x3+wx,y2-wy,'W2(1,2)');
  nndtext(x4+2,y2-sz*2-13,'1');
  nndtext(x4+10,y2-sz*2,'b2','left');
  nndtext(x5+sz+5,y2+8,'a2','left');

  % PARAMETER POSITIONS
  xx = 20 + [0:3]*90;
  yy = [330 150];
  zz = [15 -15];

  % PARAMETER METERS & INDICATORS
  meters = [];
  indicators = [];
  for z=1:2
    for i=1:2
      for j=1:4
        pn = min([(j+(i-1)*3)*(2-z)+(z-1)*(5+i+j*2) 10]);
        val = values(pn);
        if any([3 6] == pn)
          maxval = 2;
        elseif any([1 4 8 9] == pn)
          maxval = 4;
        elseif any([2 5 7] == pn)
          maxval = 1;
        else
          maxval = 4;
        end
        maxstr = num2str(maxval);
        if (i ~= 1) | (j ~= 4)
            if (j>1 & z==1) | j==1
                ax = nnsfo('a2','','','');
                if j>1 
                    set(ax,...
                        'units','points',...
                        'position',[xx(j) yy(i) 70 15],...
                        'color',nnmdgray,...
                        'ylim',[-0.3 1.3],...
                        'ytick',[],...
                        'xlim',[-1.3 1.3]*maxval,...
                        'xtick',[-1 -0.5 0 0.5 1]*maxval,...
                        'xticklabel',str2mat(['-' maxstr],'','0','',maxstr));
                else
                    set(ax,...
                        'units','points',...
                        'position',[xx(j) yy(i)+zz(z) 70 15],...
                        'color',nnmdgray,...
                        'ylim',[-0.3 1.3],...
                        'ytick',[],...
                        'xlim',[-1.3 1.3]*maxval,...
                        'xtick',[-1 -0.5 0 0.5 1]*maxval,...
                        'xticklabel',str2mat(['-' maxstr],'','0','',maxstr));
                    if z== 2
                        set(ax,'XAxisLocation','top','Tickdir','out','xticklabel','');
                    end
                end
                if z== 2
                    ind = fill([0.2 -0.2 0]*maxval+val,[0 0 1],nnred,...
                        'edgecolor',nndkblue,...
                        'erasemode','none');
                else
                    ind = fill([0 0.2 -0.2]*maxval+val,[0 1 1],nnred,...
                        'edgecolor',nndkblue,...
                        'erasemode','none');
                end
                meters = [meters ax];
                indicators = [indicators ind];
            end
        end
      end
    end
  end

  % PARAMETER LINES
  xx = xx + 0.5;
  y = yy(1)+10+zz(1);
  x = xx(1)+70;
  plot([0 5 5]+x,[0 0 -45]+y,'color',nndkgray);
  y = yy(1)+10;
  x = xx(2)+70;
  plot([0 5 5 0]+x,[0 0 -45 -45]+y,'color',nndkgray);
  x = xx(3)+70;
  plot([0 5 5 -18]+x,[0 0 -60 -60]+y,'color',nndkgray);
  x = xx(4)+70;
  plot([0 5 5 -50 -50]+x,[0 0 -55 -55 -71]+y,'color',nndkgray);
  y = yy(2)+10+zz(1);
  x = xx(1)+70;
  plot([0 5 5]+x,[0 0 35]+y,'color',nndkgray);
  y = yy(2)+10;
  x = xx(2)+70;
  plot([0 5 5 0]+x,[0 0 35 35]+y,'color',nndkgray);
  x = xx(3)+70;
  plot([0 5 5 -50 -50]+x,[0 0 20 20 35]+y,'color',nndkgray);
  x = xx(4)+70;
  plot([0 5 5 -55]+x,[0 0 55 55]+y,'color',nndkgray);

  y = yy(1)+10+zz(2);
  x = xx(1)+70;
  plot([0 5 5]+x,[0 0 -45]+y,'color',nndkgray);
  y = yy(2)+10+zz(1);
  x = xx(1)+70;
  plot([0 5 5]+x,[0 0 35]+y,'color',nndkgray);
  
  xp=-p_max:p_max/div:p_max;
  yp=xp;
  num = length(xp);
  [X,Y] = meshgrid(xp,yp);
  xx=X(:); 
  yy=Y(:);
  Q=length(yy);
  A = W2(1)*exp(-((xx-W1(1,1)).*b1(1)).^2-((yy-W1(1,2)).*b1(1)).^2) ...
      + W2(2)*exp(-((xx-W1(2,1)).*b1(2)).^2-((yy-W1(2,2)).*b1(2)).^2) + b2*ones(Q,1);
  A = reshape(A,num,num);
  trigger=0;
  v = [trigger trigger];

  a_max = max(A);
  a_min = min(A);
  a_edge = (a_max-a_min)*0.1;

  % FUNCTION AXIS
  y = 15;
  x = 40;
  func_axis = nnsfo('a2','','','');
  set(func_axis, ...
    'units','points',...
    'position',[x y 100 100],...
    'color',nnltyell,...
    'xlim',[-1 1]*p_max+[-0.1 0.1],...
    'ylim',[-1 1]*p_max+[-0.1 0.1])
  [cc,func_line]=contourf(xp,yp,A,v);
  set(func_line,'color','blue')
  h1=plot([-1],[1],'ok','MarkerSize',10,'markerfacecolor','black','erasemode','none');
  h1=plot([1],[-1],'ok','MarkerSize',10,'markerfacecolor','black','erasemode','none');
  h1=plot([1],[1],'ok','MarkerSize',10,'markerfacecolor','white','erasemode','none');
  h1=plot([-1],[-1],'ok','MarkerSize',10,'markerfacecolor','white','erasemode','none');
  axis square
  xlabel('p1')
  ylabel('p2')
  set(get(func_axis,'xlabel'),'Position',[0.3 -3.7 17],'fontweight','bold')
  set(get(func_axis,'ylabel'),'Position',[-3.7 -0.07 17],'fontweight','bold')
  
  func_axis2 = nnsfo('a2','','','');
  set(func_axis2, ...
    'units','points',...
    'position',[x+155 y 150 110],...
    'color','blue',...
    'xlim',[-p_max p_max],...
    'ylim',[-p_max p_max],...
    'zlim',[-2 1],...
    'CameraPosition', [-36.5257 -47.6012 11.0753],...
    'CameraUpVector',[0 0 1])
  func_line2=surf(func_axis2,xp,yp,A);

  axis([-p_max p_max -p_max p_max -2 1]);
  colormap('gray')

  hold('on');

  a = get(func_axis2,'zlim');

  zpos = a(1); % Always put contour below plot.

  % Get D contour data
  [cc,hh] = contour3(func_axis2,xp,yp,A,v);

  %%% size zpos to match the data

  for i = 1:length(hh)
        zz = get(hh(i),'Zdata');
        set(hh(i),'Zdata',zpos*ones(size(zz)));
  end

  hand=mesh(xp,yp,trigger*ones(size(A)));
  set(hand,'facecolor','none')
  hold off
  xlabel('p1')
  ylabel('p2')
  zlabel('a2')
  set(get(func_axis2,'xlabel'),'position',[-32 -51 9],'fontweight','bold')
  set(get(func_axis2,'ylabel'),'position',[-44.5 -48 10.3],'fontweight','bold')
  set(get(func_axis2,'zlabel'),'fontweight','bold')
  
  % BUTTONS
  drawnow % Let everything else appear before buttons 
  uicontrol(...
    'units','points',...
    'position',[400 145 60 20],...
    'string','Reset',...
    'callback',[me '(''reset'')'])
  uicontrol(...
    'units','points',...
    'position',[400 115 60 20],...      % [400 145 60 20],...
    'string','Random',...
    'callback',[me '(''random'')'])
  uicontrol(...
    'units','points',...
    'position',[400 85 60 20],...      %[400 110 60 20],...
    'string','Contents',...
    'callback','nndtoc')
  uicontrol(...
    'units','points',...
    'position',[400 55 60 20],...       %[400 75 60 20],...
    'string','Close',...
    'callback',[me '(''close'')'])

  % DATA POINTERS
  value_ptr = uicontrol('visible','off','userdata',values);

  % SAVE WINDOW DATA AND LOCK
  H = [fig_axis desc_text meters indicators ...
    func_axis func_line func_axis2 func_line2 value_ptr];

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
    'Alter network weights',...
    'and biases by dragging',...
    'the triangular shaped',...
    'indicators.',...
    '',...
    'Click on [Reset] to',...
    'initialize parameters',...
    '',...
    'Click on [Random] to',...
    'set each parameter',...
    'to a random value.')
    
%==================================================================
% Respond to mouse down.
%
% ME('down')
%==================================================================

elseif strcmp(cmd,'down') & ~isempty(fig) & (nargin == 1)

  %handled = 0;
  for i=1:9

    if any([3 6] == i)
      maxval = 2;
    elseif any([1 4 8 9] == i)
      maxval = 4;
    elseif any([2 5 7] == i)
      maxval = 1;
    else
      maxval = 4;
    end

    pt = get(meters(i),'currentpoint');
    x = pt(1);
    y = pt(3);

    if (abs(x) <= maxval*1.3) & (y >= -0.3 & y <= 1.3)
      handled = 1;

      % SET UP MOTION TRACKING IN METER
      set(fig,'WindowButtonMotionFcn',[me '(''m_motion'',' num2str(i) ')']);
      set(fig,'WindowButtonUpFcn',[me '(''m_up'',' num2str(i) ')']);
      feval(me,'m_motion',i);
    end
  end

  %if (~handled)
  %  pt = get(func_axis,'currentpoint');
  %  x = pt(1);
  %  y = pt(3);
  %  ylim = get(func_axis,'ylim');
  %  if (abs(x) <= p_max) & (y >= ylim(1) & y <= ylim(2))

      % SET UP MOTION TRACKING FOR FUNCTION
  %    set(fig,'WindowButtonMotionFcn',[me '(''f_motion'')']);
  %    set(fig,'WindowButtonUpFcn',[me '(''f_up'')']);
  %    feval(me,'f_motion',i);
  %  end
  %end

%==================================================================
% Respond to motion in meter.
%
% ME('m_motion',meter_index)
%==================================================================

elseif strcmp(cmd,'m_motion') & ~isempty(fig)
  
  if any([3 6] == arg1)
    maxval = 2;
  elseif any([1 4 8 9] == arg1)
    maxval = 4;
  elseif any([2 5 7] == arg1)
    maxval = 1;
  else
    maxval = 4;
  end

  % GET CURRENT POINT
  pt = get(meters(arg1),'currentpoint');
  x = pt(1);
  x = round(x*10/maxval)*maxval/10;
  x = max(-maxval,min(maxval,x));

  % GET DATA
  mdgray = nnmdgray;
  values = get(values_ptr,'userdata');
 
  % MOVE INDICATOR
  if any([8 9] == arg1)
      xdata = [0.2 -0.2 0]*maxval+x;
  else
      xdata = [0 0.2 -0.2]*maxval+x;
  end
  set(indicators(arg1),'facecolor',mdgray,'edgecolor',mdgray);
  set(indicators(arg1),'facecolor',nnwhite,'edgecolor',nndkblue,'xdata',xdata);

  % STORE DATA
  values(arg1) = x;
  set(values_ptr,'userdata',values);

%==================================================================
% Respond to mouse up in meter.
%
% ME('m_up',meter_index)
%==================================================================

elseif strcmp(cmd,'m_up') & ~isempty(fig)
  
  % DISABLE TRACKING
  set(fig,'WindowButtonMotionFcn','');
  set(fig,'WindowButtonMotionFcn','');

  % RESET INDICATOR COLORS
  set(indicators(arg1),'facecolor',nnred,'edgecolor',nndkblue);

  % UPDATE FUNCTION
  cmd = 'update';

%==================================================================
% Respond to motion in function.
%
% ME('f_motion')
%==================================================================

%elseif strcmp(cmd,'f_motion') & (fig)
  
  % GET CURRENT POINT
%  pt = get(func_axis,'currentpoint');
%  x = pt(1);
%  x = max(-p_max,min(p_max,x));

  % GET DATA
%  mdgray = nnmdgray;
%  values = get(values_ptr,'userdata');
%  W1 = [values([1 4])' values([8 9])'];
%  b1 = values([2 5])';
%  W2 = values([3 6]);
%  b2 = values(7);
%  ltyell = nnltyell;
  
  % NEW INPUT & OUTPUT
%  p = x;
%  a = W2(1)*exp(-((p-W1(1)).*b1(1)).^2) + W2(2)*exp(-((p-W1(2)).*b1(2)).^2) + b2;

  % STORE DATA
%  values(10) = p;
%  values(11) = a;
%  set(values_ptr,'userdata',values);

%==================================================================
% Respond to mouse up in function.
%
% ME('f_up')
%==================================================================

%elseif strcmp(cmd,'f_up') & (fig)
  
  % DISABLE TRACKING
%  set(fig,'WindowButtonMotionFcn','');
%  set(fig,'WindowButtonMotionFcn','');

  % RESET P-LINE COLOR
%  red = nnred;
%  ltyell = nnltyell;

%==================================================================
% Set parameters.
%
% ME('set',W1,b1,W2,b2,f2)
%==================================================================

elseif strcmp(cmd,'set') & ~isempty(fig) & (nargin == 6)

  % CHECK SIZES
  if all(size(arg1) == [2 1]) & ...
     all(size(arg2) == [2 1]) & ...
     all(size(arg3) == [1 2]) & ...
     all(size(arg4) == [1 1])

    % GET VALUES
    values = get(values_ptr,'userdata');
    p = values(10);
 
    % ALTER VALUES
    W1 = min(w_max,max(-w_max,arg1));
    b1 = min(w_max,max(-w_max,arg2));
    W2 = min(w_max,max(-w_max,arg3));
    b2 = min(w_max,max(-w_max,arg4));

    [R,Q] = size(p);
    a = W2(1)*exp(-((p-W1(1)).*b1(1)).^2) + W2(2)*exp(-((p-W1(2)).*b1(2)).^2) + b2*ones(1,Q);
    values = [W1(1,1) b1(1) W2(1) W1(2,1) b1(2) W2(2) b2 W1(1,2) W1(2,2) p a];

    % SAVE VALUES
    set(values_ptr,'userdata',values);

    % MOVE METERS
    cmd = 'move';
  end

%==================================================================
% Randomize parameters.
%
% ME('random')
%==================================================================

elseif strcmp(cmd,'random') & ~isempty(fig)

  % GET VALUES
  values = get(values_ptr,'userdata');
  p = values(10);
 
  % ALTER VALUES
  W1 = (rand(2,2)*8-4)*1;
  b1 = (rand(2,1)*2-1)*1;
  W2 = (rand(1,2)*4-2)*1;
  b2 = (rand(1,1)*2-1)*1;

  [R,Q] = size(p);

  xp=-p_max:p_max/div:p_max;
  yp=xp;
  num = length(xp);
  [X,Y] = meshgrid(xp,yp);
  xx=X(:); 
  yy=Y(:);
  Q=length(yy);
  A = W2(1)*exp(-((xx-W1(1,1)).*b1(1)).^2-((yy-W1(1,2)).*b1(1)).^2) ...
      + W2(2)*exp(-((xx-W1(2,1)).*b1(2)).^2-((yy-W1(2,2)).*b1(2)).^2) + b2*ones(Q,1);
  Am = reshape(A,num,num);
  trigger=0;
  v = [trigger trigger];

  a_max = max(A);
  a_min = min(A);
  a_edge = (a_max-a_min)*0.1;

  values = [W1(1,1) b1(1) W2(1) W1(2,1) b1(2) W2(2) b2 W1(1,2) W1(2,2) xp A'];

  % SAVE VALUES
  set(values_ptr,'userdata',values);

  % MOVE METERS
  cmd = 'move';


%==================================================================
% Re-initialize parameters.
%
% ME('reset')
%==================================================================

elseif strcmp(cmd,'reset') & ~isempty(fig)

  % GET VALUES
  values = get(values_ptr,'userdata');
  p = values(10);
 
  % CONSTANTS
  W1 = [1 -1;-1 1];
  b1 = [1;1];
  W2 = [2 2];
  b2 = [-1];

  [R,Q] = size(p);

  xp=-p_max:p_max/div:p_max;
  yp=xp;
  num = length(xp);
  [X,Y] = meshgrid(xp,yp);
  xx=X(:); 
  yy=Y(:);
  Q=length(yy);
  A = W2(1)*exp(-((xx-W1(1,1)).*b1(1)).^2-((yy-W1(1,2)).*b1(1)).^2) ...
      + W2(2)*exp(-((xx-W1(2,1)).*b1(2)).^2-((yy-W1(2,2)).*b1(2)).^2) + b2*ones(Q,1);
  Am = reshape(A,num,num);
  trigger=0;
  v = [trigger trigger];

  a_max = max(A);
  a_min = min(A);
  a_edge = (a_max-a_min)*0.1;

  values = [W1(1,1) b1(1) W2(1) W1(2,1) b1(2) W2(2) b2 W1(1,2) W1(2,2) xp A'];

  % SAVE VALUES
  set(values_ptr,'userdata',values);

  % MOVE METERS
  cmd = 'move';

%==================================================================
% Get parameters.
%
% [W1,b1,W2,b2,f2] = ME('get')
%==================================================================

elseif strcmp(cmd,'get') & ~isempty(fig)

  % GET DATA
  values = get(values_ptr,'userdata');
  ret1 = [values([1 4])' values([8 9])'];
  ret2 = values([2 5])';
  ret3 = values([3 6]);
  ret4 = values(7);
end

%==================================================================
% Move meters.
%
% ME('move')
%==================================================================

if strcmp(cmd,'move') & ~isempty(fig)
  
  % GET DATA
  values = get(values_ptr,'userdata');

  % PICK PROPER ICON
  axes(fig_axis);

  % HILIGHT METERS
  mdgray = nnmdgray;
  red = nnred;
  white = nnwhite;
  dkblue = nndkblue;
  for i=1:9
    set(indicators(i),'facecolor',white);
  end
  pause(0.25)

  % MOVE METERS
  for i=1:9
    if any([3 6] == i)
      maxval = 2;
    elseif any([1 4 8 9] == i)
      maxval = 4;
    elseif any([2 5 7] == i)
      maxval = 1;
    else
      maxval = 4;
    end
    if any([8 9] == i)
        xx = [0.2 -0.2 0]*maxval+values(i);
    else
        xx = [0 0.2 -0.2]*maxval+values(i);
    end
    set(indicators(i),'facecolor',mdgray,'edgecolor',mdgray);
    set(indicators(i),'facecolor',white,'edgecolor',dkblue,'xdata',xx);
  end
  pause(0.25)

  % UNHILIGHT METERS
  for i=1:9
    set(indicators(i),'facecolor',red);
  end

  % ALWAYS DO AN UPDATE AFTERWARDS
  cmd = 'update';
end

%==================================================================
% Update function.
%
% ME('update')
%==================================================================

if strcmp(cmd,'update') & ~isempty(fig)

  % GET DATA
  %tf = get(tf_ptr,'userdata');
  values = get(values_ptr,'userdata');
  W1 = [values([1 4])' values([8 9])'];
  b1 = values([2 5])';
  W2 = values([3 6]);
  b2 = values(7);
  xp = values(10);
  ltyell = nnltyell;
  red = nnred;

  % NEW FUNCTION
  xp=-p_max:p_max/div:p_max;
  yp=xp;
  num = length(xp);
  [X,Y] = meshgrid(xp,yp);
  xx=X(:); 
  yy=Y(:);
  Q=length(yy);
  A = W2(1)*exp(-((xx-W1(1,1)).*b1(1)).^2-((yy-W1(1,2)).*b1(1)).^2) ...
      + W2(2)*exp(-((xx-W1(2,1)).*b1(2)).^2-((yy-W1(2,2)).*b1(2)).^2) + b2*ones(Q,1);
  A = reshape(A,num,num);
  trigger=0;
  v = [trigger trigger];

  a_max = max(A);
  a_min = min(A);
  a_edge = (a_max-a_min)*0.1;

  % REDRAW LINES
  set(func_line,'color',nndkblue,'xdata',xp,'ydata',yp,'zdata',A)
  set(func_line2,'xdata',xp,'ydata',yp,'zdata',A)
  
  % STORE DATA
  set(values_ptr,'userdata',values);
end
