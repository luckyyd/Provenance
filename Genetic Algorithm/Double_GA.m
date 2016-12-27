%********************************************************************�Ŵ��㷨�Ż���Ԫ����**
function[X]=Double_GA  %M����
clear all;close all;clc; %�ͷ����б������ر�ͼ�δ��ڣ���������
tic;%��ʱ����ʼ��ʱ
n=50;ger=300;pc=0.65;pm=0.05; %n��Ⱦɫ��ĸ�����ger���Ŵ��Ĵ�����pc�ǽ������  pm�Ǳ������
v=cadeia(n,44,0,0,0);   %�����˺���ĺ���������n=100��Ⱦɫ�壬ÿ��Ⱦɫ�峤��Ϊ44�����ַ���v��100X44�ľ���
v1=v(:,1:22);
v2=v(:,23:44);
[N,L]=size(v1);%N�Ǿ���v������Ϊ100��L�Ǿ���v������Ϊ44
disp(sprintf('Number of generationgs: %d',ger));
disp(sprintf('Population size: %d',N));
disp(sprintf('Crossover probability: %.3f',pc));
disp(sprintf('Mutationg probability: %.3f',pm));


% xmin=-2.048;xmax=2.048;%������Сֵ���������ֵ
% ymin=-2.048;ymax=2.048;

xmin=0;xmax=200;%������Сֵ���������ֵ
ymin=-15;ymax=15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�������Ż���������ά����ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%params
T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
M = 20000;    %g

x0=0:5:200;%���������ǻ���ά����/����ͼ������׼��
y0=-15:2:15;
[X,Y]=meshgrid(x0,y0);  %���ڵķָ�������
f1 = M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(X-ux*t).^2./(4*Dx*t)-(Y-uy*t).^2./(4*Dy*t)).*exp(-K*t);



sol=1;vmfit=[ ];it=1;vx=[ ];vy=[ ];C=[ ]; %��ʼ���ֵΪ1����Ÿ���������ֵ��������������Ÿ����������ֵ������������к�λ��
x=decode(v1,xmin,xmax);%���ú���ĺ������������룬������תʮ����
y=decode(v2,ymin,ymax);
f='M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x-ux*t).^2./(4*Dx*t)-(y-uy*t).^2./(4*Dy*t)).*exp(-K*t)';%���Ż�����
fit=eval(f);     %����ֵ  ����f��ʾ���ַ���ת����matlab������ִ��
figure(1);
mesh(X,Y,f1);%����ά����ͼ
%view(-84,21);
grid on;%������������
hold on;%ͼ�εı���
plot3(x,y,fit,'k *');%�ú�ɫ�Ǻ�����άͼ�б�ʾf��100����ʼ��
title('(a)Ⱦɫ��ĳ�ʼλ��');xlabel('x');ylabel('y');zlabel('f');%��ĿΪ������ע��������
hold off;

% General parameters & Initial operations


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   ��֤��������   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pb=0.5;pw=0.1;pr=1-(pb+pw); %���Ƹ��Ʋ���   
nb=round(pb * N);nw=round(pw * N);nr=round(pr * N);%��������ȡ��
if(nb+nw+nr)~=N,   %��֤���Ʋ�����Ⱦɫ���������ֲ���
    dif=N-(nb+nw+nr);
    nr=nr+dif;
end;
% Generations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ��ʼȺ������(ʹ������ѡ�񷽷�ѡ������)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while it <=ger     %itΪ������������С�ڵ���50ʱʵ�д�ѭ��
    [rw,ind]=sort(fit);%���� rw��fit��Ԫ�ذ���С���������ļ��ϣ�ind��rw��Ԫ����fit�е�����λ��
    ind=fliplr(ind);%�������ҷ�ת
    vtemp1=[v1(ind(1:nb),:);v1(ind(end-nw+1:end),:);v1(2:nr+1,:)];%���Ʋ�������v�а�һ��������ѡN��Ⱦɫ��浽��ʱȾɫ�弯����vtemp
    vtemp2=[v2(ind(1:nb),:);v2(ind(end-nw+1:end),:);v2(2:nr+1,:)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ���������������ɽ�������Լ������   %%%%%%%%%%%%%%%%%%%%%%%5
    C(:,1)=rand(N,1)<=pc;%pc�ǽ�����ʣ�������ɵ�50X1�����ֵ���<=0.65����ֵΪ1������C������
    C(:,2)=round(22. * rand(N,1));%round��a��ȡ��ӽ�a������
    I=find(C(:,1)==1);%IΪC�����һ��ֵΪ1��Ԫ�ص�λ��
    IP=[I,C(I,2)];%IP�Ǹ����󣬵�һ��ΪIֵ���ڶ���ΪC��I��2������C�����е�һ��ֵΪ1����Ӧ��ͬ��ֵ
    for i=1:size(IP,1),%size��IP��1����ֵΪ32����IP������32�У���C�����һ��Ϊ1������32��
        v1(IP(i,1),:)=[vtemp1(IP(i,1),1:IP(i,2)) vtemp1(1,IP(i,2)+1:end)];%vtemp�ǳ�ʼȺ�弯�ϣ��������,���ɽ���㣬��IP��i,1���е�ǰ���ֱ�������벿���ɵ�1�еĺ󲿷��滻
        v2(IP(i,1),:)=[vtemp2(IP(i,1),1:IP(i,2)) vtemp2(1,IP(i,2)+1:end)];
    end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ���������������ɱ����  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    M1=rand(N,L)<=pm;   %pm�Ǳ�����ʣ��������50X22�����ֵ�����ֵ<=0.05����ֵΪ1������M������
    M2=rand(N,L)<=pm;
    M1(1,:)=zeros(1,L);  %�����������һ�е�Ⱦɫ�岻��
    M2(1,:)=zeros(1,L); 
        v1=v1-2.*(v1.*M1)+M1;
        v2=v2-2.*(v2.*M2)+M2;
        x=decode(v1,xmin,xmax);%������תʮ���ƣ�����
        y=decode(v2,ymin,ymax);
        
        fit=eval(f);%����ֵ ����f����ʾ���ַ���ת��matlab������ִ��
        [sol,indb]=max(fit);%����it���ĺ�������ֵ����sol�indbΪsol��fit�е�λ��
        v1(1,:)=v1(indb,:);%������Ⱦɫ����ھ���v�еĵ�һ�У��ڽ����������е�һ��ʼ�ձ��ֲ���
        v2(1,:)=v2(indb,:);
        media=mean(fit);%media��fit��ƽ��ֵ
        vx=[vx sol];  %�ѵ�it��������ֵ����vx�� 
        vy=[vy sol];
        vmfit=[vmfit media];  %�ѵ�it����ƽ��ֵ����vmfit��
        it=it+1;   %��ʼ��һ�����Ŵ�
end;


disp(sprintf('Maximum found[x,y,f(x,y)]:[%.4f,%.4f,%.4f]',x(indb),y(indb),sol));
figure(2);mesh(X,Y,f1);grid on;hold on;plot3(x,y,fit,'k*');title('Ⱦɫ�������λ��');xlabel(('x'));ylabel('y');zlabel('f'); 
figure(3);plot(vx,vy);title('���ű仯����');xlabel('Generations');ylabel('f(x)');
figure(4);plot(vmfit,'r');title('ƽ��ֵ�仯����');
hold off;
runtime=toc%�����ֹ��runtimeΪ����ʱ��
% ����Ϊ���������֣�����Ϊ�ڲ�����







function[]=imprime(PRINT,vx,vy,vz,x,y,fx,it,mit);

if  PRINT==1,
    if rem(it,mit)==0
        mesh(vx,vy,vz);%����ά����ͼ
        hold on;%ͼ�α���
        axis([-2.048 2.048 -2.048 2.048 0 4000]);
        xlable('x');ylabel('y');zlabel('f(x,y)');
        polt3(x,y,fx,'k*');
        drawnow;%ˢ����Ļ
        hold off;
    end;
end;




function x=decode(v1,xmin,xmax);
v1=fliplr(v1);%��������ҷ�ת
s=size(v1);%
aux=0:1:21;aux=ones(s(1),1)*aux;
x1=sum((v1.*2.^aux)');
x=xmin+(xmax-xmin)*x1./4194303;

function y=decode(v2,ymin,ymax);
v2=fliplr(v2);%��������ҷ�ת
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

ab=2.*rand(n1,s1)-1; %rand(n1,s1)��ʾ����n1 X s1��ֵΪ0~~1��������� 
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



