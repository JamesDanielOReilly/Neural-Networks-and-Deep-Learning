clear
clc
close all

P = [2 1 -2 -1; 2 -2 2 1];
T = [0 1 0 1];
plotpv(P,T);

epochs = 20;
Pnew = [1; 0.3];

net = newp(P, T, 'hardlim', 'learnp');
net = init(net);
plotpv(X,T);
plotpc(net.IW{1},net.b{1});

net.trainParam.epochs = epochs;
[net, tr_descr] = train(net, P, T);
plotpc(net.IW{1},net.b{1});

y = net(Pnew);
plotpv(x, Pnew);
point = findobj(gca,'type','line');
point.Color = 'red';

hold on;
plotpv(P,T);
plotpc(net.IW{1},net.b{1});
hold off;