function X = getData(alpha)
%% Set simulation parameters
p = SetParams(alpha);

nsamples = 0;
X = zeros(p.Nx^2,p.nos);
while nsamples < p.nos
%     fprintf('currently have %g samples\n',nsamples)
    % Solve PDE
    x = Simulation(alpha,p);
    if nsamples+size(x,2)>p.nos
        X(:,nsamples:end) =  x(:,1:p.nos-nsamples+1);
    else
        X(:,nsamples+(1:size(x,2))) =  x;
    end
    nsamples = nsamples+size(x,2);
end