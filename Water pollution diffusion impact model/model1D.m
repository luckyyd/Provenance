function result = model1D
%���ú����۲�t = 0-8min, x = 0-500mʱ�շ�Χ�ڵ�Ũ�ȷֲ�
global x;   %Ϊ�˺ͺ���c4fun47�������ݣ�����ȫ�ֱ���
T = 10 * 60;    %ȷ�����ʱ���10min
MyT = 8 * 60;   %8minʱ��
MyX = 300;      %300m��
xmin = 10;
dx = 10;
xmax = 500;
tmin = 10;
dt = 10;
tmax = T;
%���⣨1���Ľ�
M1 = 200;   %˲ʱԴg
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
title('Fig1:Spatial and temporal distribution of instantaneous source ');
m = (MyT - tmin)/dt + 1;
n = (MyX - xmin)/dx + 1;
figure(2);
plot(x,C471(m,:),'b*');
grid on;
xlabel('X/m');
ylabel('C/(mg/L)');
title('Fig2:Space distribution of instantaneous source on MyT = 8min');
figure(3);
plot(t,C471(:,n),'k*');
grid on;
xlabel('T/s');
ylabel('C/(mg/L)');
title('Fig3:Temporal distribution of instantaneous source on MyX = 300m');
%���⣨2���Ľ�
ii = 0;
jj = 0;
result((xmax - xmin)/dx + 1,(tmax - tmin)/dt+1) = 0;
for x = xmin:dx:xmax; ii = ii + 1;
        for t = tmin:dt:tmax; jj = jj + 1;
            result(ii,jj) = quad(@c4fun47,1,t);    %��˲ʱ��Դģ�ͻ���
        end
        jj = 0;
end
xx = xmin:dx:xmax;
tt = tmin:dt:tmax;
[TT,XX] = meshgrid(tt,xx);  %���ɻ�ͼ����
figure(4);
surfc(TT,XX,result);
ylabel('T/s');
xlabel('X/m');
zlabel('C/(mg/L)');
title('Fig4:The spatial and temporal distribution of continuous source');
x = xmin:dx:xmax;
t = tmin:dt:tmax;
m = (MyT-tmin)/dt + 1;
n = (MyX-xmin)/dx + 1;
figure(5);
plot(x,result(:,m),'b-');
grid on;
xlabel('X/m');
ylabel('C/(mg/L)');
title('Fig5:Space distribution of continuous source on MyT = 8min');
figure(6);
plot(t,result(n,:),'k-');
grid on;
xlabel('T/s');
ylabel('C/(mg/L)');
title('Fig6: Temporal distribution of instantaneous source on MyX = 300m');

