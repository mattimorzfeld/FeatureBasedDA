function [xOpt,X,w,R] = featureDA(d,td,r,To,Te,Gap,Ne)
%% Estimate noise and compute feature from data
nExps= 1000;
mtAll = zeros(2,nExps);
for kk=1:nExps
    dp = d+sqrt(r)*randn(size(d));
    mtAll(:,kk) = CompFeature(dp,td,To);
end
mf = CompFeature(d,td,To);
Rf = diag(cov(mtAll'))';

%% Optimization
xo = [2.25;mf(1)];
[xOpt,~,~,~,~,~,J]=myMinLS2f(xo,r,Rf,mf,To,Te,Gap);
%% Hessian
H = 2*(J'*J);
%% Posterior covariance
P = H\eye(2);
Lp = chol(P)';
%% Sampling
X = zeros(2,Ne);
w = zeros(Ne,1);
for kk=1:Ne
    X(:,kk) = xOpt + Lp*randn(2,1);
    tmp = funcFf(X(:,kk),r,Rf,mf,To,Te,Gap);
    w(kk) = tmp'*tmp - .5* (X(:,kk)-xOpt)'*H*(X(:,kk)-xOpt);
end
w = normalizeWeights(w);
X = resampling(w,X,Ne,2);
R = mean(w.^2)/mean(w)^2;




