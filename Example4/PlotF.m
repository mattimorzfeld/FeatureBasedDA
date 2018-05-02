function [a,funcF]=PlotF(trueInd,r,z)
load Map.mat
[a,ind]=sort(a);
Fc1 = Fc1(:,ind);
Fc2 = Fc2(:,ind);
Fc1 = Fc1(1:end-1,:);
theta = a(trueInd);
% randind = randi(size(Fc1,1));
% z = [Fc1(randind,trueInd);
%         Fc2(randind,trueInd)];
not = 100;
funcF = zeros(length(a),not);
for ll=1:not
    for kk=1:length(a)
        randind = randi(size(Fc1,1));
        y = [Fc1(randind,kk);
                Fc2(randind,kk)];
        funcF(kk,ll) =exp(-norm((r*[9;.25].^2).\(z-y))^2/2);
%         funcF(kk,ll) = -norm((r*[9;.25].^2).\(z-y))^2/2;
    end
end
