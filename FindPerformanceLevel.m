function [pl] = FindPerformanceLevel(IE, Rate, EC, ECatPerformanceLevels)

global L;
global log_file;

max_pl = -1;
for l=L:-1:1
    if ECatPerformanceLevels(l, 1) <= EC
        max_pl = l;
        break;
    end
end

pl = -1;
for l=max_pl:-1:1
    if schedulabilityTest(IE, Rate, l)
        pl = l;
        break;
    end
end

if pl == -1
    fprintf(log_file, 'The pl is -1.');
end

end