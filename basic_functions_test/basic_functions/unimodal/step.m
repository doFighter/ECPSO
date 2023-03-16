function [y] = step(xx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   x_i = [-100,100] for all x1,x2,x3,...,xd
%   Global f_min = 0 
%   xx = (x1,x2,...,xd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = length(xx);
sum = 0;
for i = 1:d
   sum = sum + (floor(xx(i) + 0.5))^2;
end
y = sum;

end

