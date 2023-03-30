clc
clear
close all


%% Get Inputs
% n = input('Enter the number of control points: ');
% fprintf('\nNote: The order in which the points are inserted is crucial!\n\n');
% 
% for i = 1:n
%     fprintf('Enter details for point(%d):\n',i);
%     P(1,i) = input('Enter the x coordinate: '); %x coordinate
%     P(2,i) = input('Enter the y coordinate: '); %y coordinate
%     P(3,i) = 0;                                 %all points in xy plane
%     fprintf('\n');
% end



%% Radial basis function neural network
n = 6
P = [1 2.6442 1.1935 6.8065 5.3558 7.5;
    1 1 1 3.1 3.1 3.1
    0 0 0 0 0 0];

[x,t] = bezier(P,n);

trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network
hiddenLayerSize = 5;
TF = {'radbas'};
net = newff(x,t,hiddenLayerSize,TF);

net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

net.performFcn = 'mse';  % Mean Squared Error

net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

%% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, ploterrhist(e)
figure, plotregression(t,y)
figure, plotfit(net,x,t)

% Deployment
if (false)
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    gensim(net);
end



%% Plot trained net for rectangular shape
figure
X = 1:0.1:7.5;
N = net(X);
D = diff(N)./diff(X);
t = atan(D);
a1 =1.5;
a2 = 0.5;
b = 0.5;
for i = 1:65
    x = X(i);
    N = net(x);
    plot(x,net(x),'.r','MarkerSize',15)
    hold on
    l = line([x-a2 x-a2 x+a1 x+a1 x-a2],[N-b N+b N+b N-b N-b],'LineWidth',0.7);
    rotate(l,[0 0 1],t(i)*180/pi,[x,y,0]);
    axis equal
    hold on
end



%% bezier curve
function [x,y] = bezier(P,n)
count = 1;
div = 100; %number of segments of the curve
for u = 0:(1/div):1
    sum = [0 0 0]';
    for i = 1:n
        B = nchoosek(n,i-1)*(u^(i-1))*((1-u)^(n-i+1)); %B is the Bernstein polynomial value
        sum = sum + B*P(:,i);
    end
    B = nchoosek(n,n)*(u^(n));
    sum = sum + B*P(:,n);
    A(:,count) = sum; %the matrix containing the points of curve as column vectors.
    count = count+1;  % count is the index of the points on the curve.
end

for j = 1:n %plots the points
    plot(P(1,j),P(2,j),'*r');
    hold on;
end
p1 = P(:,1);

%draws the characteristic polygon describing the bezier curve
for l = 1:n-1
    p2 = P(:,l+1)';
    lineplot(p1,p2); %function the plots a line between two points.
    p1 = p2;
end
%plotting the curve
x = A(1,:);
y = A(2,:);
plot(x,y);
axis equal;
end

%%
%function definitions
function [] = lineplot(A,B)
x = [A(1) B(1)];
y = [A(2) B(2)];
plot(x,y,'--r'); %a dashed red  line
end