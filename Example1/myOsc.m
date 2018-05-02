function dy = myOsc(t,y,xi,om,T)

% xi = .1;
% om = 1;

dy = zeros(2,1);
dy(1) = y(2);
if t>=T
    dy(2) = -2*xi*om*y(2) - om^2*y(1)+1;
else
    dy(2) = -2*xi*om*y(2) - om^2*y(1);
end