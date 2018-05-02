function p = SetParams(alpha)
%% Equation parameters
p.beta = 1;
p.gamma =1;

%% Simulation parameters
p.dt = 0.005/abs(alpha);
p.Lx = 10*pi;
p.Ly=p.Lx;
p.Nx=2^8;
p.Ny=2^8;
p.rmax = 1;

%% Data collecting parameters
p.kmax=50; % take a snapshot every kmax steps
p.maxSteps = 2500; % how many steps to simulate
p.nos = 100; % how many samples do I want