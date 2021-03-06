function re=compute_fit(par)
    x=par.x;
    y=par.y;
    sigma=50;
    if x<0 || x>200 || y<-20 || y>20
        re=0;        %超出范围适应度为0
    else            %否则适应度按目标函数求解
        re= (1/(2*pi*sigma^2))*exp(-(x.^2+y.^2)/(2*sigma^2)); 
    end
end