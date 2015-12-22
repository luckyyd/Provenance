clear
clc
hold off
psize=20;%粒子个数的设置
pd=2;%粒子的维数
lz=zeros(psize,pd);

for i=1:psize   %粒子群随机生成。psize行pd列，pd维。
%     lz(i,:)=rand(1,pd).*20-10;%【-10—10之间】
    lz(i,1)=rand()*200;
    lz(i,2)=rand()*40-20;
end
lv=lz;
lzfigure=lz;%画初始图用
goodvalue=lz;%每个粒子自己历史最好值初始化,psize行pd列
vmax=20;%速度上限
c1=2;c2=2;%学习因子
w=0.729;%随机因子和惯性因子。
ri=0;
bestvalue=zeros(1,pd);%全局最好值初始化，1行pd列
for j=1:pd
    bestvalue(1,j)=goodvalue(1,j);
end
fnew=zeros(1,psize);
for j=1:psize
    fnew(j)=fpso(lz(1,:));   
end
fold=fnew;
flagstop=0;%终止标志
k=0;%迭代次数记录
f0=fpso(bestvalue);%适应值初始化（默认）
while flagstop==0
    %***********************...1...********************************
    for i=1:psize%适应值比较，更新各自历史最好值（位置）
        fnew(i)=fpso(lz(i,:));%记录每次每个粒子的适应值，便于以后设置终止条件
        if fnew(i)<fold(i)
            fold(i)=fnew(i);%fold记录每个粒子的最好历史值
            for j=1:pd
                goodvalue(i,j)=lz(i,j);
            end
        end
    end
%**************************...2...*********************************
    for i=1:psize%每个粒子历史最好值相比较，更新全局最好值(及各维)
        f1=fold(i);
        if f1<f0
            f0=f1;
            for j=1:pd
                bestvalue(1,j)=goodvalue(i,j);
            end
        end
    end
   %*********粒子趋一点终止条件*********%
 %   flagstop0=max(abs(fold));%比较当次的所有粒子的适应值，
 %   flagstop1=min(abs(fold));%若它们之间差别较小，则可停止。
 %   if (flagstop0-flagstop1)<1
%        flagstop=1;
 %   end
 %***********************迭代次数终止条件***********
     if k>1000 %迭代次数过大，强制终止，以防陷入死循环
        flagstop=1;
    end
 %***********************
    %************************速度和位置更新*******************
     for j=1:pd
        for i=1:psize
            lv(i,j)=w.*lv(i,j)+(c1*rand(1)).*(goodvalue(i,j)-lz(i,j))...
                +(c2*rand(1)).*(bestvalue(1,j)-lz(i,j));%更新速度
            if lv(i,j)>vmax%速度最大值约束
                lv(i,j)=vmax;
            end
            lz(i,j)=lz(i,j)+lv(i,j);%更新粒子位置
        end
    end
    %********************************************************%
 %   ri=ri+1;
 %   rivalue(ri)=f0;
 %   if ri==5000
 %       ri=0;
 %       flagstop0=max(abs(rivalue));
 %       flagstop1=min(abs(rivalue));
 %       if (flagstop0-flagstop1)<0.001
 %       flagstop=1;
  %      end
%   end
    %*********************画图*************************%
    
    if k==0 %画出初始粒子的位置
        subplot(2,2,1);
        t=1:psize;
        plot(lzfigure(t,1),lzfigure(t,2),'*');
        axis([0,200,-20,20]);        
    end
    for j=2:3%分别画出迭代300次和600次粒子的位置
        if k==300*j
            subplot(2,2,j);
            t=1:psize;
           % gtext('k=600');
            plot(lz(t,1),lz(t,2),'*');
            axis([0,200,-20,20]);
        end
    end
    if flagstop==1 %画出终止时粒子的位置
        subplot(2,2,4);
        t=1:psize;
    plot(lz(t,1),lz(t,2),'*');
    axis([0,200,-20,20]);
    end
%***********************************************************%
    k=k+1;
end
fprintf('总迭代次数：k=%ld。\n',k-1);
fprintf('每个粒子的历史最好值：\n');
for i=1:psize
    fprintf('粒子%d： [%6.4f,%6.4f]\n',i,goodvalue(i,1),goodvalue(i,2));
end
fprintf('全局最好值：[%6.4f,%6.4f].\n',bestvalue(1,1),bestvalue(1,2));
fprintf('最优解(最大值)：%6.4f.\n',fpso(bestvalue(1,:)));
for j=1:20
    fprintf('粒子%d位置：',j) ;  
    fprintf('x=%6.4f，y=%6.4f',lz(j,1),lz(j,2));
   fprintf('\n') ;
end
