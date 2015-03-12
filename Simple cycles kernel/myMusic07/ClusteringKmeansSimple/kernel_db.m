function [newClass,J] = kernel_db(K,nb_cl)
% K-means Clustering
%
% "K" > kernel matrix
% "nb_cl" > number of clusters
% "Kinv"(optional) > inverse of K for kernel L+
%
% Classe > vector that contains the class of each point
% Rindex > RAND index of found clustering
%
% Authors: L. Yen & S. Garcia
%

% maximum number of iterations
MaxIters=100;
% small value that avoids 1/0
epsilon = 1e-6;

[nb_data,m] = size(K);
if nb_data ~= m
    error('non-squared matrix!');
end

%=== intra-class inertia vector ===
J = [];

%=== we take random prototypes at first (gravity center matrix) ===
I = randperm(nb_data);
for i=1:nb_cl
	p(i) = I(i);
end
p = sort(p);
dif = ones(1,nb_cl);
niter = 1;

%K
while (sum(dif) > 0.01) && (niter < MaxIters)
	
	%=== reallocation step (assign a class to each observation according to prototype distance) ===
	newClass = [];
	for i=1:nb_data % for each point
		for j=1:nb_cl % for each prototype
			dist(j) = K(i,p(j));
		end
		%dist
		[val,pos] = min(dist);
		newClass = [newClass pos];
	end
	%newClass
	%=== recentering step (compute the intra-class inertia) ===
	Jaux = 0;
	for i=1:nb_cl % for each cluster
		for j=1:nb_data
			if (newClass(j) == i)
				Jaux = Jaux + K(j,p(i));
			end
		end
	end
	J = [J; Jaux];
	%=== recentering step (find the new prototypes) ===
	for i=1:nb_data % for each point
		class = newClass(i);
		distPrototype(i) = sum(K(i,newClass == class));
	end
	%distPrototype

	pNew = zeros(1,nb_cl);
	mins = repmat(realmax,1,nb_cl);
	for i=1:nb_data
		class = newClass(i);
		%distPrototype(i)
		%mins(class)
		if distPrototype(i) < mins(class)
			mins(class) = distPrototype(i);
			pNew(class) = i;
		end
	end
	pNew = sort(pNew);
	%=== computation of the distance between the prototypes ===
	dif = sum(abs(p-pNew));
	p = pNew;
	
	b = find(p == 0);
	if !isempty(b)
		newClass = [];
		J = realmax;
		return;
	end
	p = sort(p);
	niter++;
end

return;  
    
    