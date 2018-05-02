%%
clear 
close all
clc
colors

r = .5^2;
theta = -3.38125;
% [z,~,~,~,~] = GetFeature(theta);
% initX = [-.1 -2.5 -5]';
% Fs = getFsFullModel(z,initX,r);
% save InitialPhase.mat
 
initX =  [-5.0219    -2.6000   -0.1000]';
Fs = [0.0179  0.0801     0]';
z = [9.9440  -0.1445]';

numInit = length(initX)-1;
%%
dx = 0.01;
x = min(initX):dx:max(initX);
n = length(x);

Inds = zeros(length(initX),1);
for kk=1:length(initX)
    tmp = find(abs(x-initX(kk))<dx);
    Inds(kk) = tmp(1);
end
Inds = unique(Inds);

xopt = [.65;.28;.005;.17]

% Re-use function evaluations to construct GP
L = xopt(1); sig =xopt(2);  s =xopt(3); mus = xopt(4);
C = covMatrix(sig,L,dx,n);
C = C+s*eye(n);
mu = mus*ones(size(x))';
for kk=1:length(Inds)
    [xs,Fxs,S,C,mu] = GPRupdate(Inds(kk),kk,x,Fs,s,mu,C,200);
    figure(1)
%     plot(x,max(S,zeros(size(S))),'Color',Color(:,1))
%     hold on, plot(x,max(mu,zeros(size(mu))),'Color',Color(:,2),'LineWidth',2)
    plot(-x,S,'Color',Color(:,1))
    hold on, plot(-x,mu,'Color',Color(:,2),'LineWidth',2)
    box off
    hold off
    drawnow
%     pause
end
fprintf('Optimal length L = %g\n',L)

%%
hold on, plot(-initX,Fs,'.','Color',Color(:,3),'MarkerSize',30)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off
 
%% How many steps to take 
NumSteps = 30;
AllXs = zeros(NumSteps,1);
AllFs = zeros(NumSteps,1);
AllXs(1:numInit+1) = initX';
AllFs(1:numInit+1) = Fs;
counter = numInit+1;
go = 1;
while go == 1
    figure(8)
    set(gcf,'Color','w')
    
    % expected improvement
    [ind,EI] = compEI(x,AllFs(1:counter),mu,C);
    if sum(abs(EI))<1e-4
        figure(8)
        subplot(211)
%         plot(x,max(S,zeros(size(S))),'Color',Color(:,1))
%         hold on, plot(x,mu,'Color',Color(:,2),'LineWidth',2)
        plot(-x,S,'Color',Color(:,1))
        hold on, plot(-x,mu,'Color',Color(:,2),'LineWidth',2)
        hold on, plot(-AllXs(1:counter),AllFs(1:counter),'.','Color',Color(:,4),'MarkerSize',20)
        box off
        break
    end
    figure(8)
    subplot(212)
    plot(-x,EI), box off
    hold on, plot(-x(ind),EI(ind),'.','Color',Color(:,4),'MarkerSize',20)
    hold off
    for uu=1:length(ind)
        [xs,Fxs,S,C,mu] = GPRupdateFullModel(z,r,ind(uu),x,s,mu,C,100);
        AllXs(counter) = xs;
        AllFs(counter) = Fxs;
        counter = counter +1 ;
    end
    figure(8)
    subplot(211)
%     plot(x,max(S,zeros(size(S))),'Color',Color(:,1))
%     hold on, plot(x,max(mu,zeros(size(mu))),'Color',Color(:,2),'LineWidth',2)
    plot(-x,S,'Color',Color(:,1))
    hold on, plot(-x,mu,'Color',Color(:,2),'LineWidth',2)
    hold on, plot(-AllXs(1:counter),AllFs(1:counter),'.','Color',Color(:,4),'MarkerSize',20)
    box off
    hold off
    drawnow
    
    
    [tmp1,tmp2]=max(mu);
    fprintf('Current max %g at x = %g\n',tmp1,x(tmp2));
    drawnow
    
    if counter>NumSteps-numInit
        break
    end
    fprintf('Iteration %g done\n',counter-(numInit+1))
end

%%
[a,funcF]=PlotF(34,r,z);
figure
% plot(x,max(S,zeros(size(S))),'Color',Color(:,1))
plot(-x,S,'Color',Color(:,1))
hold on,plot(-a,funcF,'Color',Color(:,5))
hold on, plot(-x,mu,'Color',Color(:,2),'LineWidth',2)
hold on, plot(-AllXs(1:counter-1),AllFs(1:counter-1),'.','Color',Color(:,4),'MarkerSize',30)
hold on, plot(-initX,Fs,'.','Color',Color(:,3),'MarkerSize',30)
set(gcf,'Color','w')
set(gca,'FontSize',20)
axis([0 5.2 -1 1.1])
box off


%% 
disp(' ')
fprintf('Results\n')
fprintf('True parameter: %g \n',theta)
fprintf('Estimate: %g \n',x(tmp2))
fprintf('Number of function evals: %g\n',counter)
disp(' ')


