function X = SampleGaussianBounds(nos,lb,ub,m,s)
X = zeros(nos,1);
for kk=1:nos
    ok = 0;
    while ok == 0
        tmp = m+s*randn;
        if tmp>lb && tmp<ub
            X(kk) = tmp;
            ok = 1;
        end
    end
end