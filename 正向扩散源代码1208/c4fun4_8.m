function C48 = c4fun4_8()
%调用函数时，输入不同时刻的T（min），观察下游污染物的空间分布图
%从t=0.5~t=5.5

% T=0.5
% for(i=1:1:21)
    T=0.5
    t = T * 60; %s
    K = 4.2 / (24 * 60 * 60);   %s-1
    ux = 1.5; uy = 0.25; %m/s
    Dx = 25; Dy = 10;   %m2/s
    B = 30; H = 2.0;    %m
    xmin = 0; dx = 5; xmax = 500; ymin = -50; dy = 2; ymax = 50;
    %求解
    M = 20000;    %g
    [x,y] = meshgrid(xmin:dx:xmax,ymin:dy:ymax);
    C481 = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t);

%     %列号，行号
%     location1 = C481(25,20);
%     location2 = C481(15,20);
%     location3 = C481(35,20);
% 
%     location4 = C481(25,40);
%     location5 = C481(15,40);
%     location6 = C481(35,40);
% 
%     location7 = C481(25,60);
%     location8 = C481(15,60);
%     location9 = C481(35,60);
%     data(i,:) = [location1,location2,location3,location4,location5,location6,location7,location8,location9];
%     T = T + 0.25;
% end
% data = [location1,location2,location3,location4,location5,location6,location7,location8,location9]
% m=21;
% n=9;
% p=100;
% s = wgn(m,n,p)

s = (rand(21,9)./2.5)+0.8;


figure(1);
surf(x,y,C481);
xlabel('X/m'); 
ylabel('Y/m');
title('Figure1:空间分布');
