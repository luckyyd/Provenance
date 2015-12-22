clear
clc
hold off
psize=20;%���Ӹ���������
pd=2;%���ӵ�ά��
lz=zeros(psize,pd);

for i=1:psize   %����Ⱥ������ɡ�psize��pd�У�pdά��
%     lz(i,:)=rand(1,pd).*20-10;%��-10��10֮�䡿
    lz(i,1)=rand()*200;
    lz(i,2)=rand()*40-20;
end
lv=lz;
lzfigure=lz;%����ʼͼ��
goodvalue=lz;%ÿ�������Լ���ʷ���ֵ��ʼ��,psize��pd��
vmax=20;%�ٶ�����
c1=2;c2=2;%ѧϰ����
w=0.729;%������Ӻ͹������ӡ�
ri=0;
bestvalue=zeros(1,pd);%ȫ�����ֵ��ʼ����1��pd��
for j=1:pd
    bestvalue(1,j)=goodvalue(1,j);
end
fnew=zeros(1,psize);
for j=1:psize
    fnew(j)=fpso(lz(1,:));   
end
fold=fnew;
flagstop=0;%��ֹ��־
k=0;%����������¼
f0=fpso(bestvalue);%��Ӧֵ��ʼ����Ĭ�ϣ�
while flagstop==0
    %***********************...1...********************************
    for i=1:psize%��Ӧֵ�Ƚϣ����¸�����ʷ���ֵ��λ�ã�
        fnew(i)=fpso(lz(i,:));%��¼ÿ��ÿ�����ӵ���Ӧֵ�������Ժ�������ֹ����
        if fnew(i)<fold(i)
            fold(i)=fnew(i);%fold��¼ÿ�����ӵ������ʷֵ
            for j=1:pd
                goodvalue(i,j)=lz(i,j);
            end
        end
    end
%**************************...2...*********************************
    for i=1:psize%ÿ��������ʷ���ֵ��Ƚϣ�����ȫ�����ֵ(����ά)
        f1=fold(i);
        if f1<f0
            f0=f1;
            for j=1:pd
                bestvalue(1,j)=goodvalue(i,j);
            end
        end
    end
   %*********������һ����ֹ����*********%
 %   flagstop0=max(abs(fold));%�Ƚϵ��ε��������ӵ���Ӧֵ��
 %   flagstop1=min(abs(fold));%������֮�����С�����ֹͣ��
 %   if (flagstop0-flagstop1)<1
%        flagstop=1;
 %   end
 %***********************����������ֹ����***********
     if k>1000 %������������ǿ����ֹ���Է�������ѭ��
        flagstop=1;
    end
 %***********************
    %************************�ٶȺ�λ�ø���*******************
     for j=1:pd
        for i=1:psize
            lv(i,j)=w.*lv(i,j)+(c1*rand(1)).*(goodvalue(i,j)-lz(i,j))...
                +(c2*rand(1)).*(bestvalue(1,j)-lz(i,j));%�����ٶ�
            if lv(i,j)>vmax%�ٶ����ֵԼ��
                lv(i,j)=vmax;
            end
            lz(i,j)=lz(i,j)+lv(i,j);%��������λ��
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
    %*********************��ͼ*************************%
    
    if k==0 %������ʼ���ӵ�λ��
        subplot(2,2,1);
        t=1:psize;
        plot(lzfigure(t,1),lzfigure(t,2),'*');
        axis([0,200,-20,20]);        
    end
    for j=2:3%�ֱ𻭳�����300�κ�600�����ӵ�λ��
        if k==300*j
            subplot(2,2,j);
            t=1:psize;
           % gtext('k=600');
            plot(lz(t,1),lz(t,2),'*');
            axis([0,200,-20,20]);
        end
    end
    if flagstop==1 %������ֹʱ���ӵ�λ��
        subplot(2,2,4);
        t=1:psize;
    plot(lz(t,1),lz(t,2),'*');
    axis([0,200,-20,20]);
    end
%***********************************************************%
    k=k+1;
end
fprintf('�ܵ���������k=%ld��\n',k-1);
fprintf('ÿ�����ӵ���ʷ���ֵ��\n');
for i=1:psize
    fprintf('����%d�� [%6.4f,%6.4f]\n',i,goodvalue(i,1),goodvalue(i,2));
end
fprintf('ȫ�����ֵ��[%6.4f,%6.4f].\n',bestvalue(1,1),bestvalue(1,2));
fprintf('���Ž�(���ֵ)��%6.4f.\n',fpso(bestvalue(1,:)));
for j=1:20
    fprintf('����%dλ�ã�',j) ;  
    fprintf('x=%6.4f��y=%6.4f',lz(j,1),lz(j,2));
   fprintf('\n') ;
end
