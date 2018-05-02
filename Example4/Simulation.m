function X = Simulation(alpha,p)

beta = p.beta;
gamma = p.gamma;
dt = p.dt;
Lx =p.Lx;
Ly = p.Ly;
Nx = p.Nx;
Ny = p.Ny;
rmax = p.rmax;

kmax = p.kmax;
maxSteps = p.maxSteps;


%% Define Matrices
[~,NL,expL,kx,ky]=getSysMatrices(Nx,Ny,Lx,Ly,alpha,beta,dt);

%% Initial condition
[~,psi1,psin1] = getIC(Nx,gamma,kx,ky); 


%% pre-allocate
nos = 100;
X = zeros(Nx*Ny,nos);

counter = 1;
for j = 1:maxSteps
    psi0 = expL .* psi1 + NL .* psin1;
    if  sum(sum(isnan(psi0)))>1
        break
    end
    if mod(j,kmax)==1 && j>1000
        X(:,counter) = reshape(real(ifft2(psi0)),Nx*Ny,1);
        counter = counter +1;
        if counter >nos
            break
        end
    end
    drawnow
    psin1 = -gamma*fft2((ifft2(1i*psi0.*kx)).^2+(ifft2(1i*psi0.*ky)).^2);
    psi1 = psi0;
    psi1(1,1)=0.0+1i*0.0;
end
X = X(:,1:counter-2); % delete zeros