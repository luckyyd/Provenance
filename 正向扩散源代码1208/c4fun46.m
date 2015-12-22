function C46=c4fun46(X,T)
C0=30;
ux=1.2;
Dx=15;
t=T*60;
dx=10;
xmin=30;
tmin=10;
dt=20;
x=xmin:dx:X;
t=tmin:dt:t;
[x,t]=meshgrid(x,t);
C=C0/2*erfc((x-ux*t)./(2*sqrt(Dx*t)))+C0/2*exp(-ux*x./Dx).*erfc((x-ux*t)./(2*sqrt(Dx*t)));
figure(1);
surfc(x,t,C);
xlabel('X/m');
ylabel('T/s');
zlabel('Ũ��/(mg/L)');
figure(2);
plot(t,C(:,(X-xmin)/dx+1));
grid on;
xlabel('T/s');
ylabel('Ũ��/(mg/L)');
disp('500m���ﵽ��̬Ũ�ȵ�ʱ��');
[t,c]=ginput(1)
text(t,c,'*500���ﵽ��̬Ũ�ȵ�ʱ��');
