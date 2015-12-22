function ret=AimFunc(x)
z=quadl('f',0.0001,7200,[],[],x);
ret=abs(z-49.771090910000000000000000000000);
