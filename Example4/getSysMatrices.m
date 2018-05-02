function [L,NL,expL,kx,ky]=getSysMatrices(Nx,Ny,Lx,Ly,alpha,beta,dt)
t1 = 0:1:Nx-1;
t2 = 0:1:Ny-1;
[T1,T2]=meshgrid(t1,t2);
[kx,ky]=meshgrid(t1,t2);
kx(1:Ny,1:Nx/2+1)=2*pi/Lx*T1(1:Ny,1:Nx/2+1);
kx(1:Ny,Nx/2+2:Nx)=2*pi/Lx*(T1(1:Ny,Nx/2+2:Nx)-Nx);
ky(1:Ny/2+1,1:Nx)=2*pi/Ly*T2(1:Ny/2+1,1:Nx);
ky(Ny/2+2:Ny,1:Nx)=2*pi/Ly*(T2(Ny/2+2:Ny,1:Nx)-Ny);
L=-alpha*(kx.^2+ky.^2)-beta*(kx.^2+ ky.^2).^2;
expL = exp(L*dt);
NL = zeros(Ny,Nx);
for j = 1:Ny
    for jj = 1:Nx
        if abs(L(j,jj))< 0.000001
            NL(j,jj) = dt;
        else
            NL(j,jj) = (exp(L(j,jj)*dt)-1)/L(j,jj);
        end
    end
end