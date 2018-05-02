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

%% For data collection
Gap = 5;
r = 0.001;

%% Start and end of the experiment
To = 5;
TeAll = [25:25:250];
% TeAll = [50 250];


%% For DA
Ne = 500;
xo = [1.5;1.];

%% How many experiments
% NumExps = 1000;
% KLAll = zeros(length(TeAll)-1,NumExps);
% for zz=1:NumExps
%     %%  longest data stream
%     %% "Truth"
%     [yt,t]=model(xi,om,To,TeAll(end));
%     %% Get data
%     [td,dAll]=getData(yt,t,r,Gap);
%     %% Classical DA
%     [mo,~,~,R,Po] = DA(dAll,r,To,TeAll(end),Gap,lb,ub,xo,Ne);
%     fprintf('xi = %g pm %g\n',mo(1),sqrt(Po(1,1)))
%     fprintf('ome = %g pm %g\n',mo(2),sqrt(Po(2,2)))
%     fprintf('R = %g \n',R)
%     for jj=1:length(TeAll)-1
%         fprintf('Experiment %g/%g\n',zz,NumExps)
%         fprintf('Num data %g/%g\n',jj,length(TeAll))
%         d = dAll(1:find(td==TeAll(jj)));
%       %% Classical DA
%         [m1,~,~,R,P1] = DA(d,r,To,TeAll(jj),Gap,lb,ub,xo,Ne);
%         KLAll(jj,zz) = KL(mo,Po,m1,P1);
%         fprintf('xi = %g pm %g\n',m1(1),sqrt(P1(1,1)))
%         fprintf('ome = %g pm %g\n',m1(2),sqrt(P1(2,2)))
%         fprintf('R = %g \n',R)
%     end
% end
% 
% %%
% figure
% plot(TeAll(1:end-1),KLAll,'.','Color',Color(:,2),'MarkerSize',20)
% set(gcf,'Color','w')
% set(gca,'FontSize',20)
% box off

% save ResultsKS.mat

load ResultsKS.mat
[inds1,inds2] = find(KLAll > 1e6);
for jj=1:length(inds1)
    KLAll(inds1(jj),inds2(jj)) = KLAll(inds1(jj),inds2(jj)-1);
end
stdKLAll = sqrt(diag(cov(KLAll')));

figure
myerrorCloud(mean(KLAll,2),stdKLAll,TeAll(1:end-1)',Color(:,6),Color(:,2))

% hold on,plot(TeAll(1:end-1),mean(KLAll,2)+1*stdKLAll,'.','Color',Color(:,2),'MarkerSize',35)
% hold on,plot(TeAll(1:end-1),mean(KLAll,2)-1*stdKLAll,'.','Color',Color(:,2),'MarkerSize',35)
%  myerrorbar(mean(KLAll,2),stdKLAll,TeAll(1:end-1),Color(:,2),5,'.',35)

set(gcf,'Color','w')
set(gca, 'YScale', 'log')
set(gca,'FontSize',20)
box off


% least squares fit
A = [ones(length(TeAll)-1,1) TeAll(1:end-1)'];
pfit = A\log(mean(KLAll,2));
hold on, plot(TeAll(1:end-1),exp(pfit(1)+TeAll(1:end-1)*pfit(2)), ...
    'Color',Color(:,4),'LineWidth',2)
hold on,plot(TeAll(1:end-1),mean(KLAll,2),'.','Color',Color(:,2),'MarkerSize',35)

axis([0 250 1e-2 3])
xlabel('Duration of experiment')
ylabel('KL divergence')