function [gw] = dn_grad1NLrecur(iw,lw,p,yt,a0,pltFlg)

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if (nargin<5), a0=0; end;
if (nargin<6), pltFlg = 0; end;

% Initialize forward calculation
%y(1) = tansig(iw*p(1)+lw*a0);
y(1) = nndtansig(iw*p(1)+lw*a0);

% Intitialize gradient calculation
e(1) = yt(1) - y(1);
df = 1-y(1)^2;
dy_diw = df*p(1);
dy_dlw = df*a0;
gw = -2*e(1)*[dy_diw;dy_dlw];

for i=1:length(p)-1,

  % Forward calculation
  %y(i+1) = tansig(iw*p(i+1)+lw*y(i));
  y(i+1) = nndtansig(iw*p(i+1)+lw*y(i));

  % Gradient calculation
  df = 1-y(i+1)^2;
  dy_diw = df*(p(i+1) + lw*dy_diw);
  dy_dlw = df*(y(i) + lw*dy_dlw);
  e(i+1) = yt(i+1) - y(i+1);
  gw = gw - 2*e(i+1)*[dy_diw;dy_dlw];
end

% Plotting

if pltFlg
  nrm = norm(gw);
  if nrm ~=0,
    gwn = gw/norm(gw);
  else
    gwn = gw;
  end

  ax = axis;
  scale = (ax(2)-ax(1))/(ax(4)-ax(3));

  len = sqrt((gwn(1)/scale)^2 + gwn(2)^2);
  gwn = gwn/(len*24);

  overscale = sqrt((ax(2)-ax(1))^2 + (ax(4)-ax(3))^2 );

  gwn = overscale*gwn;
  t=(.01:.01:1)'*2*pi;
  circ_x=sin(t)*.00625*scale*overscale;
  circ_y=cos(t)*.00625*overscale;

  hold on
  plot(iw+circ_x,lw+circ_y,'color','r');
  plot([iw iw+gwn(1)],[lw lw+gwn(2)],'r');
  hold off
end
