function [td,d]=getData(y,t,r,Gap)
td = t(1:Gap:end);
d = y(1:Gap:end,1);
d = d+sqrt(r)*randn(size(d));
