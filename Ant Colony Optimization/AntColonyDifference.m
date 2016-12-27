function [maxX,maxY,maxValue]=AntColonyDifference
%%初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ant=200;  %蚂蚁数量
Ant=9;
Times=30000;  %蚂蚁移动次数
Rou=0.8;  %信息素挥发系数
P0=0.2;  %转移概率常数
%设置搜索范围
Lower_1=-10000;  %设置搜索范围
Upper_1=10000;
Lower_2=-100;
Upper_2=100;
Lower_3=-100;
Upper_3=100;

%初始参数
% T = 0.5;
% t = T * 50; %s
% K = 4.2 / (24 * 60 * 60);   %s-1
% ux = 1.5; uy = 0.25; %m/s
% Dx = 25; Dy = 10;   %m2/s
% B = 30; H = 2.0;    %m
% M = 20000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:Ant
    X(:,1)=[1089.188358 8703.754027 -3773.570781 -2700.082476 8398.511178 255.8944071 5299.650792 6129.349066 -2539.797316 ]';
    X(:,2)=[13.32683305 4.244291516 13.01774559 41.58031476 16.72520815 10.29353367 23.66531601 42.61018924 4.510543413 ]';
    X(:,3)=[-24.27566624 -42.12266291 -11.12330149 -69.55323081 -65.52184697 -15.5264675 -63.88936869 -11.4984602 12.5192916]';
%     Tau()=F(X(:,1),X(:,2),X(:,3));
    for i=1:Ant
        Tau(i)=F(X(i,1),X(i,2),X(i,3));
    end
% end
 
step=0.05;
% f='-(x.^4+2*y.^4-0.3*cos(3*pi*x)-0.4*cos(4*pi*y)+0.7)';
% f = 'M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t)';
 
% [x,y]=meshgrid(Lower_1:step:Upper_1,Lower_2:step:Upper_2);
% z=eval(f);
% figure(1);
% mesh(x,y,z);
% hold on;
% plot3(X(:,1),X(:,2),Tau,'k*')
% hold on;
% text(0.1,0.8,-0.1,'蚂蚁的初始分布位置');
% xlabel('x');ylabel('y');zlabel('f(x,y)');
 
for T=1:Times
    lamda=1/T;
    [Tau_Best(T),BestIndex]=max(Tau);
    for i=1:Ant
        P(T,i)=(Tau(BestIndex)-Tau(i))/Tau(BestIndex);  %计算状态转移概率
    end
    for i=1:Ant
        if P(T,i)<P0  %局部搜索
            temp1=X(i,1)+(2*rand-1)*lamda;
            temp2=X(i,2)+(2*rand-1)*lamda;
            temp3=X(i,3)+(2*rand-1)*lamda;
        else  %全局搜索
            temp1=X(i,1)+(Upper_1-Lower_1)*(rand-0.5);
            temp2=X(i,2)+(Upper_2-Lower_2)*(rand-0.5);
            temp3=X(i,3)+(Upper_3-Lower_3)*(rand-0.5);
        end
        
        %越界处理
        if temp1<Lower_1
            temp1=Lower_1;
        end
        if temp1>Upper_1
            temp1=Upper_1;
        end
        if temp2<Lower_2
            temp2=Lower_2;
        end
        if temp2>Upper_2
            temp2=Upper_2;
        end
        if temp3<Lower_3
            temp3=Lower_3;
        end
        if temp3>Upper_3
            temp3=Upper_3;
        end
        
        %%%
        if F(temp1,temp2,temp3)>F(X(i,1),X(i,2),X(i,3))  %判断蚂蚁是否移动
            X(i,1)=temp1;
            X(i,2)=temp2;
            X(i,3)=temp3;
        end
    end
    for i=1:Ant
        Tau(i)=(1-Rou)*Tau(i)+F(X(i,1),X(i,2),X(i,3));  %更新信息量
    end
end
 
% figure(2);
% mesh(x,y,z);
% hold on;
% x=X(:,1);
% y=X(:,2);
% plot3(x,y,eval(f),'k*');
% hold on;
% text(0.1,0.8,-0.1,'蚂蚁的最终分布位置');
% xlabel('x');ylabel('y');zlabel('f(x,y)');
 
[max_value,max_index]=max(Tau);
%污染源的位置
maxX=X(max_index,1);
maxY=X(max_index,2);
maxZ=X(max_index,3);
maxValue=F(X(max_index,1),X(max_index,2),X(max_index,3));
%求得污染物的质量，坐标
maxX
maxY
maxZ
maxValue
%目标函数
% function [F]=F(x1,x2)  
% F=-(x1.^4+2*x2.^4-0.3*cos(3*pi*x1)-0.4*cos(4*pi*x2)+0.7);

function [F]=F(M1,x1,y1)

% T = 0.5;
% t = T * 50; %s
% M = 20000;

K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.25; %m/s
Dx = 25; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m

% F = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t);

Sample_x=[100,100,100,200,200,200,300,300,300];
Sample_y=[0,-20,20,0,-20,20,0,-20,20];
Sample_z=[20000,20000,20000,20000,20000,20000,20000,20000,20000];

Difference = 0;

for(i=1:1:9)
    
    M0 = Sample_z(i);
    x0 = Sample_x(i);
    y0 = Sample_y(i);
    
    for(T=0.5:0.25:5.5)
        
        t = T * 60; %s
        
        Observation = M0./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x0-ux*t).^2./(4*Dx*t)-(y0-uy*t).^2./(4*Dy*t)).*exp(-K*t);
        
        Estimate = (M0-M1)./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-((x0-x1)-ux*t).^2./(4*Dx*t)-((y0-y1)-uy*t).^2./(4*Dy*t)).*exp(-K*t);
        
        Difference = Difference + (Estimate - Observation)^2;
        
    end
    
end

F = -Difference;



