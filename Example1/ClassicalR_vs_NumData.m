%%
clear
close all
clc
colors

%% True model parameters
lb = [.5;.5]; 
ub = [1.5; 1.5];
xi = 1.;
om = 1.;

%% For data collection
Gap = 5;
r = 0.001;

%% Start and end of the experiment
To = 5;
TeAll = [60];% 100 150 250];

%% For DA
Ne = 1000;
xo = [1.75;1.75];

%% How many experiments
NumExps = 4;

MSEAll = zeros(length(TeAll),NumExps);
RAll = zeros(length(TeAll),NumExps);
tracePAll = zeros(length(TeAll),NumExps);


for zz=1:NumExps
    for jj=1:length(TeAll)
        fprintf('Experiment %g/%g\n',zz,NumExps)
        fprintf('Num data %g/%g\n',jj,length(TeAll))
        %% "Truth"
        [yt,t]=model(xi,om,To,TeAll(jj));
        %% Get data
        [td,d]=getData(yt,t,r,Gap);
        %% Classical DA
        [xOptc,Xc,w,R] = DA(d,r,To,TeAll(jj),Gap,lb,ub,xo,Ne);
        fprintf('R=%g\n',R)
        RAll(jj,zz) = R;
        MSEAll(jj,zz) = sum((xOptc-[xi;om]).^2)/2;
        tracePAll(jj,zz)=trace(cov(Xc'))/2;
        
        TrianglePlot(Xc,1)
        drawnow
    end
end

%%
figure
subplot(211)
plot(TeAll,RAll,'.','Color',Color(:,2),'MarkerSize',20)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off
subplot(212)
plot(TeAll,MSEAll,'.','Color',Color(:,2),'MarkerSize',20)
hold on, plot(TeAll,tracePAll,'.','Color',Color(:,4),'MarkerSize',20)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off




