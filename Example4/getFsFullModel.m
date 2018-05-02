function funcF = getFsFullModel(z,x,r)
for kk=1:length(x)
    fprintf('Evaluating %g/%g\n',kk,length(x))
    [zt,~,~,~,~] = GetFeature(x(kk));
    funcF(kk) = exp(-norm((r*[9;.25].^2).\(z-zt))^2/2);
end
