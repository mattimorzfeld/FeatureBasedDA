function [xopt,fopt]=MinimizeLogLikelihood(L,sig,s,mu,bounds,Fs,H,dx,n)
fun = @(x)LogLikelihood(x,Fs,H,dx,n);

% options = optimoptions('fmincon');
% options = optimoptions(@fmincon,'Display','Iter-Detailed');

lb = bounds(:,1)';
ub = bounds(:,2)';
A = [];
b = [];
Aeq = [];
beq = [];
x0 = [L,sig,s,mu];
[xopt,fopt] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub);%,[],options);






