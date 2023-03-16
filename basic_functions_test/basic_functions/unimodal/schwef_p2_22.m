function [y] = schwef_p2_22(xx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   x_i=[-10,10] for all x1.x2,x3,...,xd
%   Global f_min = 0
%   xx = (x1,x2,x3,...,xd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = length(xx);
sum1 = 0;
sum2 = 0;
for i = 1:d
   sum1 = sum1 + abs(xx(i));
   sum2 = sum2 * abs(xx(i));
end
y = sum1 + sum2;

end

