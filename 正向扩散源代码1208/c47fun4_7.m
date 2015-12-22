function C47 = c47fun4_7
%调用函数观察t = 0-8min, x = 0-500m时空范围内的浓度分布
global x;   %为了和函数c4fun47传递数据，定义全局变量
T = 10 * 60;    %确定最大时间段10min
MyT = 8 * 60;   %8min时刻
MyX = 300;      %300m处
xmin = 10;
dx = 10;
xmax = 500;
tmin = 10;
dt = 10;
tmax = T;
%问题（1）的解
M1 = 200;   %瞬时源g
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 0.5;   %m/s
Dx = 1; %m2/s
B = 30; %m
H = 2.0;    %m
A = B * H;  %m2
x = xmin:dx:xmax;
t = tmin:dt:tmax;
[x,t] = meshgrid(x,t);
C471 = M1./(2*A*sqrt(pi*Dx*t)).*exp(-(x-ux*t)./(4*Dx*t)).*exp(-K*t)
figure(1);
surfc(x,t,C471);
ylabel('T/s');
xlabel('X/m');
zlabel('C/(mg/L)');
title('Fig1:瞬时源形成浓度的时空分布');
m = (MyT - tmin)/dt + 1;
n = (MyX - xmin)/dx + 1;
figure(2);
plot(x,C471(m,:),'b*');
grid on;
xlabel('X/m');
ylabel('C/(mg/L)');
title('Fig2:MyT = 8min时刻，瞬时源形成浓度空间分布');
figure(3);
plot(t,C471(:,n),'k*');
grid on;
xlabel('T/s');
ylabel('C/(mg/L)');
title('Fig3:MyX = 300m处，瞬时源形成浓度时间分布');
%问题（2）的解
ii = 0;
jj = 0;
C47((xmax - xmin)/dx + 1,(tmax - tmin)/dt+1) = 0;
for x = xmin:dx:xmax; ii = ii + 1;
        for t = tmin:dt:tmax; jj = jj + 1;
            C47(ii,jj) = quad(@c4fun47,1,t);    %对瞬时点源模型积分
        end
        jj = 0;
end
xx = xmin:dx:xmax;
tt = tmin:dt:tmax;
[TT,XX] = meshgrid(tt,xx);  %生成绘图网络
figure(4);
surfc(TT,XX,C47);
ylabel('T/s');
xlabel('X/m');
zlabel('C/(mg/L)');
title('Fig4:连续源形成浓度的时空分布');
x = xmin:dx:xmax;
t = tmin:dt:tmax;
m = (MyT-tmin)/dt + 1;
n = (MyX-xmin)/dx + 1;
figure(5);
plot(x,C47(:,m),'b-');
grid on;
xlabel('X/m');
ylabel('C/(mg/L)');
title('Fig5:MyT = 8min处，连续源形成浓度空间分布');
figure(6);
plot(t,C47(n,:),'k-');
grid on;
xlabel('T/s');
ylabel('C/(mg/L)');
title('Fig6:MyX = 300m处，连续源形成浓度时间分布');

