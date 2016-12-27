function [P]=P(x,y)

T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
M = 20000;
F = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t);
