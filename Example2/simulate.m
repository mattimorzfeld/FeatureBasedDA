function [t,H,L] = simulate(theta,xo,T,dt)
[t,y] =ode15s(@lv,[0:dt:T],xo,' ',theta);
H = y(:,1);
L = y(:,2);
