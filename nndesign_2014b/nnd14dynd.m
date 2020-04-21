function [ret1,ret2,ret3,ret4,ret5]=nnd14dynd(cmd,arg1,arg2,arg3,arg4,arg5)
%NND14DYND Finite Impulse Response Network
%
%  This demonstration requires either the MININNET functions
%  on the NND disk or the Neural Network Toolbox.
%
%  NND14DYND
%  Opens demonstration with default values.
%
%  NND14DYND('random')
%  Sets network parameters to randomly chosen values.
%

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% $Revision: 1.0 $

%==================================================================

% CONSTANTS
me = 'nnd14dynd';

% DEFAULTS
if nargin == 0, cmd = ''; else cmd = lower(cmd); end

% FIND WINDOW IF IT EXISTS
fig = nndfgflg(me);
  
% GET WINDOW DATA IF IT EXISTS
if ~isempty(fig)
  H = get(fig,'userdata');
  fig_axis = H(1);            % window axis
  desc_text = H(2);           % handle to first line of text sequence
  meters = H(3:4);            % parameter axes
  indicators = H(5:6);        % paramter indicators
  freq_menu = H(7);           % frequency of input function
  inp_menu = H(8);            % Type of input function
  func_axis = H(9);          % network function axis
  func_line = H(10);          % network function line
  a_line = H(11);             % horizontal output line
  values_ptr = H(12);         % Network parameter, input & output values
  inp_ptr = H(13);             % 2nd layer transfer functio name
  freq_ptr = H(14);             % 2nd layer transfer functio name
  func_axis2 = H(15);          % network function axis
  func_line2 = H(16);          % network function line
  a_line2 = H(17);             % horizontal output line
  func_axis3 = H(18);          % network function axis
  func_line3 = H(19);          % network function line
  a_line3 = H(20);             % horizontal output line
  func_axis4 = H(21);          % network function axis
  func_line4 = H(22);          % network function line
  a_line4 = H(23);             % horizontal output line
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
  W1 = [1/2; -1/2];
  inp = 'square';
  freq=1/12;
  p = 0;
  values = [W1(1) W1(2)];

  % NEW DEMO FIGURE
  fig = nndemof2(me,'DESIGN','Dynamic Derivatives','','Chapter 14');
  set(fig, ...
    'windowbuttondownfcn',nncallbk(me,'down'), ...
    'BackingStore','off',...
    'nextplot','add');
  H = get(fig,'userdata');
  fig_axis = H(1);
  desc_text = H(2);

  % ICON
  nndicon(14,458,363,'shadow')

  % NETWORK POSITIONS
  x1 = 40;     % input
  x2 = x1+90+10;  % 1st layer sum
  x3 = x2+40;  % 1st layer transfer function
  x4 = x3+100; % 2nd layer sum
  x5 = x4+40;  % 2nd layer transfer function
  x6 = x5+50;  % output
  y1 = 265;    % top neuron
  y2 = y1-20;  % input & output neuron
  y3 = y1-40;  % bottom neuron
  sz = 15;     % size of icons
  wx = 50;     % weight vertical offset (from 1st layer)
  wy = 55;     % weight horizontal offset (from middle)

  % NETWORK INPUT
  nndtext(x1-10,y2+110,'p');
  plot([x1 x2+60 x4-14],[y2+110 y2+110 y2+87],'linewidth',2,'color',nnred);
  plot([x3-75 x3-75 x5+sz+15 x5+sz+15],[y2+65 y1 y1 y2+87],'linewidth',2,'color',nnred);

  % TOP NEURON
  %nndsicon('delay',x3-80,y1+70,sz)

  % BOTTOM NEURON
  nndsicon('delay',x3-75,y1+25,sz)

  % OUTPUT NEURON
  plot([x3-75 x2+60 x4-14],[y2+65 y2+65 y2+87],'linewidth',2,'color',nnred);
  plot([x4 x6],[y2+87 y2+87],'linewidth',2,'color',nnred);
  plot([x6-10 x6 x6-10],[y2+80 y2+87 y2+94],'linewidth',2,'color',nnred);
  nndsicon('sum',x4,y2+87,sz)
  nndsicon('purelin',x5,y2+87,sz);
  nndtext(x3+wx,y2+wy+36,'iW(0)');
  nndtext(x3+wx,y2+52,'lW(1)');
  %nndtext(x3+wx,y2-wy+73,'iW(2)');
  nndtext(x5+sz+5,y2+95,'a(t)','left');

  % PARAMETER POSITIONS
  xx = 120 + 10; %20 + [0:3]*90;
  yy = [330 285 240];

  % PARAMETER METERS & INDICATORS
  meters = [];
  indicators = [];
  for i=1:2
      pn = i;
      val = values(pn);
      maxval = 2;
      maxstr = num2str(maxval);
      ax = nnsfo('a2','','','');
      set(ax,...
          'units','points',...
          'position',[xx yy(i) 70 20],...
          'color',nnmdgray,...
          'ylim',[-0.3 1.3],...
          'ytick',[],...
          'xlim',[-1.3 1.3]*maxval,...
          'xtick',[-1 -0.5 0 0.5 1]*maxval,...
          'xticklabel',str2mat(['-' maxstr],'','0','',maxstr));
      ind = fill([0 0.2 -0.2]*maxval+val,[0 1 1],nnred,...
          'edgecolor',nndkblue);
      meters = [meters ax];
      indicators = [indicators ind];
  end

  % TRANSFER FUNCTION POPUP MENU
  inp_menu = uicontrol(...
    'units','points',...
    'position',[5 yy(1)-10 85 20],...
    'style','popupmenu',...
    'string','square|sine',...
    'callback',[me '(''inp'')']);
  set(inp_menu,'value',1);

  freq_menu = uicontrol(...
    'units','points',...
    'position',[5 yy(1)-40 85 20],...
    'style','popupmenu',...
    'string','1/16|1/14|1/12|1/10|1/8',...
    'callback',[me '(''freq'')']);
  set(freq_menu,'value',3);

  % PARAMETER LINES
  xx = xx + 0.5;
  y = yy(1)+10;
  x = xx(1)+70;
  plot([0 5 5]+x,[0 0 35]+y,'color',nndkgray);
  y = yy(2)+10;
  plot([0 5 5]+x,[0 0 35]+y,'color',nndkgray);
  y = yy(3)+10;
  plot([0 5 5]+x,[0 0 35]+y,'color',nndkgray);

  % NETWORK FUNCTION
  a0 = 0;
  a_1 = 0;
  p = [1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1];
  w110 = 1/2;
  w111 = -1/2;

  t = 1:length(p);
  t1 = 0:length(p);
  %num = [w110 w111];
  %den = [1];
  num = [w110];
  den = [1 w111];
  zi = [a0];
  A = filter(num,den,p,zi);

  % FUNCTION AXIS
  y = 20;
  x = 40;
  func_axis = nnsfo('a2','','','');
  set(func_axis, ...
    'units','points',...
    'position',[x-15 y+130 160 90],...
    'color',nnltyell);
  p_line = plot([0 25],[0 0],'--',...
    'color',nnred);
  func_line = plot(t1,[a0 A],...
    '.k','color',nndkblue,...
    'linewidth',2);
  lw111 = w111;
  iw11 = w110+.1;
  num = [iw11];
  den = [1 lw111];
  a1 = filter(num,den,p,zi);
  a_line = plot(t1,[a0 a1],'xb');

  a_max = max([A a1]);
  a_min = min([A a1]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])

  title('Incremental Response iw+0.1')

  func_legend = nnsfo('a2','','','');
  set(func_legend, ...
    'units','points',...
    'position',[x+360 y+150 80 25],...
    'color',nnltyell)
  plot(1,1,'.k',1,1,'xb',1,1,'db',1,1,'sk')
  set(gca,'XTick',[],'YTick',[])
  lege=legend('Original Response','Incremental Response',...
      'Total Derivative','Static Derivative','location','best');
  set(lege,'fontsize',7);

  da_diw_0 = 0;
  da_diw = filter(1,den,p,da_diw_0);
  func_axis2 = nnsfo('a2','','','');
  set(func_axis2, ...
    'units','points',...
    'position',[x-15 y 160 90],...
    'color',nnltyell)
  p_line2 = plot([0 25],[0 0],'--',...
    'color',nnred);
  a_line2 = plot(t1,[da_diw_0 da_diw],'db','markersize',5);
  func_line2 = plot(t,p,...
    'sk','markersize',4);

  a_max = max([p da_diw]);
  a_min = min([p da_diw]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis2, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])

  title('derivative with respect iw')

  da_dlw_0 = 0;
  ad = [a0 A(1:end-1)];
  da_dlw = filter(1,den,ad,da_dlw_0);

  func_axis3 = nnsfo('a2','','','');
  set(func_axis3, ...
    'units','points',...
    'position',[x+170 y 160 90],...
    'color',nnltyell,...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])
  p_line3 = plot([0 25],[0 0],'--',...
    'color',nnred);
  a_line3 = plot(t1,[da_dlw_0 da_dlw],'db','markersize',5);
  func_line3 = plot(t,ad,...
    'sk','markersize',4);

  a_max = max([p da_dlw]);
  a_min = min([p da_dlw]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis3, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])

  title('derivative with respect lw')

  func_axis4 = nnsfo('a2','','','');
  set(func_axis4, ...
    'units','points',...
    'position',[x+170 y+130 160 90],...
    'color',nnltyell,...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])
  p_line4 = plot([0 25],[0 0],'--',...
    'color',nnred);
  func_line4 = plot(t1,[a0 A],...
    '.k','color',nndkblue,...
    'linewidth',2);

  lw111 = w111+.1;
  iw11 = w110;
  num = [iw11];
  den = [1 lw111];
  a1 = filter(num,den,p,zi);

  a_line4 = plot(t1,[a0 a1],'xb');

  a_max = max([A a1]);
  a_min = min([A a1]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis4, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])

  title('Incremental Response lw+0.1')

  % BUTTONS
  drawnow % Let everything else appear before buttons 
  uicontrol(...
    'units','points',...
    'position',[400 130 60 20],...
    'string','Random',...
    'callback',[me '(''random'')'])
  uicontrol(...
    'units','points',...
    'position',[400 105 60 20],...
    'string','Reset',...
    'callback',[me '(''reset'')'])
  uicontrol(...
    'units','points',...
    'position',[400 80 60 20],...
    'string','Contents',...
    'callback','nndtoc')
  uicontrol(...
    'units','points',...
    'position',[400 55 60 20],...
    'string','Close',...
    'callback',[me '(''close'')'])

  % DATA POINTERS
  value_ptr = uicontrol('visible','off','userdata',values);
  inp_ptr = uicontrol('visible','off','userdata',inp);
  freq_ptr = uicontrol('visible','off','userdata',freq);

  % SAVE WINDOW DATA AND LOCK
  H = [fig_axis desc_text meters indicators  freq_menu inp_menu ...
    func_axis func_line a_line value_ptr inp_ptr freq_ptr ...
    func_axis2 func_line2 a_line2 ...
    func_axis3 func_line3 a_line3 ...
    func_axis4 func_line4 a_line4];

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
    'Show the meaning of',...
    'dynamics derivatives',....
    '',...
    'Select the input and',...
    'frequency to the IIR',...
    'network.',...
    '',...
    'Alter network weights by',...
    'dragging the triangular',...
    'shaped indicators.')
    
%==================================================================
% Respond to transfer function menu.
%
% ME('inp')
%==================================================================

elseif strcmp(cmd,'inp') & ~isempty(fig)

  % GET NEW TRANSFER FUNCTION NAME
  i = get(inp_menu,'value');
  if i == 1, inp = 'square';
  elseif i == 2, inp = 'sine';
  end

  % SAVE DATA
  set(inp_ptr,'userdata',inp);
  
  % UPDATA FUNCTION
  cmd = 'update';

%==================================================================
% Respond to transfer function menu.
%
% ME('freq')
%==================================================================

elseif strcmp(cmd,'freq') & ~isempty(fig)

  % GET NEW TRANSFER FUNCTION NAME
  i = get(freq_menu,'value');
  if i == 1, freq = 1/16;
  elseif i == 2, freq = 1/14;
  elseif i == 3, freq = 1/12;
  elseif i == 4, freq = 1/10;
  elseif i == 5, freq = 1/8;
  end

  % SAVE DATA
  set(freq_ptr,'userdata',freq);
  
  % UPDATA FUNCTION
  cmd = 'update';

%==================================================================
% Respond to mouse down.
%
% ME('down')
%==================================================================

elseif strcmp(cmd,'down') & ~isempty(fig) & (nargin == 1)

  handled = 0;
  for i=1:2

    maxval = 2;

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
  %end

%==================================================================
% Respond to motion in meter.
%
% ME('m_motion',meter_index)
%==================================================================

elseif strcmp(cmd,'m_motion') & ~isempty(fig)
  
  maxval = 2;

  % GET CURRENT POINT
  pt = get(meters(arg1),'currentpoint');
  x = pt(1);
  x = round(x*10/maxval)*maxval/10;
  x = max(-maxval,min(maxval,x));

  % GET DATA
  mdgray = nnmdgray;
  values = get(values_ptr,'userdata');
 
  % MOVE INDICATOR
  xdata = [0 0.2 -0.2]*maxval+x;
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
% Respond to mouse up in function.
%
% ME('f_up')
%==================================================================

elseif strcmp(cmd,'f_up') & ~isempty(fig)
  
  % DISABLE TRACKING
  set(fig,'WindowButtonMotionFcn','');
  set(fig,'WindowButtonMotionFcn','');

  % RESET P-LINE COLOR
  red = nnred;
  %set(p_line,'color',red)
  %set(a_line,'color',red)
  set(func_line,'color',nndkblue)

%==================================================================
% Randomize parameters.
%
% ME('random')
%==================================================================

elseif strcmp(cmd,'random') & ~isempty(fig)

  % GET VALUES
  values = get(values_ptr,'userdata');
  %p = values(8);
 
  % ALTER VALUES
  W1 = (rand(3,1)*2-1)*2;
  inp_ind = fix(rand*2)+1;
  set(inp_menu,'value',inp_ind)
  if inp_ind == 1
    inp = 'square';
  elseif inp_ind == 2
    inp = 'sine';
  end
  set(inp_ptr,'userdata',inp)

  freq_ind = fix(rand*5)+1;
  set(freq_menu,'value',freq_ind)
  if freq_ind == 1
    freq = 1/16;
  elseif freq_ind == 2
    freq = 1/14;
  elseif freq_ind == 3
    freq = 1/12;
  elseif freq_ind == 4
    freq = 1/10;
  elseif freq_ind == 5
    freq = 1/8;
  end
  set(freq_ptr,'userdata',freq)

  values = [W1(1) W1(2) W1(3)];

  % SAVE VALUES
  set(values_ptr,'userdata',values);

  % MOVE METERS
  cmd = 'move';

%==================================================================
% Randomize parameters.
%
% ME('reset')
%==================================================================

elseif strcmp(cmd,'reset') & ~isempty(fig)

  % GET VALUES
  values = get(values_ptr,'userdata');
 
  % ALTER VALUES
  W1 = [1/2 -1/2];
  inp_ind = 1;
  set(inp_menu,'value',inp_ind)
  inp = 'square';
  set(inp_ptr,'userdata',inp)

  freq_ind = 3;
  set(freq_menu,'value',freq_ind)
  freq = 1/12;
  set(freq_ptr,'userdata',freq)

  values = [W1(1) W1(2)];

  % SAVE VALUES
  set(values_ptr,'userdata',values);

  % MOVE METERS
  cmd = 'move';

end

%==================================================================
% Move meters.
%
% ME('move')
%==================================================================

if strcmp(cmd,'move') & ~isempty(fig)
  
  % GET DATA
  values = get(values_ptr,'userdata');

  % HILIGHT METERS
  mdgray = nnmdgray;
  red = nnred;
  white = nnwhite;
  dkblue = nndkblue;
  for i=1:2
    set(indicators(i),'facecolor',white);
  end
  pause(0.25)

  % MOVE METERS
  for i=1:2
    maxval = 2;
    xx = [0 0.2 -0.2]*maxval+values(i);
    set(indicators(i),'facecolor',mdgray,'edgecolor',mdgray);
    set(indicators(i),'facecolor',white,'edgecolor',dkblue,'xdata',xx);
  end
  pause(0.25)

  % UNHILIGHT METERS
  for i=1:2
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
  inp = get(inp_ptr,'userdata');
  freq = get(freq_ptr,'userdata');
  values = get(values_ptr,'userdata');
  W1 = values([1:2])';
  if strcmp(inp,'square')
      if freq==1/16
          p = [1 1 1 1  1  1  1  1 -1 -1 -1 -1 -1 -1 -1 -1  1  1  1  1  1  1  1  1];
      elseif freq==1/14
          p = [1 1 1 1  1  1  1 -1 -1 -1 -1 -1 -1 -1  1  1  1  1  1  1  1 -1 -1 -1];
      elseif freq==1/12
          p = [1 1 1 1  1  1 -1 -1 -1 -1 -1 -1  1  1  1  1  1  1 -1 -1 -1 -1 -1 -1];
      elseif freq==1/10
          p = [1 1 1 1  1 -1 -1 -1 -1 -1  1  1  1  1  1 -1 -1 -1 -1 -1  1  1  1  1];
      elseif freq==1/8
          p = [1 1 1 1 -1 -1 -1 -1  1  1  1  1 -1 -1 -1 -1  1  1  1  1 -1 -1 -1 -1];
      end
  else
      p = [sin((0:23)*2*pi*freq)];
  end
  ltyell = nnltyell;
  red = nnred;
  blue = get(a_line,'color');

  % NEW FUNCTION
  a0 = 0;
  a_1 = 0;
  t = 1:length(p);
  t1 = 0:length(p);
  %num = [W1(1) W1(2)];
  %den = [1];
  
  num = [W1(1)];
  den = [1 W1(2)];
  zi = [a0];
  A = filter(num,den,p,zi);
  
  % CALCULATE AXIS AND LINE LIMITS
  a_max = max([A 1]);
  a_min = min([A -1]);
  a_mid = (a_max+a_min)/2;
  a_dif = a_max-a_min;

  a_dif = a_dif + max(a_dif*0.1,0.1);
  a_max = a_mid+0.45*a_dif;
  a_min = a_mid-0.45*a_dif;
  a_edge = 0.05*a_dif;

  % HIDE LINES
  set(func_line,'color',ltyell);
  set(a_line,'color',ltyell);

  % RESIZE AXIS
  set(func_axis,'ylim',[a_min-a_edge a_max+a_edge]);
  hold on

  % REDRAW LINES
  set(func_line,'color',nndkblue,'xdata',t1,'ydata',[a0 A])
  lw111 = W1(2);
  iw11 = W1(1)+.1;
  num = [iw11];
  den = [1 lw111];
  a1 = filter(num,den,p,zi);
  set(a_line,'color',blue,'ydata',[a0 a1],'xdata',t1)

  a_max = max([A a1]);
  a_min = min([A a1]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])
  
  da_diw_0 = 0;
  da_diw = filter(1,den,p,da_diw_0);
  set(a_line2,'xdata',t1,'ydata',[da_diw_0 da_diw]);
  set(func_line2,'xdata',t,'ydata',p);

  a_max = max([p da_diw]);
  a_min = min([p da_diw]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis2, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])

  da_dlw_0 = 0;
  ad = [a0 A(1:end-1)];
  da_dlw = filter(1,den,ad,da_dlw_0);

  set(a_line3,'xdata',t1,'ydata',[da_dlw_0 da_dlw]);
  set(func_line3,'xdata',t,'ydata',ad);

  a_max = max([p da_dlw]);
  a_min = min([p da_dlw]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis3, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])

  set(func_line4,'xdata',t1,'ydata',[a0 A]);

  lw111 = W1(2)+.1;
  iw11 = W1(1);
  num = [iw11];
  den = [1 lw111];
  a1 = filter(num,den,p,zi);

  set(a_line4,'xdata',t1,'ydata',[a0 a1]);

  a_max = max([A a1]);
  a_min = min([A a1]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis4, ...
    'xlim',[0 25],...
    'ylim',[a_min a_max]+[-a_edge a_edge])




  
  % STORE DATA
  set(values_ptr,'userdata',values);
end
