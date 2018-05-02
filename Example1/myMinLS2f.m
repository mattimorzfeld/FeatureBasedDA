function [x,resnorm,residual,exitflag,output,lambda,jacobian]=myMinLS2f(xo,r,Rf,md,To,Te,Gap)
func=@(x)funcFf(x,r,Rf,md,To,Te,Gap);
options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt',...
    'Diagnostics','off','Jacobian','off','DerivativeCheck', 'off',...
    'Display','iter-detailed');
%     'Display','off');%,'iter-detailed');
ub = inf*ones(length(xo),1);
lb = -ub;
[x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(func,xo,lb,ub,options);


