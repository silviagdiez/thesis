function m = externalNNnorm(algo,dataset)
% Function that calculates the Nearest Neighbor of
% two sequences to the given classes
% "dataset" > dataset
% "algo" > method to calculate distances

tic();

nbruns = 10;

%=== Tested values for K ===
ks = 1;

%=== Tested values for the seed ===
seeds = 14111981:14111990;

%======================== Open file with sequences =================================================
if (strcmp(algo,'NRK') || strcmp(algo,'NRED') || strcmp(algo,'RK') || strcmp(algo,'RED'))
	%=== Tested values of the hyperparameter ===
	ps = repmat([0.1 0.5 1 1.5 2 2.5 3 3.5 4],1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)	
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end	
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end	
elseif (strcmp(algo,'GAS'))
	%=== Tested values of the hyperparameter ===
	ps = repmat([0.2 0.4 0.5 0.6 0.8],1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)	
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)	
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
elseif (strcmp(algo,'PSPEC') || strcmp(algo,'FL'))
	%=== Tested values of the hyperparameter ===
	ps = repmat([5 10 15 20],1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)		
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
elseif (strcmp(algo,'AS') || strcmp(algo,'LED') || strcmp(algo,'LCS'))
	%=== Tested values of the hyperparameter ===
	ps = repmat(1,1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)	
		param = ps(i);
		["Res",algo,"_",dataset]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset]);
	end
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)
		param = ps(i);
		["Res",algo,"_",dataset]
		kernels{i} = load('-ascii',["Res",algo,"_",dataset]);
	end
elseif strcmp(algo,'KD')
        %=== Tested values of the hyperparameter ===
        ps = repmat(1,1,2);
        cd '../kernels';
        for i=1:(length(ps)/2)
                param = ps(i);
                ["Res",algo,"_",dataset]
                kernels{i} = load(["Res",algo,"_",dataset]);
        end
        cd '../normKernels';
        for i=((length(ps)/2)+1):length(ps)
                param = ps(i);
                ["Res",algo,"_",dataset]
                kernels{i} = load(["Res",algo,"_",dataset]);
        end
elseif strcmp(algo,'SED')
   		%=== Tested values of the hyperparameter ===
		ps = repmat([0.05 0.1 0.15 0.2 0.25],1,2);
		cd '../kernels';
		for i=1:(length(ps)/2)		
			param = ps(i);
			["Res",algo,"_",dataset,"_",mat2str(param)]
			kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
		end
		cd '../normKernels';
		for i=((length(ps)/2)+1):length(ps)
			param = ps(i);
			["Res",algo,"_",dataset,"_",mat2str(param)]
			kernels{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
		end
end
cd '../ClassificationNNPnorm';

%=== Class variables ===
if strcmp(dataset,'arrows')
	s = [256 252 245 257]; % THIS IS THE RIGHT DISTRIBUTION
elseif strcmp(dataset,'digits')
	s = repmat(100,1,10);
elseif strcmp(dataset,'figures')
	s = repmat(100,1,5);
elseif strcmp(dataset,'letters')
	s = repmat(80,1,13);
elseif strcmp(dataset,'sequences')
    s = repmat(50,1,5);
end
n = sum(s); 
nclass = length(s);
ini = 1;
fin = 0;
for i=1:nclass
	fin = fin + s(i);
	class(ini:fin) = i;
	ini = ini + s(i);
end

%=== We set the random seed ===
for sIndex=1:length(seeds)
	rand('seed',seeds(sIndex));


%============= We partition the whole data set into #nbruns disjoint sets ==========================
perm = 1:nbruns;
perm = repmat(perm,1,floor(sum(s)/nbruns));
perm = [perm 1:sum(s)-(nbruns*floor(sum(s)/nbruns))];

%======================= We start the nested Cross-validation ======================================
for i=1:nbruns
	
	%=== We keep Ti as test set for this fold ===
	data = 1:sum(s);
	test = data(perm == i);
	testClass = class(test);
	train = data(perm != i);
	trainClass = class(train);
	
	%=== we call the nested loop for getting the best theta ===
	for j=1:length(ps)
		Ktest{j} = kernels{j}(test,train);
		Ktrain{j} = kernels{j}(train,train);
	end
	optP = internalNN(Ktrain,ps,algo,trainClass,nclass);
	
	%=== we choose one prototype for each class ===
	prototypes = randperm(length(trainClass));
	classPrototypes = trainClass(prototypes);
	for j=1:nclass
		k = 1;
		while (classPrototypes(k) != j)
			k++;
		end
		p(j) = prototypes(k);
	end
	
	%=== we classify with k-NN each observation of Ti ===
	res = [];	
	for j=1:length(test)
	
		%=== we look for the k nearest neighbors ===
		for k=1:nclass
			dist(k) = Ktest{optP}(j,p(k));
		end
		
		%=== we find out if its a normalized kernel or not ===
		if optP <= (length(ps)/2)
			nor = 0;
		else
			nor = 1;
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
		res(j) = b;
	end
	
	%=== we compute the classification rate for this fold and this k ===
	nbCorrect(sIndex,i) = sum(res == testClass)*100/length(test);
			
end

end %=== of the random seed ===

printf("========= out ===========\n");

nbCorrect

%=== store results ===
cd '../resultsNNP';
save('-ascii',["NC_",algo,"_",dataset],'nbCorrect');
%=== we keep track of the script that generated the results ===
info{1} = date();
info{2} = pwd();
info{3} = [mat2str(localtime(time()).hour),":",mat2str(localtime(time()).min)];
info{4} = ["Elapsed time: ",mat2str(toc())];
save(["Info_",algo,"_",dataset],'info');
cd '../ClassificationNNPnorm';


return












