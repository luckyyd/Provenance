function y=f(t,x)
y=7565./sqrt(4.8*pi*t).*exp(-(x-3*t).^(2)./(4.8*t));
        pick=rand(1,sum(lenchrom));
        bits=ceil(pick-0.5);
        temp=sum(lenchrom)-1:-1:0;
        ret=sum(bits.*(2.^temp));
    case 'grey'   
        pick=rand(1,sum(lenchrom));
        bits=ceil(pick-0.5);
        greybits=bits;
        for i=2:length(greybits)
            greybits(i)=bitxor(bits(i-1),bits(i));
        end
        temp=sum(lenchrom)-1:-1:0;
        ret=sum(greybits.*(2.^temp));
    case 'float'   % float coding
        pick=rand(1,length(lenchrom));
        ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick;
end
