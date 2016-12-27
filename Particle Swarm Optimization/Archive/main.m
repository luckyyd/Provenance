Scope=[0 200
    -20 20];
[v,on,off,minmax]=PsoProcess(20,2,Scope,@InitSwarm,@BasestepPSO,@Griewank,0,0,4000,0);

