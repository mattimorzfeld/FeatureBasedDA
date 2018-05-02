clear 
close all
clc
colors

r = .3^2;

trueInd = 40;
numInit = 10;
[Fs,initX,theta] = getFs(trueInd,numInit,r);
[z,Xd,l,~,~] = GetFeature(theta);

%%
Nx=2^8;
Ny=2^8;
X = Xd+sqrt(.5)*sqrt(abs(Xd)).*randn(size(Xd));
Xplot = reshape(X(:,end),Nx,Ny);
surf(Xplot)
colormap nicecolormap
shading interp
    
%%
nos = 20;
f = zeros(2,nos);
for kk = 1:nos
    fprintf('%g/%g\n',kk,nos)
    X = Xd+sqrt(.8)*sqrt(abs(Xd)).*randn(size(Xd));
    [c,l,u,M] = ProcessData(X);
    f(:,kk) = c;
end
%     
    