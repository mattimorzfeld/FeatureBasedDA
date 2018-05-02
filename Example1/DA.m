function [xOpt,X,w,R,P] = DA(d,r,To,Te,Gap,lb,ub,xo,Ne)
%% Optimization
[xOpt,~,~,~,~,~,J]=myMinLS2(xo,r,d,To,Te,Gap,lb,ub);
%% Hessian
H = 1*(J'*J);
%% Posterior covariance
P = H\eye(2);
Lp = chol(P)';
%% Sampling
X = zeros(2,Ne);
w = zeros(Ne,1);
for kk=1:Ne
    X(:,kk) = xOpt + Lp*randn(2,1);
    tmp = funcF(X(:,kk),r,d,To,Te,Gap);
    w(kk) = tmp'*tmp - .5* (X(:,kk)-xOpt)'*H*(X(:,kk)-xOpt);
end
w = normalizeWeights(w);
X = resampling(w,X,Ne,2);
R = mean(w.^2)/mean(w)^2;




