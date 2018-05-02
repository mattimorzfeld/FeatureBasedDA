function out = funcF(x,r,d,To,Te,Gap)
xi = x(1);
om = x(2);
%% "Truth"
[yt,t]=model(xi,om,To,Te);
%% Get data
[td,dm]=getData(yt,t,0,Gap);
out = (1/sqrt(2*r))*(d-dm);