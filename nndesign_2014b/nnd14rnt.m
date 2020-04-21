function [ret1,ret2,ret3,ret4,ret5]=nnd14rnt(cmd,arg1,arg2,arg3,arg4,arg5)
%NND14RNT Recurrent Network Training
%
%  This demonstration requires either the MININNET functions
%  on the NND disk or the Neural Network Toolbox.
%
%  NND14RNT
%  Opens demonstration with default values.
%
%

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% $Revision: 1.0 $

%==================================================================

% CONSTANTS
me = 'nnd14rnt';

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
  func_axis = H(7);          % network function axis
  func_line = H(8);          % network function line
  a_line = H(9);             % horizontal output line
  values_ptr = H(10);         % Network parameter, input & output values
  inp_ptr = H(11);             % 2nd layer transfer functio name
  freq_ptr = H(12);             % 2nd layer transfer functio name
  func_axis2 = H(13);          % network function axis
  func_line2 = H(14);          % network function line
  a_line2 = H(15);             % horizontal output line
  func_axis3 = H(16);          % network function axis
  a_line3 = H(17);          % network function line
  a_line4 = H(18);             % horizontal output line
  a_line5 = H(19);             % horizontal output line
  a_line6 = H(20);             % horizontal output line
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
  fig = nndemof2(me,'DESIGN','Recurrent Network Training','','Chapter 14');
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
  x2 = x1+90;  % 1st layer sum
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
  plot([x3-80 x3-80 x5+sz+15 x5+sz+15],[y2+65 y1 y1 y2+87],'linewidth',2,'color',nnred);

  % BOTTOM NEURON
  nndsicon('delay',x3-80,y1+25,sz)

  % OUTPUT NEURON
  plot([x3-80 x2+60 x4-14],[y2+65 y2+65 y2+87],'linewidth',2,'color',nnred);
  plot([x4 x6],[y2+87 y2+87],'linewidth',2,'color',nnred);
  plot([x6-10 x6 x6-10],[y2+80 y2+87 y2+94],'linewidth',2,'color',nnred);
  nndsicon('sum',x4,y2+87,sz)
  nndsicon('tansig',x5,y2+87,sz);
  nndtext(x3+wx,y2+wy+36,'iW(0)');
  nndtext(x3+wx,y2+52,'lW(1)');
  nndtext(x5+sz+5,y2+95,'a(t)','left');

  % PARAMETER POSITIONS
  xx = 120; %20 + [0:3]*90;
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
  p = [.25*ones(1,3) 0.75*ones(1,5) -.75*ones(1,4) .55*ones(1,3) -0.25*ones(1,5)];

  t = 1:length(p);
  t1 = 0:length(p);
  
  iw = 0.5;
  lw = 0.5;
  A = dn_sim1NLrecur(iw,lw,p,a0);

  % FUNCTION AXIS
  y = 20;
  x = 40;
  func_axis = nnsfo('a2','','','');
  set(func_axis, ...
    'units','points',...
    'position',[x-15 y+130 128 90],...
    'color',nnltyell);
  p_line = plot([0 20],[0 0],'--',...
    'color',nnred);
  func_line = plot(t1,[a0 A],...
    '.k','color',nndkblue,...
    'linewidth',2);
  a_line = plot(t1,[a0 p],'ob',...
    'MarkerSize',3);
  a_line2 = plot(t,p,'+b',...
    'MarkerSize',3);
  set(a_line2,'visible','off');

  a_max = max([A p]);
  a_min = min([A p]);
  a_edge = (a_max-a_min)*0.1;

  set(func_axis, ...
    'xlim',[0 20],...
    'ylim',[a_min a_max]+[-a_edge a_edge])

  title('Input and Target Sequences')

  xx = -2:.1:2;
  yy = -2:.1:2;
  num = length(p);
  error = [];
  j = 1;
  for y1 = yy,
     y2 = dn_sim1NLrecur(xx,y1,p,a0)';
     i = 1;
     for x1=xx
        e = A-y2(i,:);
        error(i,j) = sum(sum(e.*e))/num;
        i=i+1;
     end
     j = j+1;
  end
  [X,Y] = meshgrid(xx,yy);

  func_axis2 = nnsfo('a2','','','');
  set(func_axis2, ...
    'units','points',...
    'position',[x-15 y 128 90],...
    'color',nnltyell)
  p_line2 = meshz(X,Y,error');
  set(gca,'XColor',[0 0 0])
  set(gca,'YColor',[0 0 0])
  set(gca,'ZColor',[0 0 0])
  set(gcf,'Color',[1 1 1])
  ch=get(gca,'Children');
  set(ch,'facecolor',[1 1 1])
  set(ch,'edgecolor',[0 0 0])
  vw = [-37.5+180 30];
  view(vw)
  set(get(func_axis2,'zlabel'),'string','');
  
  func_line2 = 0;

  title('Performance Surface')

  da_dlw_0 = 0;
  ad = [a0 A(1:end-1)];

  func_axis3 = nnsfo('a2','','','');
  set(func_axis3, ...
    'units','points',...
    'position',[x+150 y 170 170],...
    'color',nnltyell); %,...
  p_line3 = contour(X,Y,error',logspace(-2,0.5,15));
  a_line3=plot(0,0,'.b','MarkerSize',18);
  set(a_line3,'visible','off');
  a_line4=plot(0,0,'.b','MarkerSize',10);
  set(a_line4,'visible','off');
  a_line5=plot(0,0,'-b');
  set(a_line5,'visible','off');
  a_line6=plot(iw,lw,'ob','MarkerSize',5);
  set(a_line6,'visible','off');

  set(get(func_axis3,'children'),'color',[0 0 0]);
  title('Steepest Descent Trajectory')

  % BUTTONS
  drawnow % Let everything else appear before buttons 
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
  H = [fig_axis desc_text meters indicators ...
    func_axis func_line a_line value_ptr inp_ptr freq_ptr ...
    func_axis2 func_line2 a_line2 ...
    func_axis3 a_line3 a_line4 a_line5 a_line6];

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
    'Show the change in', ...
    'weight values due to', ...
    'the training of a',...
    'a recurrent network',....
    '',...
    'Click in the lower',...
    'right figure to select',...
    'initial weight values.',...
    '',...
    'The weights will be',...
    'updated and the',...
    'network output will be', ...
    'shown at the upper left', ...
    'figure.')
    

%==================================================================
% Respond to mouse down.
%
% ME('down')
%==================================================================

elseif strcmp(cmd,'down') & ~isempty(fig) & (nargin == 1)

    
  axes(func_axis3)
  [in,x10,x20] = nnaxclik(func_axis3);
    
  if (in)
    % trick to refresh window
    set(a_line3,'visible','off')
    set(a_line4,'visible','off')
    set(a_line5,'visible','off')
    set(a_line6,'visible','off')
    set(func_axis3,'visible','off')
    set(func_axis3,'visible','on')
    
    P = [.25*ones(1,3) 0.75*ones(1,5) -.75*ones(1,4) .55*ones(1,3) -0.25*ones(1,5)];
    t = 1:length(P);
    a0 = 0;

    iw = 0.5;
    lw = 0.5;
    T = dn_sim1NLrecur(iw,lw,P,a0);
    set(a_line3,'xdata',x10,'ydata',x20,'visible','on');

    % INITIALIZE PARAMETERS
    x = x10;
    y = x20;

    % INITIALIZE TRAINING
    Lx = x;
    Ly = y;
    iw = x;
    lw = y;

    A2 = dn_sim1NLrecur(x,y,P,a0);
    E = T-A2;
    set(a_line2,'ydata',A2,'visible','on');

    % TRAINING RECORD
    errors = [sum(sum(E.*E))];

    fa=sum(sum(E.*E));

    % CALCULATE THE GRADIENT
    [gw] = dn_grad1NLrecur(x,y,P,T,a0);

    % NORM OF GRADIENT
    nrmrt=sqrt(gw'*gw);

    % INITIALIZE DIRECTION
    dW=-gw;

    % ASSIGN PARAMETERS
    tau=0.618;
    tau1=1-tau;
    scaletol=20;
    delta=0.01;
    tol=delta/scaletol;
    scale=2.0;
    bmax=26;

    max_epoch=100;
    a=0.1;
    disp_freq=1;
    newxT=x10;
    newyT=x20;
    % MAIN LOOP
    for epoch=1:(max_epoch)

      % INITIALIZE A
      faold=fa;

      % CALCULATE INITIAL SSE 
      newx = x + a*dW(1);
      newy = y + a*dW(2);
      temp = T -  dn_sim1NLrecur(newx,newy,P,a0);
      fb = sum(sum(temp.*temp));

      % UPDATE VARIABLES
      newx = x + a*dW(1);
      newy = y + a*dW(2);
      temp = T -  dn_sim1NLrecur(newx,newy,P,a0);
      fa = sum(sum(temp.*temp));
      x = newx;
      y = newy;
  
      % CALCULATE GRADIENT
      A2 = dn_sim1NLrecur(x,y,P,0);
      E = T-A2;
      [gw] = dn_grad1NLrecur(x,y,P,T,a0);

      % NORM OF GRADIENT
      nrmrt=sqrt(gw'*gw);

      % CHECK FOR CONVERGENCE
      if nrmrt<.2, break, end
  
      % SEARCH DIRECTION
      dW=-gw;
  
      % EVALUATE & DISPLAY
      errors = [errors fa];

      % DISPLAY PROGRESS
      if rem(epoch,disp_freq) == 0
        %figure(22)
        %xc=circ_x1+newx;
        %yc=circ_y1+newy;
        newxT=[newxT newx];
        newyT=[newyT newy];
        set(a_line4,'xdata',newxT,'ydata',newyT,'visible','on');
        set(a_line5,'xdata',newxT,'ydata',newyT,'visible','on');
        %fill(xc,yc,'b','EdgeColor','b')
        %plot([Lx newx],[Ly newy],'b-','linewidth',1,'color','b');
        Lx = newx;
        Ly = newy;
        %figure(21)
        aa = dn_sim1NLrecur(newx,newy,P,a0);
        %delete(ha)
        %ha = plot(t,aa,'+');
        set(func_axis2,'visible','off')
        set(func_axis2,'visible','on')
        set(a_line2,'ydata',aa,'visible','on');
        %axis([0 length(P) -1 1]);

        mdgray = nnmdgray;
        maxval = 2;
        xdata = [0 0.2 -0.2]*maxval+newx;
        set(indicators(1),'facecolor',mdgray,'edgecolor',mdgray);
        set(indicators(1),'facecolor',nnwhite,'edgecolor',nndkblue,'xdata',xdata);
        set(indicators(1),'facecolor',nnred,'edgecolor',nndkblue);
        xdata = [0 0.2 -0.2]*maxval+newy;
        set(indicators(2),'facecolor',mdgray,'edgecolor',mdgray);
        set(indicators(2),'facecolor',nnwhite,'edgecolor',nndkblue,'xdata',xdata);
        set(indicators(2),'facecolor',nnred,'edgecolor',nndkblue);
        
        pause(0.05)
      end
    end
  end
  
  set(a_line6,'visible','on')

end


