function [inds,EI] = compEI(x,Fs,mu,C)
disp('Running EI')
fs = max(Fs);
EI = zeros(length(x),1);
for oo=1:length(x)
    m = mu(oo)-fs;
    sig = sqrt(C(oo,oo));
    pd = makedist('Normal',m,sig);
    EI(oo) = m*cdf(pd,m/sig) ...
        +sig*pdf(pd,m/sig);
end
[vals,Inds] = findpeaks(EI);

maxval = max(vals);
counter = 1;
for kk=1:length(vals)
    if vals(kk)/maxval > 0.3
        inds(counter) = Inds(kk);
        counter = counter +1;
    end
end

