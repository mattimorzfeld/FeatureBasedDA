%%
clear 
close all
clc

%% Map function
s = sobolset(1);
a = -0.1-5*net(s,100);


att = 50;
Fc1 = zeros(att,length(a));
Fc1 = zeros(att,length(a));

for jj = 1:att
    fprintf('Attempt %g/%g\n',jj,att)
    for kk=1:length(a)
        fprintf('   Func eval %g / %g\n',kk, length(a))
        [c,~,~,~,~]= GetFeature(a(kk));
        Fc1(jj,kk) = c(1);
        Fc2(jj,kk) = c(2);
    end
end

% save Map.mat Fc1 Fc2 a