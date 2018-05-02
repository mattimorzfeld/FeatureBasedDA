function xopt=myMinFeature(mu,Hd,Ld,T,dt,Rf)
func=@(x)loglikeFeature(x,Hd,Ld,T,dt,Rf);
options = optimoptions('fminunc','Algorithm','quasi-newton','GradObj','off','DerivativeCheck','off',...
     'Display','iter-detailed','MaxFunEvals',1000,'TolFun',1e-3,'TolX',1e-3);
xopt=  fminunc(func,mu,options);


