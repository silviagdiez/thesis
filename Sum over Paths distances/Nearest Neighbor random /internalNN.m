function p = internalNN(kernels,ps,algo,class,nclass)
% Internal loop of k-NN where it computes
% the best value of k
% "kernel" > kernel
% "ps" > tested values of parameters
% "class" > classes of observations

%=== Number of times we perform the k-NN ===
nbruns = 10;

%=== We partition the whole data set into #nbruns disjoint sets ===
perm = 1:nbruns;
perm = repmat(perm,1,floor(length(class)/nbruns));
perm = [perm 1:length(class)-(nbruns*floor(length(class)/nbruns))];

%=== We start the nested Cross-validation (for each parameter k) ===
for i=1:length(ps)

	%=== we find out if its a normalized kernel or not ===
	if i <= (length(ps)/2)
		nor = 0;
	else
		nor = 1;
	end
	
	%=== we load the right kernel ===
	kernel = kernels{i};
	
	%=== we perform the validation #nbruns ===
	for j=1:nbruns	
	
		%=== We keep Ti as test set for this fold ===
		data = 1:length(class);
		test = data(perm == j);
		testClass = class(test);
		train = data(perm != j);
		trainClass = class(train);
		
		%=== we choose one prototype for each class ===
		prototypes = randperm(length(trainClass));
		classPrototypes = trainClass(prototypes);
		for l=1:nclass
			k = 1;
			while (classPrototypes(k) != l)
				k++;
			end
			p(l) = prototypes(k);
		end
		
		K = kernel(test,train);
	
		%=== we classify with k-NN each observation of Ti ===
		res = [];
		for l=1:length(test)
			%=== we look for the k nearest neighbors ===
			for k=1:nclass
				dist(k) = K(l,p(k));
			end
		
			if nor == 0
				if strcmp(algo,'NRED') || strcmp(algo,'RED') || strcmp(algo,'LED') || strcmp(algo,'SED')
					[a,b] = min(dist);
				else
					[a,b] = max(dist);
				end
			else
				[a,b] = max(dist);
			end
			%=== we add the class to the solution vector ===
			res(l) = b;
		end
		
		%=== we compute the classification rate for this fold and this k ===
		nbCorrect(i,j) = sum(res == testClass)*100/length(test);
	
	end
end

[a,b] = max(sum(nbCorrect,2));
p = b;


return
