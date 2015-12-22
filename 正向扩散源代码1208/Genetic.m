function Genetic
maxgen=200;                        
sizepop=100;                                     
fselect='tournament';                                                    
fcode='float';                                                        
pcross=[0.6];                       
fcross='float';                                                     
pmutation=[0.2];                 
 fmutation='float';                                         
lenchrom=[1 ];      
bound=[0 100000];
individuals=struct('fitness',zeros(1,sizepop)；          
avgfitness=[];          
bestfitness=[];                 
bestchrom=[];                      
for i=1:sizepop
    individuals.chrom(i,:)=Code(lenchrom,fcode,bound);
    x=Decode(lenchrom,bound,individuals.chrom(i,:),fcode);
    individuals.fitness(i)=Aimfunc(x);
end
[bestfitness bestindex]=min(individuals.fitness);
bestchrom=individuals.chrom(bestindex,:);
avgfitness=sum(individuals.fitness)/sizepop;
trace=[avgfitness bestfitness]; 
for i=1:maxgen
    individuals=Select(individuals,sizepop,fselect);
    avgfitness=sum(individuals.fitness)/sizepop;
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,...
        sizepop,fcross,[i maxgen]);
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,...
        sizepop,fmutation,[i maxgen],bound);
  for j=1:sizepop
        x=Decode(lenchrom,bound,individuals.chrom(j,:),fcode);
        individuals.fitness(j)=Aimfunc(x);   
    end
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [worestfitness,worestindex]=max(individuals.fitness);
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:)=bestchrom;
    individuals.fitness(worestindex)=bestfitness;
   avgfitness=sum(individuals.fitness)/sizepop;
   trace=[trace;avgfitness bestfitness];
    end 
if ishandle(hfig)
    figure(hfig);
else
    hfig=figure('Tag','trace');
end
figure(hfig);
[r c]=size(trace);
plot([1:r]',trace(:,1),'r-',[1:r]',trace(:,2),'b--');
title(['适应度曲线  ' '终止代数＝' num2str(maxgen)]);
xlabel('进化代数');ylabel('适应度');
legend('平均适应度','最佳适应度');
disp('适应度                      变量');
x=Decode(lenchrom,bound,bestchrom,fcode);
% show in command window
vpa(bestfitness,10);
vpa(x,10);
disp([bestfitness      x]);
