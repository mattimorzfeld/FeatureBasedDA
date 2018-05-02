function w = normalizeWeights(w)

w = w - min(w);  
w = exp(-w); 
w = w/sum(w);