%A script to test if 2d Hopfield network can recognize letter of alphabet



function [] = hopdigit_v2(noiselevel,num_iter)

% close all

load digits; clear size
[N, dim]=size(X);
maxx=max(max(X));

%Values must be +1 or -1
X(X==0)=-1;
%-------------------------------------------------------------------------

%Attractors of the Hopfield network

zero = X(1,:); %to visualize: digit=reshape(X(1,:),15, 16)'; -> imshow(digit); 
one = X(21,:);
two = X(41,:);
three = X(61,:);
four = X(81,:);
five = X(101,:);
six = X(121,:);
seven = X(141,:);
eight = X(161,:);
nine = X(181,:);

index_dig = [1,21,41,61,81,101,121,141,161,181];
num_dig = 10;
%--------------------------------------------------------------------------

T = [zero;one;two;three;four;five;six;seven;eight;nine]';

%Create network
net = newhop(T);

%Check if digits are attractors
[Y,~,~] = sim(net,num_dig,[],T);
Y = Y';

figure;

subplot(num_dig,3,1);

for i = 1:num_dig
digit = Y(i,:);
digit = reshape(digit,15,16)'; 

subplot(num_dig,3,((i-1)*3)+1);
imshow(digit)
if i == 1
    title('Attractors')
end
hold on
end


%The plots show that they are attractors.

%------------------------------------------------------------------------



% Add noise to the digit maps

noise = noiselevel*maxx; % sd for Gaussian noise

Xn = X; 
for i=1:N;
  Xn(i,:) = X(i,:) + noise*randn(1, dim);
end

%Show noisy digits:

subplot(num_dig,3,2);

for i = 1:num_dig
digit = Xn(index_dig(i),:);
%digit=X(index_dig(i),:); digit(digit==-1)=0; digit(digit==1)=-1; digit(digit==0)=1;
digit = reshape(digit,15,16)';
subplot(num_dig,3,((i-1)*3)+2);
imshow(digit)
if i == 1
    title('Noisy digits')
end
hold on
end
% digit1=X(index_dig(i),:);digit2=X(index_dig(i-1),:);digit=(digit1+digit2)/2;
% digit = reshape(digit,15,16)';
% subplot(num_dig,3,((i-1)*3)+2);
% imshow(digit)
%------------------------------------------------------------------------

%See if the network can correct the corrupted digits 


num_steps = num_iter;

Xn = Xn';
Tn = {Xn(:,index_dig)};
[Yn,~,~] = sim(net,{num_dig num_steps},{},Tn);
Yn = Yn{1,num_steps};
Yn = Yn';

subplot(num_dig,3,3);

for i = 1:num_dig
digit = Yn(i,:);
digit = reshape(digit,15,16)';
subplot(num_dig,3,((i-1)*3)+3);
imshow(digit)
if i == 1
    title('Reconstructed noisy digits')
end
hold on
end


%-----------------------------------------------------------------------

