%%
clear 
close all
clc
colors

r = .3^2;

trueInd = 70;
numInit = 10;
[Fs,initX,theta] = getFs(trueInd,numInit,r);
[z,Xd,l,~,~] = GetFeature(theta);


%%
x = 1:length(l);
figure(1)
hold on, plot(x,exp(z(1)+z(2)*x),'Color',Color(:,4),'LineWidth',2)
hold on, plot(l,'.','Color',Color(:,2),'MarkerSize',25)
set(gcf,'Color','w')
set(gca,'FontSize',20)
set(gca,'YScale','log')
axis([1 x(end) 10^-4 10^4])
box off

%%
% Nx=2^8;
% Ny=2^8;
% [x,y] = meshgrid(linspace(0,10,Nx),linspace(0,10,Ny));
% 
% for kk=1:20:size(Xd,2)
%     X = reshape(Xd(:,kk),Nx,Ny);
%     surf(x,y,X);
%     colormap nicecolormap
%     shading interp
%     axis([0 10 0 10 -20 20])
%     view([0 90])
%     drawnow
%     set(gcf,'Color','w')
%     set(gca,'FontSize',20)
%     pause
% end


%%
trueInd = 40;
numInit = 10;
[Fs,initX,theta] = getFs(trueInd,numInit,r);
[z,Xd,l,~,~] = GetFeature(theta);


%%
x = 1:length(l);
figure(1)
hold on, plot(x,exp(z(1)+z(2)*x),'Color',Color(:,5),'LineWidth',2)
hold on, plot(l,'.','Color',Color(:,1),'MarkerSize',25)
set(gcf,'Color','w')
set(gca,'FontSize',20)
set(gca,'YScale','log')
axis([1 x(end) 10^-4 10^4])
box off