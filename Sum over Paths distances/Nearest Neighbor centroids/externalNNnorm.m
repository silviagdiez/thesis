function m = externalNNnorm(algo,dataset)
% Function that calculates the Nearest Neighbor of
% two sequences to the center of gravity of a given class
% "dataset" > dataset
% "algo" > method to calculate distances

tic();

%=== Number of times we perform the k-NN ===
nbruns = 10;

%=== Tested values for K ===
ks = 1;

%======================== Open file with sequences =================================================
if (strcmp(algo,'NRK') || strcmp(algo,'NRED') || strcmp(algo,'RK'))
	%=== Tested values of the hyperparameter ===
	ps = repmat([0.1 0.5 1 1.5 2 2.5 3 3.5 4],1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)	
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end	
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end	
elseif (strcmp(algo,'RED'))
	%=== As RED is a distance we have to ALWAYS center it ===
	ps = repmat([0.1 0.5 1 1.5 2 2.5 3 3.5 4],1,2);
	cd '../kernels';
	for i=1:length(ps)	
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		aux = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
		[nr,nc] = size(aux);
		e = ones(nr,1);
		H = (eye(nr) - (e*e')/nr);
		Res{i} = (-1/2)*H*aux*H;
	end	
elseif (strcmp(algo,'GAS'))
	%=== Tested values of the hyperparameter ===
	ps = repmat([0.2 0.4 0.5 0.6 0.8],1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)	
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)	
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
elseif (strcmp(algo,'PSPEC') || strcmp(algo,'FL'))
	%=== Tested values of the hyperparameter ===
	ps = repmat([5 10 15 20],1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)		
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)
		param = ps(i);
		["Res",algo,"_",dataset,"_",mat2str(param)]
		Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
	end
elseif (strcmp(algo,'LED'))
	%=== As LED is a distance we ALWAYS have to center it ===
	ps = repmat(1,1,2);
	cd '../kernels';
	for i=1:(length(ps))	
		param = ps(i);
		["Res",algo,"_",dataset]
		aux = load('-ascii',["Res",algo,"_",dataset]);
		[nr,nc] = size(aux);
		e = ones(nr,1);
		H = (eye(nr) - (e*e')/nr);
		Res{i} = (-1/2)*H*aux*H;
	end
elseif (strcmp(algo,'AS') || strcmp(algo,'LCS'))
	%=== Tested values of the hyperparameter ===
	ps = repmat(1,1,2);
	cd '../kernels';
	for i=1:(length(ps)/2)	
		param = ps(i);
		["Res",algo,"_",dataset]
		Res{i} = load('-ascii',["Res",algo,"_",dataset]);
	end
	cd '../normKernels';
	for i=((length(ps)/2)+1):length(ps)
		param = ps(i);
		["Res",algo,"_",dataset]
		Res{i} = load('-ascii',["Res",algo,"_",dataset]);
	end
elseif strcmp(algo,'KD')
        %=== Tested values of the hyperparameter ===
        ps = repmat(1,1,2);
        cd '../kernels';
        for i=1:(length(ps)/2)
                param = ps(i);
                ["Res",algo,"_",dataset]
                Res{i} = load(["Res",algo,"_",dataset]);
        end
        cd '../normKernels';
        for i=((length(ps)/2)+1):length(ps)
                param = ps(i);
                ["Res",algo,"_",dataset]
                Res{i} = load(["Res",algo,"_",dataset]);
        end
elseif strcmp(algo,'SED')
   		%=== Tested values of the hyperparameter ===
		ps = repmat([0.05 0.1 0.15 0.2 0.25],1,2);
		cd '../kernels';
		for i=1:(length(ps)/2)		
			param = ps(i);
			["Res",algo,"_",dataset,"_",mat2str(param)]
			Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
		end
		cd '../normKernels';
		for i=((length(ps)/2)+1):length(ps)
			param = ps(i);
			["Res",algo,"_",dataset,"_",mat2str(param)]
			Res{i} = load('-ascii',["Res",algo,"_",dataset,"_",mat2str(param)]);
		end
end
cd '../ClassificationNNGnorm';

%=================================== Class vector ==================================================
if strcmp(dataset,'arrows')
	s = [256 253 245 256]
elseif strcmp(dataset,'digits')
	s = repmat(100,1,10)
elseif strcmp(dataset,'figures')
	s = repmat(100,1,5)
elseif strcmp(dataset,'letters')
	s = repmat(80,1,13)
elseif strcmp(dataset,'sequences')
        s = repmat(50,1,5)
end
nclass = length(s);
ini = 1;
fin = 0;
for i=1:nclass
	fin = fin + s(i);
	clas(ini:fin) = i;
	ini = ini + s(i);
end

%=== We set the random seed ===
rand('seed',14111981);

%============= We partition the whole data set into #nbruns disjoint sets ==========================
perm = 1:nbruns;
perm = repmat(perm,1,floor(sum(s)/nbruns));
perm = [perm 1:sum(s)-(nbruns*floor(sum(s)/nbruns))];

%======================= We start the nested Cross-validation ======================================
for i=1:nbruns
	
	%=== We keep Ti as test set for this fold ===
	data = 1:sum(s);
	test = data(perm == i);
	testClass = clas(test);
	train = data(perm != i);
	trainClass = clas(train);
	
	%=== we call the nested loop for getting the best theta ===
	for j=1:length(ps)
		Ktest{j} = Res{j}(test,train);
		Ktrain{j} = Res{j}(train,train);
		Kself{j} = diag(Res{j}(test,test))';
	end
	optP = internalNN(Ktrain,ps,trainClass,algo);
	
	%=== we find out if its a normalized kernel or not ===
	if optP <= (length(ps)/2)
		nor = 0;
	else
		nor = 1;
	end
	
	%=== we find the distance of each cluster observation to the gravity center ===
	distances = gravityDistance(Ktrain{optP},Ktest{optP},Kself{optP},trainClass);
		
	%=== we classify with k-NN each observation of Ti ===
	res = [];
	for j=1:length(test)
		%=== we look for the k nearest neighbors ===
		dist = distances(:,j)';
		
		if nor == 0
			if strcmp(algo,'NRED') || strcmp(algo,'RED') || strcmp(algo,'LED') || strcmp(algo,'SED')
				[a,b] = min(dist);
				%[a,b] = max(dist);
			else
				%[a,b] = max(dist);
				[a,b] = min(dist);
			end
		else
			%[a,b] = max(dist);
			[a,b] = min(dist);
		end
		%=== we add the class to the solution vector ===
		res(j) = b;
	end
	
	%=== we compute the classification rate for this fold and this k ===
	nbCorrect(i) = sum(res == testClass)*100/length(test)
			
end

printf("========= out4 ===========\n");

%=== mean ===
m = mean(nbCorrect)

%=== result storage ====
cd '../resultsNNG';
save('-ascii',["Mean_",algo,"_",dataset],'m');
save('-ascii',["NC_",algo,"_",dataset],'nbCorrect');
%csvwrite(["Mean_",algo,"_",dataset,'.csv'],m);
%dlmwrite(["NC_",algo,"_",dataset],nbCorrect);
%=== we keep track of the script that generated the results ===
info{1} = date();
info{2} = pwd();
info{3} = [mat2str(localtime(time()).hour),":",mat2str(localtime(time()).min)];
info{4} = ["Elapsed time: ",mat2str(toc())];
save(["Info_",algo,"_",dataset],'info');
cd '../ClassificationNNGnorm';

return
