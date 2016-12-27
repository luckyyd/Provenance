clear all;close all;clc;


% sigma=50;
% img = (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2)); %Ŀ�꺯������˹����


T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
xmin = 0; dx = 5; xmax = 200; ymin = -15; dy = 2; ymax = 15;
[x,y] = meshgrid(xmin:dx:xmax,ymin:dy:ymax);
%���
M = 20000;    %g
img = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t);
mesh(img);
hold on;
n=100;   %����Ⱥ���Ӹ���

%��ʼ������Ⱥ������ṹ��
%�ṹ���а˸�Ԫ�أ��ֱ����������꣬�����ٶȣ�������Ӧ�ȣ����������Ӧ�ȣ������������
par=struct([]);
for i=1:n
    par(i).x=200*rand();        %[0 200]��xλ�������ʼ��
    par(i).y=-20+40*rand();     %[-20 20]��yλ�������ʼ��
    par(i).vx=-1+2*rand();      %[-1 1]��vx�ٶ������ʼ��
    par(i).vy=-1+2*rand();      %[-1 1]��vy�ٶ������ʼ��
    par(i).fit=0;               %������Ӧ��Ϊ0��ʼ��
    par(i).bestfit=0;           %���������Ӧ��Ϊ0��ʼ��
    par(i).bestx=par(i).x;      %����x���λ�ó�ʼ��
    par(i).besty=par(i).y;      %����y���λ�ó�ʼ��
end
par_best=par(1);    %��ʼ������Ⱥ���������

for k=1:100    
    plot3(par_best.x,par_best.y,par_best.fit,'k*'); %����������ӵ�λ�ã�+100Ϊ���ƫ��
    for p=1:n
        [par(p) par_best]=update_par(par(p),par_best);  %����ÿ��������Ϣ         
    end  
end