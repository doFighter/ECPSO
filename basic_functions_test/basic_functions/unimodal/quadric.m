function [y] = quadric(xx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   x_i=[-100,100] for all x1,x2,x3,...,xd
%   Global f:0
%   X=(x1,x2,...,xi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = length(xx);
sum = 0;
for i = 1:d
    inerSum = 0;
    for j = 1:i
        inerSum = inerSum + xx(j);
    end
    sum = sum + inerSum^2;
end
y = sum;
end

