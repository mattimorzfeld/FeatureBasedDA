function Rf = ComputeRf()

load HLData.mat
zd= [Hd Ld];
[ud,sd,vd] = svd(zd);
zd = [ud(:,1);sd(1,1);vd(:,1)];

nos = 10000;
Z = zeros(length(zd),nos);
for kk=1:nos
    H = Hd+randn(size(Hd));
    L = Ld+randn(size(Hd));
    z = [H L];
    [u,s,v] = svd(z);
    z = [u(:,1);s(1,1);v(:,1)];
    Z(:,kk) = z;
end
Rf = cov(Z');