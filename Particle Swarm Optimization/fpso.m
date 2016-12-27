function fvalue=fpso(x)
% fvalue=(x(1)+2)*(x(1)-3)+(x(2)-4)*(x(2)-2);			%f1


T = 0.5;
t = T * 50; %s
K = 4.2 / (24 * 60 * 60);   %s-1
ux = 1.5; uy = 0.0; %m/s
Dx = 50; Dy = 10;   %m2/s
B = 30; H = 2.0;    %m
M = 20000;
fvalue = -M./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(x(1)-ux*t).^2./(4*Dx*t)-(x(2)-uy*t).^2./(4*Dy*t)).*exp(-K*t);
pd=2;%Á£×ÓµÄÎ¬Êý

%************f3******
% fvalue=0;
%     for r=1:(pd-1)
%         f0=100*(x(r)-x(r+1)^2)^2+(x(r+1)-1)^2;
%         fvalue=fvalue+f0;
%     end
    %**********
  %fvalue=(x(1)-2)*(x(1)-2.5)+(x(2)-4)*(x(2)-5); 
  %   for r=1:pd
  %      f0=(x(r))*sin(sqrt(abs(x(r))));
   %     fvalue=fvalue+f0;
   % end
  %fvalue=x(1)^2+2*x(2)^2-0.3*cos(3*pi*x(1)+4*pi*x(2))+0.3;
  %fvalue=-(3/(0.05+x(1)^2+x(2)^2))^2+(x(1)^2+x(2)^2)^2;
 %fvalue=-(-(x(1)^2-10*cos(2*pi*x(1))+10)-(x(2)^2-10*cos(2*pi*x(2))+10));%f2
end
