%********************************************************************遗传算法优化二元函数**
function[X]=Double_GA  %M函数
clear all;close all;clc; %释放所有变量，关闭图形窗口，清除命令窗口
tic;%计时器开始计时
n=50;ger=300;pc=0.65;pm=0.05; %n是染色体的个数，ger是遗传的代数，pc是交叉概率  pm是变异概率
v=cadeia(n,44,0,0,0);   %调用了后面的函数，产生n=100个染色体，每个染色体长度为44进制字符，v是100X44的矩阵
v1=v(:,1:22);
v2=v(:,23:44);
[N,L]=size(v1);%N是矩阵v的行数为100，L是矩阵v的列数为44
disp(sprintf('Number of generationgs: %d',ger));
disp(sprintf('Population size: %d',N));
disp(sprintf('Crossover probability: %.3f',pc));
disp(sprintf('Mutationg probability: %.3f',pm));


% xmin=-2.048;xmax=2.048;%参数最小值，参数最大值
% ymin=-2.048;ymax=2.048;

xmin=0;xmax=200;%参数最小值，参数最大值
ymin=-15;ymax=15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画出待优化函数的三维网线图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%params
T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
M = 20000;    %g

x0=0:5:200;%以下四行是画三维曲面/网线图的数据准备
y0=-15:2:15;
[X,Y]=meshgrid(x0,y0);  %用于的分格线坐标
f1 = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(X-ux*t).^2./(4*Dx*t)-(Y-uy*t).^2./(4*Dy*t)).*exp(-K*t);



sol=1;vmfit=[ ];it=1;vx=[ ];vy=[ ];C=[ ]; %初始最大值为1，存放各代函数均值，迭代变量，存放各代函数最大值，交叉操作的行和位置
x=decode(v1,xmin,xmax);%调用后面的函数，参数编码，二进制转十进制
y=decode(v2,ymin,ymax);
f='M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t)';%待优化函数
fit=eval(f);     %求函数值  即将f表示的字符串转换成matlab命令来执行
figure(1);
mesh(X,Y,f1);%画三维网线图
%view(-84,21);
grid on;%画坐标网格线
hold on;%图形的保持
plot3(x,y,fit,'k *');%用黑色星号在三维图中表示f的100个初始解
title('(a)染色体的初始位置');xlabel('x');ylabel('y');zlabel('f');%题目为‘’标注横纵坐标
hold off;

% General parameters & Initial operations


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   保证总数不变   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pb=0.5;pw=0.1;pr=1-(pb+pw); %控制复制操作   
nb=round(pb * N);nw=round(pw * N);nr=round(pr * N);%四舍五入取整
if(nb+nw+nr)~=N,   %保证复制操作后染色体总数保持不变
    dif=N-(nb+nw+nr);
    nr=nr+dif;
end;
% Generations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  初始群体生成(使用排序选择方法选择算子)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while it <=ger     %it为迭代变量，当小于等于50时实行此循环
    [rw,ind]=sort(fit);%排序 rw是fit中元素按从小到大排序后的集合，ind是rw中元素在fit中的坐标位置
    ind=fliplr(ind);%矩阵左右翻转
    vtemp1=[v1(ind(1:nb),:);v1(ind(end-nw+1:end),:);v1(2:nr+1,:)];%复制操作，从v中按一定规则挑选N个染色体存到临时染色体集合里vtemp
    vtemp2=[v2(ind(1:nb),:);v2(ind(end-nw+1:end),:);v2(2:nr+1,:)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  交叉操作，随机生成交叉的行以及交叉点   %%%%%%%%%%%%%%%%%%%%%%%5
    C(:,1)=rand(N,1)<=pc;%pc是交叉概率，随机生成的50X1矩阵的值如果<=0.65，则赋值为1，放在C矩阵中
    C(:,2)=round(22. * rand(N,1));%round（a）取最接近a的整数
    I=find(C(:,1)==1);%I为C矩阵第一列值为1的元素的位置
    IP=[I,C(I,2)];%IP是个矩阵，第一列为I值，第二列为C（I，2），即C矩阵中第一列值为1所对应的同行值
    for i=1:size(IP,1),%size（IP，1）的值为32，即IP矩阵有32行，即C矩阵第一列为1的数有32个
        v1(IP(i,1),:)=[vtemp1(IP(i,1),1:IP(i,2)) vtemp1(1,IP(i,2)+1:end)];%vtemp是初始群体集合，交叉操作,生成交叉点，第IP（i,1）行的前部分保留，后半部分由第1行的后部分替换
        v2(IP(i,1),:)=[vtemp2(IP(i,1),1:IP(i,2)) vtemp2(1,IP(i,2)+1:end)];
    end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  变异操作，随机生成变异点  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    M1=rand(N,L)<=pm;   %pm是变异概率，随机生成50X22矩阵的值，如果值<=0.05，则赋值为1，放在M矩阵中
    M2=rand(N,L)<=pm;
    M1(1,:)=zeros(1,L);  %变异操作，第一行的染色体不变
    M2(1,:)=zeros(1,L); 
        v1=v1-2.*(v1.*M1)+M1;
        v2=v2-2.*(v2.*M2)+M2;
        x=decode(v1,xmin,xmax);%二进制转十进制，解码
        y=decode(v2,ymin,ymax);
        
        fit=eval(f);%求函数值 即将f所表示的字符串转成matlab命令来执行
        [sol,indb]=max(fit);%将第it代的函数最优值放在sol里，indb为sol在fit中的位置
        v1(1,:)=v1(indb,:);%把最优染色体放在矩阵v中的第一行，在交叉变异过程中第一行始终保持不变
        v2(1,:)=v2(indb,:);
        media=mean(fit);%media是fit的平均值
        vx=[vx sol];  %把第it代的最优值放在vx中 
        vy=[vy sol];
        vmfit=[vmfit media];  %把第it代的平均值放在vmfit中
        it=it+1;   %开始下一代的遗传
end;


disp(sprintf('Maximum found[x,y,f(x,y)]:[%.4f,%.4f,%.4f]',x(indb),y(indb),sol));
figure(2);mesh(X,Y,f1);grid on;hold on;plot3(x,y,fit,'k*');title('染色体的最终位置');xlabel(('x'));ylabel('y');zlabel('f'); 
figure(3);plot(vx,vy);title('最优变化趋势');xlabel('Generations');ylabel('f(x)');
figure(4);plot(vmfit,'r');title('平均值变化趋势');
hold off;
runtime=toc%秒表终止，runtime为运行时间
% 上面为主函数部分，下面为内部函数







function[]=imprime(PRINT,vx,vy,vz,x,y,fx,it,mit);

if  PRINT==1,
    if rem(it,mit)==0
        mesh(vx,vy,vz);%画三维网线图
        hold on;%图形保持
        axis([-2.048 2.048 -2.048 2.048 0 4000]);
        xlable('x');ylabel('y');zlabel('f(x,y)');
        polt3(x,y,fx,'k*');
        drawnow;%刷新屏幕
        hold off;
    end;
end;




function x=decode(v1,xmin,xmax);
v1=fliplr(v1);%矩阵的左右翻转
s=size(v1);%
aux=0:1:21;aux=ones(s(1),1)*aux;
x1=sum((v1.*2.^aux)');
x=xmin+(xmax-xmin)*x1./4194303;

function y=decode(v2,ymin,ymax);
v2=fliplr(v2);%矩阵的左右翻转
s=size(v2);%
aux=0:1:21;aux=ones(s(1),1)*aux;
y1=sum((v2.*2.^aux)');
y=ymin+(ymax-ymin)*y1./4194303;



function[ab,ag]=cadeia(n1,s1,n2,s2,bip)
if nargin==2  
    n2=n1;s2=s1;bip=1; 
  elseif nargin==4, 
    bip=1;  
end;

ab=2.*rand(n1,s1)-1; %rand(n1,s1)表示生成n1 X s1的值为0~~1的任意矩阵 
if bip==1,
    ab=hardlims(ab);
else;
    ab=hardlim(ab);
end;

ag=2.*rand(n2,s2)-1;
if bip==1,
    ag=hardlims(ag);
else;
    ag=hardlim(ag);
end;



