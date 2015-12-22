function ret=Cross(pcross,lenchrom,chrom,sizepop,opts,pop)
%        input  : probability of crossover
%        input  : length of a chromosome
%        input  : set of all chromosomes
%        input  : size of population
%        input  : tag for choosing method of crossover
%        input  : current serial number of generation and maximum gemeration
%        output : new set of chromosome
switch opts
    case 'simple'
        for i=1:sizepop
            pick=rand(1,2);
            index=ceil(pick.*sizepop);
            while prod(pick)==0 | index(1)==index(2)
                 pick=rand(1,2);
                 index=ceil(pick.*sizepop);
            end
            pick=rand;
            if pick>pcross
               continue;
            end
            pick=rand;
            while pick==0
                 pick=rand;
            end
            pos=ceil(pick.*sum(lenchrom));
            tail1=bitand(chrom(index(1)),2.^pos-1);
            tail2=bitand(chrom(index(2)),2.^pos-1);
            chrom(index(1))=chrom(index(1))-tail1+tail2;
            chrom(index(2))=chrom(index(2))-tail2+tail1;
       end
       ret=chrom;
   case 'uniform' 
        for i=1:sizepop
            pick=rand(1,2);
            while prod(pick)==0
                 pick=rand(1,2);
            end
            index=ceil(pick.*sizepop);
            pick=rand;
            while pick==0
                 pick=rand;
            end
            if pick>pcross
               continue;
            end
            pick=rand;
            while pick==0
                 pick=rand;
            end
            mask=2^ceil(pick*sum(lenchrom));
            chrom1=chrom(index(1));
            chrom2=chrom(index(2));
            for j=1:sum(lenchrom)
                v=bitget(mask,j); 
                if v==1
                    chrom1=bitset(chrom1,...
                        j,bitget(chrom(index(2)),j));
                    chrom2=bitset(chrom2,...
                        j,bitget(chrom(index(1)),j));
                end
            end
            chrom(index(1))=chrom1;
            chrom(index(2))=chrom2;
        end
       ret=chrom;
   case 'float'
       for i=1:sizepop
             pick=rand(1,2);
            while prod(pick)==0
                 pick=rand(1,2);
            end
            index=ceil(pick.*sizepop);
            pick=rand;
            while pick==0
                 pick=rand;
            end
            if pick>pcross
               continue;
            end
            pick=rand;
            while pick==0
                 pick=rand;
            end
            pos=ceil(pick.*sum(lenchrom));
            pick=rand;
            v1=chrom(index(1),pos);
            v2=chrom(index(2),pos);
            chrom(index(1),pos)=pick*v2+(1-pick)*v1;
            chrom(index(2),pos)=pick*v1+(1-pick)*v2;
        end
        ret=chrom;
end
