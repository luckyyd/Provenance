%人工智能AI 二维粒子群算法
function GoodPSO
% P--粒子位置数组
% V--粒子速度数组
% W--惯性因子横向量
% F--适应度值列向量
% B--每代最优值列向量
% G--前t代全局最优值位置
% FB--每代最优值列向量
% c1--局部加速因子
% c2--全局加速因子
% pnum--粒子数目
% dnum--自变量维数
% tnum--迭代次数(代数)
% xymin--自变量下限
% xymax--自变量上限
% gBest--每代所有粒子全局最优值位置
% pBest--前t代每个粒子局部最优值位置
% fBest--前t代最优值列向量
% maxfit--最大适应度值
% Meanfit--每代平均适应度值数组
% Newfit--新平均适应度值数组
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
close all
c1=2;
c2=2;
wmin=0;
wmax=0.9;
pnum=50;
dnum=1;
tnum=200;
xmin=0;
xmax=9;
step=0.05;
for t=1:tnum
    W(t)=wmax-((wmax-wmin)/tnum)*t;
end
TF='X+10*sin(X.*5)+7*cos(X.*4)'; %目标函数
Meanfit=[];
P=[];
P=xmin+(xmax-xmin)*rand(pnum,dnum,1); %随机生成第一代所有粒子位置%1表示第一代
V=wmin+(wmax-wmin)*rand(pnum,dnum,1); %随机生成第一代所有粒子速度数组%1表示第一代
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:pnum
    %求第一代所有粒子的适应度值
    F(i,1,1)=TargetFun(P(i,1,1));
end
newfit=mean(F(:,1,1));
Meanfit=[Meanfit newfit];
%求第一代所有粒子适应度值的最大值(函数最大值)及最大值对应的位置
[maxfit,k]=max(F(:,1,1));
B(1,1,1)=maxfit;%将第一代适应度值的最大值存储到列向量B中
%第一代的最大值也就是目前整个种群找到的最优解%这个极值是全局极值G
G(1,1,1)=P(k,1,1);
for p=1:pnum
    %整个种群目前找到的最优解%这个极值是全局极值G
    gBest(p,1,1)=G(1,1,1);
end
%把前1代的最优值保存列向量fBest中
fBest(1,1,1)=TargetFun(gBest(1,1,1));
for i=1:pnum
    %第一代每个粒子本身所找到的最优解位置(即第一代粒子本身)%这个解叫做个体极值pBest
    pBest(i,:,1)=P(i,:,1);
end
%计算第一代粒子中目标函数的最优值
FB(1,1,1)=TargetFun(G(1,1,1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%从第二代开始迭代
for t=2:tnum
    V(:,1,t)=W(t-1)*V(:,1,t-1)+c1*rand*(pBest(:,1,t-1)-P(:,1,t-1))+c2*rand*(gBest(:,1,t-1)-P(:,1,t-1));
    P(:,1,t)=P(:,1,t-1)+V(:,1,t);
    for i=1:pnum
        if P(i,1,t)<xmin
            P(i,1,t)=xmin;
        end
        if P(i,1,t)>xmax
            P(i,1,t)=xmax;
        end
    end
    for i=1:pnum
        %求第t代所有粒子的适应度值
        F(i,1,t)=TargetFun(P(i,1,t));
    end
    Newfit=mean(F(:,1,t));
    Meanfit=[Meanfit Newfit];
    %求第t代所有粒子适应度值的最大值(函数最大值)及最大值对应的位置
    [maxfit,k]=max(F(:,:,t));
    B(1,1,t)=maxfit; %将第t代适应度值的最大值存储到列向量B中
    %假设第t代最优值的坐标(参数)是全局最优值的坐标并保存在数组G中
    G(1,1,t)=P(k,1,t);
    %将第t代最优函数值保存到列向量FB中
    FB(1,1,t)=TargetFun(G(1,1,t));
    %求前t代的最优值及最优值的位置
    [maxfit,k]=max(FB(1,1,:));
    if maxfit>FB(1,1,t)
        G(1,1,t)=P(1,1,k);
    end
    for p=1:pnum
        %第t代所有粒子的全局最优位置调整
        gBest(p,1,t)=G(1,1,t);
    end
    %求前t代的最优值
    fBest(1,1,t)=TargetFun(gBest(1,1,t));
    %对第t代所有粒子的局部最优位置调整
    for i=1;pnum
        %第i个粒子的前t代最优值定位
        [maxfit,k]=max(F(i,1,:));
        if F(i,1,t)>=maxfit
            pBest(i,1,t)=P(i,1,t);
        else
            pBest(i,1,t)=P(i,1,k);
        end
    end
end
Gend=G(1,:,tnum) %粒子的最优值位置(即最优函数值位置)
fend=fBest(1,1,tnum) %最优值(即最优函数值)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
figure(1)
fplot(TF,[xmin,xmax])
grid on
hold on
%标记初始蚂蚁的位置%
scatter(P(:,1,1),F(:,1,1),'k*')
xlabel('x')
ylabel('y')
title('粒子的初始位置')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
fplot(TF,[xmin,xmax])
grid on
hold on
plot(P(:,1,tnum),F(:,1,tnum),'r*')
grid on 
xlabel('x')
ylabel('y')
title('粒子最终分布位置')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
t=1:tnum;
fBestt(t)=fBest(1,1,t);
plot(t,fBestt)
hold on
plot(Meanfit,'r')
hold off
xlabel('迭代次数')
ylabel('函数值')
title('最优及平均函数值变化趋势')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TF=TargetFun(X)
TF=X+10*sin(X.*5)+7*cos(X.*4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

