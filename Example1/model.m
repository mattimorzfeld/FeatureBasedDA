function [y,t]=model(xi,om,To,Te)
t = 0:.1:Te;
[~,Y] = ode45(@myOsc,t,[0;0], ' ',xi,om,To);
y = Y(:,1);%+1;
