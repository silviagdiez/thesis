function searchOptTheta(dataset,algorithm,thetas,nclass)
% Function that calculates the optimal theta for a certain method
% given a dataset (default 014)
% "dataset" > dataset
% "algorithm" > method to calculate distances
% "thetas" > values of theta among which find the optimal
% "nclass" > number of different classes

[r,c] = size(thetas);
classif = zeros(1,c);
randIndex = zeros(1,c);

for k=1:c % for each theta

theta = thetas(k);

% Calculation of optimal theta CLUSTERING 
[r1,r2] = computeClustering(dataset,algorithm,theta,nclass)

classif(1,k) = r1;
randIndex(1,k) = r2;

end % end for each theta

results = zeros(c,3);
results(:,1) = thetas';
results(:,2) = classif';
results(:,3) = randIndex';
cd 'results';
save('-ascii',["Res",algorithm,"_optimalTheta"],'results');
cd '..';

return
