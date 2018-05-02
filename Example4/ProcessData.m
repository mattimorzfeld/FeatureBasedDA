function [c,l,u,M] = ProcessData(X)
Nx = sqrt(size(X,1)); Ny = Nx;

%% Downscale
nx = 2^6; 
r = Nx/nx;
x = zeros(nx^2,size(X,2));
for kk = 1:size(X,2)
    tmp = reshape(X(:,kk),Nx,Ny);
    tmp = reshape(tmp(1:r:end,1:r:end),nx*nx,1);
    x(:,kk) = tmp;
end
X =x;    
clear x

% disp('Computing covariance matrix ...')
M = mean(X,2);
C = cov(X');
% disp(' done...')

% disp('Computing evals and evecs ...')
[u,l]=eigs(C,size(X,2)-10);
l = diag(abs(l));
ind = find(l>1e-3);
l = l(ind);
u = u(:,ind);
% disp('done')

%% least squares
b = log(l);
A = [ones(length(l),1) (1:length(l))'];
c = A\b;
