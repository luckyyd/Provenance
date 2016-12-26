function y=f1(t)
y=0.58123108938362951707736011098632*erfc((30000-30*t)./sqrt(4.8*t)); 
               pick=rand;
                while pick==0
                    pick=rand;
                end
                index=ceil(pick*sizepop);
                pick=rand;
                if pick>pmutation
                   continue;
                end
                pick=rand;
                while pick==0
                     pick=rand;
                end
                pos=ceil(pick*sum(lenchrom));
                v=bitget(chrom(index),pos);
                v=~v;
                chrom1=bitset(chrom(index),pos,v);
            end
            
        ret=chrom;
    case 'float' 
        for i=1:sizepop
              pick=rand;
                while pick==0
                    pick=rand;
                end
                index=ceil(pick*sizepop);
                pick=rand;
                if pick>pmutation
                   continue;
                end
                pick=rand;
                while pick==0
                     pick=rand;
                end
                pos=ceil(pick*sum(lenchrom));
                v=chrom(i,pos);
                v1=v-bound(pos,1);
                v2=bound(pos,2)-v;
                pick=rand;
                if pick>0.5
                    delta=v2*(1-pick^((1-pop(1)/pop(2))^2));
                    chrom(i,pos)=v+delta;
                else
                    delta=v1*(1-pick^((1-pop(1)/pop(2))^2));
                    chrom(i,pos)=v-delta;
                end
        end
        ret=chrom;
end
 sumfitness=sum(1./individuals.fitness);
        sumf=(1./individuals.fitness)./sumfitness;
        index=[]; 
        for i=1:sizepop
            pick=rand;
            while pick==0
                 pick=rand;
            end
            for i=1:sizepop
                pick=pick-sumf(i);
                if pick<0
                   index=[index i];
                   break;
                end
            end
        end
        individuals.chrom=individuals.chrom(index,:);
        individuals.fitness=individuals.fitness(index);
        ret=individuals;
case 'tournament'      allindex=[];    
    for i=1:sizepop
        pick=rand(1,2);
        while prod(pick)==0
             pick=rand(1,2);
        end
        index=ceil(pick.*sizepop);
        if individuals.fitness(index(1))<=individuals.fitness(index(2))
             allindex=[allindex index(1)];
        else
             allindex=[allindex index(2)];
        end
    end
    individuals.chrom=individuals.chrom(allindex,:);
    individuals.fitness=individuals.fitness(allindex);
    ret=individuals;        
end
z=zeros(1);
z=quadl('f1',1000,9800);
disp
