function [x, bins]=whist(x,w,nbins)
xl = min(x);
xr =max(x);
dx = (xr-xl)/nbins;
bins = zeros(nbins+1,1);
for kk=1:length(x)
    index = floor((x(kk)-xl)/dx)+1;
    bins(index) = bins(index)+w(kk);
end
bins = bins/dx;
x = xl+dx/2:dx:xr+dx/2;
end