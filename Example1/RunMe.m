
%%
clear
close all
clc
colors

%% True model parameters
lb = [.5;.5]; 
ub = [4; 4];
xi = 1.5;
om = 1.;

%% Start and end of the experiment
To = 5;
Te = 40;

%% "Truth"
[yt,t]=model(xi,om,To,Te);

%% Get data
Gap = 5;
r = 0.001;
[td,d]=getData(yt,t,r,Gap);

figure(1)
plot(td,d,'.','Color',Color(:,2),'MarkerSize',15)
hold on, plot(t,yt,'Color',Color(:,1),'LineWidth',2)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off


% %% Classical DA wtih fixed covariance
% Ne = 1000;
% xo = [2.25;mean(1/sqrt(d))];
% [xOpts,Xs,ws,Rs] = FixedCovDA(d,r,To,Te,Gap,lb,ub,xo,Ne);
%  
% fprintf('R=%g\n',Rs)
% [ys,t]=model(xOpts(1),xOpts(2),To,Te);
% figure(1)
% hold on, plot(t,ys,'Color',Color(:,5),'LineWidth',2)
% 
% figure
% for kk=1:500:Ne
%     [yss,t]=model(Xs(1,kk),Xs(2,kk),To,Te);
%     hold on, plot(t,yss,'Color',Color(:,5),'LineWidth',2)
% end
% hold on,plot(td,d,'.','Color',Color(:,2),'MarkerSize',15)
% set(gcf,'Color','w')
% set(gca,'FontSize',20)
% box off

% TrianglePlot(Xs,1)

%% feature based DA
Ne = 5000;
[xOptf,Xf,wf,Rf] = featureDA(d,td,r,To,Te,Gap,Ne);
fprintf('R=%g\n',Rf)
[yc,t]=model(xOptf(1),xOptf(2),To,Te);
figure(1)
hold on, plot(t,yc,'Color',Color(:,5),'LineWidth',2)

figure(2)
for kk=1:100:Ne
    [ycs,t]=model(Xf(1,kk),Xf(2,kk),To,Te);
    hold on, plot(t,ycs,'Color',Color(:,5),'LineWidth',2)
end
hold on,plot(td,d,'.','Color',Color(:,2),'MarkerSize',15)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off
%
TrianglePlot(Xf,1)

%% Classical DA
xo = [1.2;1.2];
Ne = 5000;
[xOptc,Xc,w,R] = DA(d,r,To,Te,Gap,lb,ub,xo,Ne);
fprintf('R=%g\n',R)
[yc,t]=model(xOptc(1),xOptc(2),To,Te);
figure(1)
hold on, plot(t,yc,'Color',Color(:,5),'LineWidth',2)

figure
for kk=1:100:Ne
    [ycs,t]=model(Xc(1,kk),Xc(2,kk),To,Te);
    hold on, plot(t,ycs,'Color',Color(:,1),'LineWidth',2)
end
hold on,plot(td,d,'.','Color',Color(:,2),'MarkerSize',15)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off

%%
figure(3)
TrianglePlotUp(Xc,1)
fprintf('R=%g\n',R)



