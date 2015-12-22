function C472 = c4fun47(t)
global x;   %为了和函数c4fun4_7()传递数据，定义全局变量
M2 = 200;   %g/s
K = 4.2/(24 * 60 * 60); %s-1
ux = 0.5;   %m/s
Dx = 1.0;   %m2/s
B = 30; %m
H = 2.0;    %m
A = B * H;  %m2
C472 = M2./(2*A.*t.*sqrt(pi*Dx*t)).*exp(-(x-ux*t)./(4*Dx*t)).*exp(-K*t);