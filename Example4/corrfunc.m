function out = corrfunc(x1,x2,s,L)
out = s^2*exp(-((x1-x2)/L)^2);