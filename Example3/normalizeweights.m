function out = normalizeweights(w)
w = w-min(w); 
w = exp(-w); 
out = w/sum(w);