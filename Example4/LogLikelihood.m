function out = LogLikelihood(x,Fs,H,dx,n)
L = x(1);
sig = x(2);
s = x(3);
mu = x(4);
C = covMatrix(sig,L,dx,n);
mu = mu *ones(size(Fs));
M = H*(C+s^2*eye(n))*H';

[u,l] = getSVD(M,.99);
v = (1./sqrt(l)).*(u'*(Fs-mu));
out = (1/2)*norm(v)^2 + (1/2)*log(prod(l))+(1/2)*n*log(2*pi);
