function out = lv(t,x,theta)
out = [theta(1)*x(1) - theta(2)*x(1)*x(2);
         -theta(3)*x(2)+theta(4)*x(1)*x(2)]; 