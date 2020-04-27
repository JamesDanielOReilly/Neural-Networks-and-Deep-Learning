clear all
close all

a=1;
b=1;
s=0.1;
w1=(-a:s:b)';
w2=(-a:s:b)';

X2=[-5 -5; 5 5];
X4=[-5 -5; 5 5; 0 1; -1 0];
T2=[0 ; 1];
T4=[0 ; 1; 0; 1];

%**********************************
% using just the first 2 data points

figure
% subplot(3,1,1);
% make prior
for i=1:length(w1)
    for j=1:length(w2)
        w=[w1(i) w2(j)];
        prior(i,j)=(1/(2*pi))*exp(-norm(w)^2)/2;
    end
end

surf(w1,w2,prior)
grid on
box on
title('Prior')

% make posteriors
n=size(X2,1);
posterior = prior;
for k=1:n
    x=X2(k,:);
    for i=1:length(w1)
        for j=1:length(w2)
            w=[w1(i) w2(j)];
            y=1/(1+exp(-w*x'));
            likelihood=y^T2(k)*(1-y)^(1-T2(k));
            posterior(i,j)=likelihood*posterior(i,j);
        end
    end
end
figure
% subplot(3,1,2);
surf(w1,w2,posterior)
grid on
box on
title('Posterior after 2 points')

%************************
% using all 4 data points
% make prior again
for i=1:length(w1)
    for j=1:length(w2)
        w=[w1(i) w2(j)];
        prior(i,j)=(1/(2*pi))*exp(-norm(w)^2)/2;
    end
end

% make posteriors
n=size(X4,1);
posterior = prior;
for k=1:n
    x=X4(k,:);
    for i=1:length(w1)
        for j=1:length(w2)
            w=[w1(i) w2(j)];
            y=1/(1+exp(-w*x'));
            likelihood=y^T4(k)*(1-y)^(1-T4(k));
            posterior(i,j)=likelihood*posterior(i,j);
        end
    end
end
figure
% subplot(3,1,3);
surf(w1,w2,posterior)
grid on
box on
title('Posterior after all points')