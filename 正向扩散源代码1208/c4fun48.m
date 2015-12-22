function C = c4fun48(t)
global xx yy;   %为保证向c4fun48传递数据，定义全局变量xx,yy
C0 = 6.66;  %g/m3
Q = 30; %m3/s
K = 4.2/(24 * 60 * 60); %s-1
ux = 1.5;
uy = 0.0;   %m/s
Dx = 50;
Dy = 10;    %m2/s
H = 2;  %m
C = C0 * Q./(4*pi*t*H*sqrt(Dx*Dy)).*exp(-(xx-ux*t).^2./(4*Dx*t)-(yy-uy*t).^2./(4*Dy*t)).*exp(-K*t);