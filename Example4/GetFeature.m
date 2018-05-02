
function [c,X,l,u,M] = GetFeature(a)
%% Get data
X = getData(a);
%% Process data
[c,l,u,M] = ProcessData(X);