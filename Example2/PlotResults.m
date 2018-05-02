%%
clear 
close all
clc


load Results.mat


%% modes
[~,Hopt,Lopt] = simulate(mu(1:4),mu(5:6),T,dt);


%%
F = []; X = [];
BurnIn = 2500;
for kk=1:size(m,2)
    Ftmp = squeeze(logp(2,kk,BurnIn:end));
    Xtmp = squeeze(m(:,kk,BurnIn:end)); 
    F = [F; Ftmp];
    X = [X Xtmp];
end
TrianglePlot(X,1)

%%

figure()
for kk=1:100
    ind =  randi(length(X));
    [t,H,L] = simulate(X(1:4,ind),X(5:6,ind),T,dt);
    t= t+1897+20;
    subplot(211)
    hold on, plot(t,L,'Color',Color(:,1))
    subplot(212)
    hold on, plot(t,H,'Color',Color(:,2))
end
%%
td= td+1897+20;
subplot(211)
hold on, plot(t,Lopt,'-','Color',Color(:,4),'LineWidth',2) 
hold on,plot(td,Ld,'.','Color',Color(:,5),'MarkerSize',25)
set(gcf,'Color','w')
set(gca,'FontSize',20)
xlabel('Time')
axis([1917 1927 0 10])

subplot(212)
hold on, plot(t,Hopt,'-','Color',Color(:,4),'LineWidth',2) 
hold on,plot(td,Hd,'.','Color',Color(:,5),'MarkerSize',25)
set(gcf,'Color','w')
set(gca,'FontSize',20)
xlabel('Time')
axis([1917 1927 0 10])

%% IACT
TauIntAv = 0;
for xx=1:6
    [~,~,~,tauinttmp,~,~] = UWerr_fft(X(xx,:)',1.5,length(X),1,1,1);
    TauIntAv = TauIntAv+tauinttmp;
end
fprintf('IACT = %g\n',TauIntAv/6)



% figure(8)
% hold on, plot(t,Lopt,'Color',Color(:,5)) 
% hold on, plot(t,Hopt,'Color',Color(:,5))
% hold on,plot(td,Ld,'.','Color',Color(:,4),'MarkerSize',25)
% hold on,plot(td,Hd,'.','Color',Color(:,4),'MarkerSize',25)


