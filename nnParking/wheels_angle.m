clc
clear
close all

%% Inputs
F2 = input('Enter F2: ');
l = input('Enter l: ');
hold on

%% Wheels angle
d1 = [1:40]*pi/180;
d2 = acot(cot(d1)+F2/l); % eq(2)

%% plot
d = acot((cot(d1)+cot(d2))/2);  % eq(3)
plot(d1*180/pi,d*180/pi,'b','LineWidth',2)

d = (d1+d2)/2;  %eq(4)
plot(d1*180/pi,d*180/pi,'--r','LineWidth',2)

legend('equivalent angle at the center of vehical axle',...
    'average value of two front wheel angles');
xlabel('Left front wheel angle {\delta_{1}}^\circ');
ylabel('Angle \delta^\circ');