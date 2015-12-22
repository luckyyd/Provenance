function [maxX,maxY,maxValue]=AntColony
%%初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ant=200;  %蚂蚁数量
Times=300;  %蚂蚁移动次数
Rou=0.8;  %信息素挥发系数
P0=0.2;  %转移概率常数
% Lower_1=-1;  %设置搜索范围
% Upper_1=1;
% Lower_2=-1;
% Upper_2=1;
Lower_1=0;  %设置搜索范围
Upper_1=200;
Lower_2=-20;
Upper_2=20;

%初始参数
T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
M = 20000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:Ant
    X(i,1)=(Lower_1+(Upper_1-Lower_1)*rand);  %随机设置蚂蚁的初值位置
    X(i,2)=(Lower_2+(Upper_2-Lower_2)*rand);
    Tau(i)=F(X(i,1),X(i,2));
end
 
step=0.05;
% f='-(x.^4+2*y.^4-0.3*cos(3*pi*x)-0.4*cos(4*pi*y)+0.7)';
f = 'M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t)';
 
[x,y]=meshgrid(Lower_1:step:Upper_1,Lower_2:step:Upper_2);
z=eval(f);
figure(1);
mesh(x,y,z);
hold on;
plot3(X(:,1),X(:,2),Tau,'k*')
hold on;
text(0.1,0.8,-0.1,'蚂蚁的初始分布位置');
xlabel('x');ylabel('y');zlabel('f(x,y)');
 
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
        else  %全局搜索
            temp1=X(i,1)+(Upper_1-Lower_1)*(rand-0.5);
            temp2=X(i,2)+(Upper_2-Lower_2)*(rand-0.5);
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
        
        %%%
        if F(temp1,temp2)>F(X(i,1),X(i,2))  %判断蚂蚁是否移动
            X(i,1)=temp1;
            X(i,2)=temp2;
        end
    end
    for i=1:Ant
        Tau(i)=(1-Rou)*Tau(i)+F(X(i,1),X(i,2));  %更新信息量
    end
end
 
figure(2);
mesh(x,y,z);
hold on;
x=X(:,1);
y=X(:,2);
plot3(x,y,eval(f),'k*');
hold on;
text(0.1,0.8,-0.1,'蚂蚁的最终分布位置');
xlabel('x');ylabel('y');zlabel('f(x,y)');
 
[max_value,max_index]=max(Tau);
%污染源的位置
maxX=X(max_index,1);
maxY=X(max_index,2);
maxValue=F(X(max_index,1),X(max_index,2));
%目标函数
% function [F]=F(x1,x2)  
% F=-(x1.^4+2*x2.^4-0.3*cos(3*pi*x1)-0.4*cos(4*pi*x2)+0.7);

function [F]=F(x,y)

T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
M = 20000;
F = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t);







