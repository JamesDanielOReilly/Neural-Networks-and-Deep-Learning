function y = dn_sim1NLrecur(iw,lw,p,a0)

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth

if size(iw,2)==1
    %y(1) = tansig(iw*p(1)+lw*a0);
    y(1) = nndtansig(iw*p(1)+lw*a0);

    for i=1:length(p)-1,
        %y(i+1) = tansig(iw*p(i+1)+lw*y(i));
        y(i+1) = nndtansig(iw*p(i+1)+lw*y(i));
    end
else
    %y(1,:) = tansig(iw*p(1)+lw*a0);
    y(1,:) = nndtansig(iw*p(1)+lw*a0);

    for i=1:length(p)-1,
        %y(i+1,:) = tansig(iw*p(i+1)+lw*y(i,:));
        y(i+1,:) = nndtansig(iw*p(i+1)+lw*y(i,:));
    end
end
