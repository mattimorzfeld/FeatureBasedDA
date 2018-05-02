function [xs,Fxs,S,C,mu] = GPRupdateFullModel(z,r,ind,x,s,mu,C,NSamples)

xs = x(ind);
Fxs =  getFsFullModel(z,xs,r);
f = Fxs-mu(ind);


% update mean & covariance
Kxsx = C(:,ind);
Kxx = C(ind,ind);
mu = mu+ Kxsx*((Kxx+s)\f);
C = C-(Kxsx*Kxsx')/(Kxx+s);

% Get a few samples
[u,l]=getSVD(C,.99);
S = zeros(length(x),NSamples);
for kk=1:NSamples
    S(:,kk) = mu + u*(sqrt(l).*randn(length(l),1));
end

% get max of current mean
[a,b] = max(mu);
fprintf('Trying x = %g\n',xs)
fprintf('Current max: %g\n',a)
fprintf('Current location of max: %g\n',x(b))
disp(' ')