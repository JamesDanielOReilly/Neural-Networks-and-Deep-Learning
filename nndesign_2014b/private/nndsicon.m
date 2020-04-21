function h = nndicon(n,x,y,s)
%NNDSICON Neural Network Design utility function.

% NNDSICON(C,X,Y,S)
%   N - Icon Name.
%   X - Horizontal position.
%   Y - Vertical position.
%   S - Size (default = 15).
% Draws small icon N at position (X,Y).

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% $Revision: 1.6 $
% First Version, 8-31-95.

%==================================================================

% DEFAULTS
if nargin < 4, s = 15; end

% COLORS
red = nnred;
blue = nndkblue;
yellow = nnyellow;
orange = [1 0.5 0];

% STORE FIGURE STATE
fig = gcf;
ax = gca;
NPF = get(fig,'nextplot');
NPA = get(gca,'nextplot');
set(fig,'nextplot','add');
set(ax,'nextplot','add');

% BOX
rect_x = [-1 1 1 -1];
rect_y = [-1 -1 1 1];
box_h = fill(x+rect_x*s,y+rect_y*s,blue,'edgecolor',red);

% ADJUST SIZE
s = s/15;
% NOTE: S is divided by 15 so plotting below can be done
% in a box with x and y values in the interval [-10, 10]
% leaving a border.

% CONTENT
if strcmp(n,'sum')
  xx = [8 -8 -2 -8 8];
  yy = [10 10 0 -10 -10];
  hh = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);

elseif strcmp(n,'f')
  xx = [6 -6 -6 6 -6 -6];
  yy = [10 10 0 0 0 -10];
  hh = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);

elseif strcmp(n,'hardlim')
  xx = [-10 10];
  yy = [-10 -10];
  h1 = plot(xx*s+x,yy*s+y,'color',red,'linewidth',2);
  xx = [-10 0 0 10];
  yy = [-10 -10 10 10];
  h2 = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  hh = [h1;h2];

elseif strcmp(n,'hardlims')
  xx = [-10 10];
  yy = [0 0];
  h1 = plot(xx*s+x,yy*s+y,'color',red,'linewidth',2);
  xx = [-10 0 0 10];
  yy = [-10 -10 10 10];
  h2 = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  hh = [h1;h2];

elseif strcmp(n,'purelin')
  xx = [-10 10];
  yy = [0 0];
  h1 = plot(xx*s+x,yy*s+y,'color',red,'linewidth',2);
  xx = [-10 10];
  yy = [-10 10];
  h2 = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  hh = [h1;h2];

elseif strcmp(n,'logsig')
  xx = [-10 10];
  yy = [-10 -10];
  h1 = plot(xx*s+x,yy*s+y,'color',red,'linewidth',2);
  xx = -10:10;
  %yy = logsig(xx/2)*20-10;
  yy = nndlogsig(xx/2)*20-10;
  h2 = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  hh = [h1;h2];

elseif strcmp(n,'satlins')
  xx = [-10 10];
  yy = [0 0];
  h1 = plot(xx*s+x,yy*s+y,'color',red,'linewidth',2);
  xx = [-10 -5 5 10];
  yy = [-10 -10 10 10];
  h2 = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  hh = [h1;h2];

elseif strcmp(n,'tansig')
  xx = [-10 10];
  yy = [0 0];
  h1 = plot(xx*s+x,yy*s+y,'color',red,'linewidth',2);
  xx = -10:10;
  %yy = tansig(xx/4)*10;
  yy = nndtansig(xx/4)*10;
  h2 = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  hh = [h1;h2];

% ODJ 1/12/08 Delay function included
elseif strcmp(n,'delay')
  xx = [-6  -6 -4 -3 -2 -1 0  1 2 3 4 4 4  3 2 1  0 -1 -2 -3 -4 -6];
  x1=[4  3 2 1  0 -1 -2 -3];
  x2=fliplr(x1);
  yy = [-10.3125 10.3125 10.3125 -[(6/32)*x2.^2+x2-9]  0 [(6/32)*x1.^2+x1-9] -10.3125 -10.3125]-1;
  hh = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);

% ODJ 9/16/06 radbas function included
elseif strcmp(n,'radbas')
  xx = [-10 10];
  yy = [-10 -10];
  h1 = plot(xx*s+x,yy*s+y,'color',red,'linewidth',2);
  xx = -10:10;
  yy = nndradbas(xx/4)*20-10;
  h2 = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  hh = [h1;h2];
  
% ODJ 9/16/06 dotprod function included
elseif strcmp(n,'dotprod')
  xx = [8 -2 nan 3 3 nan 6 -1 nan -1 6 nan -9 -8 -8 -9 -9];
  yy = [0 0 nan 5 -5 nan 4 -3 nan 4 -3 nan -1 -1  1  1 -1];
  hh = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
  
% ODJ 9/16/06 dist function included
elseif strcmp(n,'dist')
  xx = [-11 -11 nan -8 -8 nan  8 8 nan  11 11];
  yy = [-9  9 nan -9  9 nan -9 9 nan -9 9];
  hh = plot(xx*s+x,yy*s+y,'color',yellow);
  xx = [ 4 4 nan  4 -1 -4 -1  4];
  yy = [-7 7 nan -1  0 -3 -6 -5];
  hh = plot(xx*s+x,yy*s+y,'color',yellow,'linewidth',2);
end

% RESTORE FIGURE STATE
set(ax,'nextplot',NPA);
set(fig,'nextplot',NPF);

% RETURN ICON
if nargout, h = [box_h; hh]; end
