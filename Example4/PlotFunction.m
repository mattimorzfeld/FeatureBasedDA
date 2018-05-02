%%
clear 
close all
clc
colors

load Map.mat
[a,ind]=sort(a);
Fc1 = Fc1(:,ind);
Fc2 = Fc2(:,ind);
Fc1 = Fc1(1:end-1,:);
plot(a,Fc1,'.','Color',Color(:,2),'MarkerSize',20)
hold on, plot(a, mean(Fc1),'Color',Color(:,1),'LineWidth',2)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off

figure
plot(a,Fc2,'.','Color',Color(:,2),'MarkerSize',20)
hold on, plot(a, mean(Fc2),'Color',Color(:,1),'LineWidth',2)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off

trueInd = 50;
theta = a(trueInd);
randind = randi(size(Fc1,1));
z = [Fc1(randind,trueInd);
        Fc2(randind,trueInd)];
figure(1)
hold on, plot(theta,z(1),'r.','MarkerSize',20)
figure(2)
hold on, plot(theta,z(2),'r.','MarkerSize',20)    


not = 20;
funcF = zeros(length(a),not);
for ll=1:not
    for kk=1:length(a)
        randind = randi(size(Fc1,1));
        y = [Fc1(randind,kk);
                Fc2(randind,kk)];
        funcF(kk,ll) = norm(z-y)^2/2;
    end
end
figure(3)
hold on,plot(a,funcF,'Color',Color(:,1),'LineWidth',2)
hold on, plot(a,mean(funcF'),'Color',Color(:,4),'LineWidth',2)
set(gcf,'Color','w')
set(gca,'FontSize',20)
box off