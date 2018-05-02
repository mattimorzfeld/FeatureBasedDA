function out = loglikeFeature(m,Hd,Ld,T,dt,Rf)
theta = m(1:4);
xo =m(5:end);
[~,H,L] = simulate(theta,xo,T,dt);
H = H(1:1/dt:end,:);
L  = L(1:1/dt:end,:);

% SVD Feature
% ------------------------------------------
z = [H L];
[u,s,v] = svd(z);
z = [u(:,1);s(1,1);v(:,1)];
zd= [Hd Ld];
[ud,sd,vd] = svd(zd);
zd = [ud(:,1);sd(1,1);vd(:,1)];
% s = 0.005*abs(zd);
out = .5*(z-zd)'*(Rf\(z-zd));
%% ------------------------------------------

