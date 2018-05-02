function m = CompFeature(d,td,To)
%% Steady state value
m(1) = sqrt(1/mean(d(end-50:end)));

ind = find(td==To);
inds = ind+(0:7);
df = log(1+d(inds));
tf = td(inds);
A = [ones(length(df),1) tf'];
params = A\df;
m(2) = params(2);
