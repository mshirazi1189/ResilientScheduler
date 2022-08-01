function generateSurprises()

global Rates;
global PredictedRates;
global EpsilonMax;
global Surprises;

Surprises = [25:25:300];

PredictedRates = Rates;
for j=1:size(Surprises, 2)
    k = Surprises(j);
    Rates(k) = ceil((1-EpsilonMax)*PredictedRates(k));
end

end