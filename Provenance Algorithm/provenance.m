%% DE-MCMC 
% This model explain the provenance procedure.
% Combined with DE-MCMC method. Input data are spatial records(tdata) with sampling
% points positions (xdata, ydata) and pollution concentration (cdata).
% 
%%
% First clear some variables from possible previous runs.
clear data model options

%%
% Next, create a data structure for the observations and control
% variables. Typically one could make a structure |data| that
% contains fields |xdata| and |ydata|.

% data.xdata = [28    55    83    110   138   225   375]';   % x (mg / L COD) 
% data.ydata = [0.053 0.060 0.112 0.105 0.099 0.122 0.125]'; % y (1 / h) 

% data.tdata = [ 10 20 30 40 50 60 70 80 90 100 ]';
% data.cdata = [ 0.000186269 0.005597822 0.015945217 0.025786002 0.033541179 0.039296168 0.043472867 0.046470316 0.048598992 0.050087414 ]';

% data.tdata = [ 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 ]';
% data.cdata = [ 0.3630 0.7476 0.7136 0.5884 0.4656 0.3640 0.2840 0.2220 0.1741 0.1370 0.1082 0.0857 0.0682 0.0544 0.0435 0.0349]';

% data.tdata = [30  60  90 120 150 180 210 240 270 300 330 ]';
data.tdata = [30  45  60  75  90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330]';

% data.cdata = [0.00022307  0.0838  0.3134  0.3879  0.3138  0.2070  0.1221  0.0674  0.0356  0.0183  0.0092 ]';
% data.cdata = [0.00022307 0.0139 0.0838 0.2028 0.3134 0.3766 0.3879 0.3611 0.3138 0.2595 0.2070 0.1607 0.1221 0.0913 0.0674 0.0492 0.0356 0.0256 0.0183 0.0130 0.0092]';
 data.cdata = [0.675290902 0.855683596 0.738407901 0.556047005 0.39450917 0.271846546 0.184490727 0.124189287 0.08323814 0.055672504 0.037204869 0.024862021 0.016620917 0.011119329 0.007445256 0.004989972 0.003347753 0.002248285 0.001511433 0.001017087 0.000685089]';
%4data.cdata = [0.753248001 0.981585936 0.745614969 0.505651547 0.394406531 0.298951031 0.204945059 0.146641206 0.077437126 0.052015024 0.037468908 0.027567977 0.016880032 0.011892205 0.006177106 0.005366677 0.002889953 0.002170745 0.001675262 0.001144334 0.000697482 ]';
% data.cdata = [0.703465322 0.873589593 0.677411167 0.611030689 0.400055087 0.266306349 0.169522411 0.134473031 0.083385013 0.052638362 0.038424743 0.024722048 0.018081436 0.011079192 0.007967458 0.004737707 0.003384637 0.00242308 0.00138198 0.001056046 0.000621778 ]';

% data.cdata = [0.00022407  0.0818  0.3124  0.3479  0.3538  0.2370  0.1421  0.0274  0.0856  0.0483  0.0192 ]';

% data.xdata = [0 1 2 3 4 5 6 ]';
% data.ydata = [5.9 3.1 2.0 3 6.1 10.9 18.1]';

%%
% Here is a plot of the data set.
 figure(1); clf
 plot(data.tdata,data.cdata,'s');
 xlim([10 250]); xlabel('t time'); ylabel('y C');

% plot(data.xdata,data.ydata,'s');
% xlim([0 400]); xlabel('x [mg/L COD]'); ylabel('y [1/h]');

%%
% For the MCMC run we need the sum of squares function. For the
% plots we shall also need a function that returns the model.
% Both the model and the sum of squares functions are
% easy to write as one line anonymous functions using the @
% construct. 

Dx=25;
Dy=10;
ux=1.5;
uy=0.25;
K = 4.2 / (24 * 60 * 60);   %s-1
H=2.0;

modelfun = @(t,theta) theta(1)./(4*pi*H*t*sqrt(Dx*Dy)).*exp(-(theta(2)-ux*t).^2./(4*Dx*t)-(theta(3)-uy*t).^2./(4*Dy*t)).*exp(-K*t);
% modelfun = @(x,theta) theta(1)*(x.^2)-theta(2)*x+theta(3);
% ssfun    = @(theta,data) sum((data.cdata-modelfun(data.tdata,theta)).^2);
ssfun    = @(theta,data) sum((data.cdata-modelfun(data.tdata,theta)).^2);
%%test
% ssfun(200,250,0,data);

% modelfun = @(x,theta) theta(1)*x./(theta(2)+x);
% ssfun    = @(theta,data) sum((data.ydata-modelfun(data.xdata,theta)).^2);


%%
% In this case the initial values for the parameters are easy to guess
% by looking at the plotted data. As we alredy have the sum-of-squares
% function, we might as well try to minimize it using |fminsearch|.
% [tmin,ssmin]=fminsearch(ssfun,[0.15;100],[],data)
% [tmin,cmin]=fminsearch(ssfun,[100;150;-1],[],data)
% n = length(data.tdata);
% p = 2;
% mse = cmin/(n-p) % estimate for the error variance
[xmin, ssmin] = fminsearch(ssfun,[18000;80;0],[],data)
n = length(data.tdata);
p = 2;
mse = ssmin/(n-p)
%%
% The Jacobian matrix of the model function is easy to calculate so we use
% it to produce estimate of the covariance of theta. This can be
% used as the initial proposal covariance for the MCMC samples by
% option |options.qcov| below.
% J = [data.tdata./(tmin(2)+data.tdata), ...
%      -tmin(1).*data.xdata./(tmin(2)+data.xdata).^2];
% tcov = inv(J'*J)*mse
% 
% J = [data.xdata./(xmin(3)+data.xdata), ...
%      -xmin(1).*data.xdata./(xmin(3)+data.xdata).^2,...
%      +xmin(2).*data.xdata./(xmin(3)+data.xdata).^2];
% tcov = inv(J'*J)*mse

%%
% We have to define three structures for inputs of the |mcmcrun|
% function: parameter, model, and options.  Parameter structure has a
% special form and it is constructed as Matlab cell array with curly
% brackets. At least the structure has, for each parameter, the name
% of the parameter and the initial value of it. Third optional
% parameter given below is the minimal accepted value. With it we set
% a positivity constraits for both of the parameters.

% params = {
%     {'theta1', tmin(1), 0}
%     {'theta2', tmin(2), 0}
%     };

% params = {
%     {'theta1', 100, 0}
%     {'theta2', 150, 0}
%     {'theta3', 0, 0}
%     };
params = {
    {'theta1', 8000, 0}
    {'theta2', 150, 0}
    {'theta3', 60, 0}
    };



%%
% In general, each parameter line can have up to 7 elements: 'name',
% initial_value, min_value, max_value, prior_mu, prior_sigma, and
% targetflag

%%
% The |model| structure holds information about the model. Minimally
% we need to set |ssfun| for the sum of squares function and the
% initial estimate of the error variance |sigma2|.

model.ssfun  = ssfun;
% model.sigma2 = 0.018^2;
%  model.sigma2 = 5.71^2;
%model.sigma2 = 0.266179826^2;

model.N=21;

%%
% The |options| structure has settings for the MCMC run. We need at
% least the number of simulations in |nsimu|. Here we also set the
% option |updatesigma| to allow automatic sampling and estimation of the
% error variance. The option |qcov| sets the initial covariance for
% the Gaussian proposal density of the MCMC sampler.

options.nsimu = 4000;
options.updatesigma = 1;
%  options.qcov = tcov;

%%
% The actual MCMC simulation run is done using the function
% |mcmcrun|.

[res,chain,s2chain] = mcmcrun(model,data,params,options);

%%
% <<mcmcstatus.png>>
%
% During the run a status window is showing the estimated time to
% the end of the simulation run. The simulation can be ended by Cancel
% button and the chain generated so far is returned.

%%
% After the run the we have a structure |res| that contains some
% information about the run, and a matrix outputs |chain| and
% |s2chain| that contains the actual MCMC chains for the parameters
% and for the observation error variance.

%%
% The |chain| variable is |nsimu| ?|npar| matrix and it can be
% plotted and manipulated with standard Matlab functions. MCMC toolbox
% function |mcmcplot| can be used to make some useful chain plots and
% also plot 1 and 2 dimensional marginal kernel density estimates of
% the posterior distributions.
%
figure(2); clf
mcmcplot(chain,[],res,'chainpanel');

%%
% The |'pairs'| options makes pairwise scatterplots of the columns of
% the |chain|.

figure(3); clf
mcmcplot(chain,[],res,'pairs');

%%
% If we take square root of the |s2chain| we get the chain for error
% standard deviation. Here we use |'hist'| option for the histogram of
% the chain.

figure(4); clf
mcmcplot(sqrt(s2chain),[],[],'hist')
title('Error std posterior')

%%
% A point estimate of the model parameters can be calculated from the
% mean of the |chain|. Here we plot the fitted model using the
% posterior means of the parameters.

x = linspace(0,400)';
figure(1)
hold on
plot(x,modelfun(x,mean(chain)),'-k')
hold off
legend('data','model',0)

%%
% Instead of just a point estimate of the fit, we should also study
% the predictive posterior distribution of the model. The |mcmcpred|
% and |mcmcpredplot| functions can be used for this purpose. By them
% we can calculate the model fit for a randomly selected subset of the
% chain and calculate the predictive envelope of the model. The grey
% areas in the plot correspond to 50%, 90%, 95%, and 99% posterior
% regions.

figure(5); clf
out = mcmcpred(res,chain,[],x,modelfun);
mcmcpredplot(out);
hold on
plot(data.tdata,data.cdata,'s'); % add data points to the plot
xlabel('x [mg/L COD]'); ylabel('y [1/h]');
hold off
title('Predictive envelopes of the model')
