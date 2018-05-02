function [m,d]=Compute(xi,om,r,To,Te,Gap)
%% "Truth"
[yt,t]=model(xi,om,To,Te);
%% Get data
[td,d]=getData(yt,t,0,Gap);
%% Compute feature
m = CompFeature(d,td,To);

