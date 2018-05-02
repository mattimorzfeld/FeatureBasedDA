function [u,l]=getSVD(C,tol)
[u,l]=eig(C);
l = diag(l);
l = abs(l(end:-1:1));
u = u(:,end:-1:1);

go = 1;
kk = 1;
for kk=1:length(l);
    if sum(l(1:kk).^2)/sum(l.^2)>tol
        break
    end
end
l = l(1:kk);
u = u(:,1:kk);

