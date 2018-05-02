function [psi0,psi1,psin1] = getIC(Nx,gamma,kx,ky)
load IC.mat
psi0 = M+ u*(sqrt(l).*randn(length(l),1));
psi0 = reshape(psi0,2^6,2^6);
%% scale up
fac = Nx/length(psi0)/2;
psi0 = interp2(psi0,fac);
psi0 = [psi0(1:2*fac-1,:); psi0];
psi0 = [psi0 psi0(:,1:2*fac-1)];

psi1 = fft2(psi0);
psin1 = -gamma*fft2((ifft2(1i*psi1.*kx)).^2+(ifft2(1i*psi1.*ky)).^2);
