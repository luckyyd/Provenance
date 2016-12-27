clear all;close all;clc;


% sigma=50;
% img = (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2)); %目标函数，高斯函数


T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
xmin = 0; dx = 5; xmax = 200; ymin = -15; dy = 2; ymax = 15;
[x,y] = meshgrid(xmin:dx:xmax,ymin:dy:ymax);
%求解
M = 20000;    %g
img = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t);
mesh(img);
hold on;
n=100;   %粒子群粒子个数

%初始化粒子群，定义结构体
%结构体中八个元素，分别是粒子坐标，粒子速度，粒子适应度，粒子最佳适应度，粒子最佳坐标
par=struct([]);
for i=1:n
    par(i).x=200*rand();        %[0 200]对x位置随机初始化
    par(i).y=-20+40*rand();     %[-20 20]对y位置随机初始化
    par(i).vx=-1+2*rand();      %[-1 1]对vx速度随机初始化
    par(i).vy=-1+2*rand();      %[-1 1]对vy速度随机初始化
    par(i).fit=0;               %粒子适应度为0初始化
    par(i).bestfit=0;           %粒子最佳适应度为0初始化
    par(i).bestx=par(i).x;      %粒子x最佳位置初始化
    par(i).besty=par(i).y;      %粒子y最佳位置初始化
end
par_best=par(1);    %初始化粒子群中最佳粒子

for k=1:100    
    plot3(par_best.x,par_best.y,par_best.fit,'k*'); %画出最佳粒子的位置，+100为相对偏移
    for p=1:n
        [par(p) par_best]=update_par(par(p),par_best);  %更新每个粒子信息         
    end  
end