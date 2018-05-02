function [x,resnorm,residual,exitflag,output,lambda,jacobian]=myMinLS2(xo,r,d,To,Te,Gap,lb,ub)
func=@(x)funcF(x,r,d,To,Te,Gap);
options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt',...
    'Diagnostics','off','Jacobian','off','DerivativeCheck', 'off',...
    'Display','iter-detailed');
%     'Display','off');%,'iter-detailed');
ub = inf*ones(length(xo),1);
lb = -ub;
[x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(func,xo,lb,ub,options);


