%%
clear
close all
clc
colors


%% Data
%% ------------------------------------------
load HLData.mat
% plot(td,Hd,td,Ld)
% figure
% hold on, plot(Hd,Ld)
%% ------------------------------------------


%% Parameters
%% ------------------------------------------
xo = [Hd(1);Ld(1)];
theta = ones(4,1);
T= td(end);
dt = 0.01;
sL = 1;
sH = 1;
Rf = ComputeRf();
%% ------------------------------------------


%% Optimize 
%% ------------------------------------------
% for kk=1:1
%     m =[1*rand(4,1);xo];
%     go =1;
%     while go == 1
%         m  =[1*rand(4,1);xo];
%         if sum(m>0)==length(m)
%             go=0;
%         end
%     end
%         m
%     xopt=myMinFeature(m,Hd,Ld,T,dt,Rf);
%      
%     %%
%     [t,H,L] = simulate(xopt(1:4),xopt(5:6),T,dt);
%     plot(td,Ld,'.','Color',Color(:,1),'MarkerSize',25)
%     hold on,plot(td,Hd,'.','Color',Color(:,2),'MarkerSize',25)
%     hold on, plot(t,L,'Color',Color(:,1)) 
%     hold on, plot(t,H,'Color',Color(:,2))
%     hold off
% %     pause
% end
% Result:
% mu = [0.5861    0.2345    0.7780    0.1768     2.5786     3.8248]';

%% ------------------------------------------
 
%% Hammertime
%% ------------------------------------------
lb = zeros(6,1);
ub = 10*ones(6,1);
 
%% Prior
logprior =@(m) ...
                       (m(1)>lb(1)) && (m(1)<ub(1)) && ...
                       (m(2)>lb(2)) && (m(2)<ub(2)) && ...
                       (m(3)>lb(3)) && (m(3)<ub(3)) && ...
                       (m(4)>lb(4)) && (m(4)<ub(4)) && ...
                       (m(5)>lb(5)) && (m(5)<ub(5)) && ...
                       (m(6)>lb(6)) && (m(6)<ub(6));
                   
                   
%% log - Likelihood
logLike=@(m) -loglikeFeature(m,Hd,Ld,T,dt,Rf);

%% initial ensemble
Ne = 12;
mu = [0.5861    0.2345    0.7780    0.1768     2.5786     3.8248]';

si = [0.02*mu(1:4); .2*mu(5:6)];
minit = zeros(6,Ne);
counter = 1;
for kk=1:Ne
    minit(:,kk) = mu+si.*randn(6,1);
end

%% Hammer time....
[m,logp]=gwmcmc(minit,{logprior logLike},1e5,'ThinChain',1,'burnin',0);

%%
F = []; X = [];
BurnIn = 1;
for kk=1:size(m,2)
    Ftmp = squeeze(logp(2,kk,BurnIn:end));
    Xtmp = squeeze(m(:,kk,BurnIn:end)); 
    F = [F; Ftmp];
    X = [X Xtmp];
end
TrianglePlot(X,1)

%%
figure(11)
for kk=1:100
    ind =  randi(length(X));
    [t,H,L] = simulate(X(1:4,ind),X(5:6,ind),T,dt);
    hold on, plot(t,L,'Color',Color(:,1))
    hold on, plot(t,H,'Color',Color(:,2))
end
%%
hold on,plot(td,Ld,'.','Color',Color(:,4),'MarkerSize',25)
hold on,plot(td,Hd,'.','Color',Color(:,5),'MarkerSize',25)


%% IACT
TauIntAv = 0;
for xx=1:6
    [~,~,~,tauinttmp,~,~] = UWerr_fft(X(xx,:)',1.5,length(X),1,1,1);
    tauinttmp
    TauIntAv = TauIntAv+tauinttmp;
end
fprintf('IACT = %g\n',TauIntAv/6)

save Results.mat



