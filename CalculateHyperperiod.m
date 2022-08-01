function [hp]=CalculateHyperperiod(x)
m = x(1);
for i=2:length(x)
    r=x(i);
    for j=1:m
        if(rem(m, j)==0 && rem(r, j)==0)
            g=j;
        end
    end
    m=(r*m)/g;
end
hp = m;
