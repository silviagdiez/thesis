function kernel = computeKernel05(algorithm,sequences,data)
% Function that calculates the kernel for All Subsequences Kernel,
% Levenshtein Edit Distance, RSP Edit Distance and RSP Kernel given a dataset 
% "algorithm" > method to calculate distances

lambda = 1; %penalization cost of gaps
opcost = [1 1 1]; %insert, delete, do nothing

%=== Open file with sequences ===
%sequences = load('/stringSequencesBeatles.mat');
[nr,nc] = size(sequences)
printf('Loading sequences in memory...\n');
fflush(stdout);

%%%%%%%%%%%%%%%%%%% Calculation of distances %%%%%%%%%%%%%%%%

tic()
for i=1:nr
	v = find(sequences(i,:) == 0);
	endS1 = v(1)-1;
	s1 = sequences(i,1:endS1);
	printf('Run %d\n',i);
	fflush(stdout);
	for j=i:nr 
		v = find(sequences(j,:) == 0);
		endS2 = v(1)-1;
		s2 = sequences(j,1:endS2);
		switch (algorithm)
		case 'AS'
			res = AllSubsequence04(s1,s2);
			ResAS(i,j) = res;
			ResAS(j,i) = res;
		case 'LED'
			res = EditDist(s1,s2);
			ResLED(i,j) = res;
			ResLED(j,i) = res;
		case 'LCS'
			res = LongestCommonSubsequence04(s1,s2);
			ResLCS(i,j) = res;
			ResLCS(j,i) = res;
		otherwise
			printf('Not a valid algorithm\n');
			fflush(stdout);
		endswitch	
		aux(i,j) = res;
		aux(j,i) = res;
	end
end

toc()

%%%%%%%%%%%%%%%%%%% Normalization and storage %%%%%%%%%%%%%%%%
e = ones(nr,1);
H = (eye(nr) - (e*e')/nr);

switch (algorithm)

case 'AS'
save('-ascii',["ResAS_",data],'ResAS');
%ResAS = H*ResAS*H;
%D = diag(1./diag(ResAS));
%ResAS = sqrt(D)*ResAS*sqrt(D);
%save('-ascii',["NormAS_",data],'ResAS');
kernel = ResAS;

case 'LED'
save('-ascii',["ResLED_",data],'ResLED');
ResLED = (-1/2)*H*ResLED*H;
D = diag(1./diag(ResLED)); 
ResLED = sqrt(D)*ResLED*sqrt(D); 
save('-ascii',["NormLED_",data],'ResLED');
kernel = ResLED;

case 'LCS'
save('-ascii',["ResLCS_",data],'ResLCS');
ResLCS = H*ResLCS*H;
D = diag(1./diag(ResLCS)); 
ResLCS = sqrt(D)*ResLCS*sqrt(D); 
save('-ascii',["NormLCS_",data],'ResLCS');
kernel = ResLCS;

endswitch


return
