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
zlabel('浓度/(mg/L)');
figure(2);
plot(t,C(:,(X-xmin)/dx+1));
grid on;
xlabel('T/s');
ylabel('浓度/(mg/L)');
disp('500m处达到稳态浓度的时刻');
[t,c]=ginput(1)
text(t,c,'*500处达到稳态浓度的时刻');
