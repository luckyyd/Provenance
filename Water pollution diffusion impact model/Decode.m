function ret=Decode(lenchrom,bound,code,opts)
%      input : length of chromosome
%      input : tag of coding method
%      input : boundary of varibles
%      output: value of varibles

        for i=length(lenchrom):-1:1
        data(i)=bitand(code,2^lenchrom(i)-1);
        code=(code-data(i))/(2^lenchrom(i));
        end
        ret=bound(:,1)'+data./(2.^lenchrom-1).*(bound(:,2)-bound(:,1))';
        switch opts
        case 'grey'   
            for i=sum(lenchrom):-1:2
                code=bitset(code,i-1,bitxor(bitget(code,i),bitget(code,i-1)));
            end
            for i=length(lenchrom):-1:1
            data(i)=bitand(code,2^lenchrom(i)-1);
            code=(code-data(i))/(2^lenchrom(i));
            end
            ret=bound(:,1)'+data./(2.^lenchrom-1).*(bound(:,2)-bound(:,1))';
        case 'float'  
            ret=code;
        end
end
