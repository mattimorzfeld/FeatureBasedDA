function out = funcFf(x,r,Rf,md,To,Te,Gap)
xi = x(1);
om = x(2);
[y,t]=model(xi,om,To,Te);
[td,d]=getData(y,t,0,Gap);
m = CompFeature(d,td,To);
out = (1/sqrt(2))*((1./sqrt(Rf)).*(md-m));
out = out';


