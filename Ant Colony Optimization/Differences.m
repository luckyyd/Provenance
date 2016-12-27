function C48 = Differences()
%调用函数时，输入不同时刻的T（min），观察下游污染物的空间分布图
%从t=0.5~t=5.5



K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.25; %m/s
Dx = 25; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
xmin = 0; dx = 5; xmax = 500; ymin = -50; dy = 2; ymax = 50;
Difference = 0;

for(T=0.5:0.25:5.5)

    t = T * 60; %s

    M0 = 18910.81164;
    x0 = 86.67316695;
    y0 = 24.27566624;

    M = 20000;
    x = 100;
    y = 0;

    Estimate = M0./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x0-ux*t).^2./(4*Dx*t)-(y0-uy*t).^2./(4*Dy*t)).*exp(-K*t);

    Observation = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t);

    Difference = Difference +  (Estimate - Observation)^2;

end

Difference

% 
% figure(1);
% surf(x,y,C481);
% xlabel('X/m'); 
% ylabel('Y/m');
% title('Figure1:空间分布');
