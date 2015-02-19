function kernel = computeKernel05(algorithm,dataset,param)
% Function that calculates the kernel for All Subsequences Kernel,
% Levenshtein Edit Distance, RSP Edit Distance and RSP Kernel given a dataset 
% "dataset" > dataset
% "algorithm" > method to calculate distances
% "param" > theta for RSP Edit Distance and RSP Kernel
% "param" > lambda for GapWeightedSubsequence Kernel

lambda = 1; %penalization cost of gaps
opcost = [1 1 1]; %insert, delete, do nothing

% Open file with sequences
cd '../datasets';
fid = fopen (dataset);
if (fid==-1)
	error('Cannot open %s',dataset);
end
printf('Loading sequences in memory...\n');
fflush(stdout);

% Read sequences into a cell array structure
i = 1;
while((txt = fgetl(fid))!=-1)
	sequences{i} = txt;
	i++;
end
fclose(fid);
cd '../computeKernels';
printf('OK\n');

%%%%%%%%%%%%%%%%%%% Calculation of distances %%%%%%%%%%%%%%%%

% Create a matrix to store the distances
nr = size(sequences,2);
nc = nr;

tic()

for i=1:nr
	s1 = sequences{i};
	printf('Run %d\n',i);
	fflush(stdout);
	for j=i:nc 
		
		s2 = sequences{j};
		switch (algorithm)
		case 'NRK'
			res = RspKernelNormLog(s1,s2,param);
			ResNRK(i,j) = res;
			ResNRK(j,i) = res;
		case 'NRED'
			res = RspEditDistNormLog(s1,s2,param);
			ResNRED(i,j) = res;
			ResNRED(j,i) = res;
		case 'RED'
			res = RspEditDistLog(s1,s2,param);
			ResRED(i,j) = res;
			ResRED(j,i) = res;
		case 'RK'
			res = RspKernelLog(s1,s2,param);
			ResRK(i,j) = res;
			ResRK(j,i) = res;
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
		case 'GAS'
			l1 = length(s1);
			l2 = length(s2);
			p = min(l1,l2);
			res = GapAllSubsequence06Log(s1,s2,p,param);
			ResGAS(i,j) = res;
			ResGAS(j,i) = res;
		case 'PSPEC'
			res = GapAllSubsequence03(s1,s2,param,0.00001);
			ResPSPEC(i,j) = res;
			ResPSPEC(j,i) = res;
		case 'FL'
			res = GapAllSubsequence03(s1,s2,param,1);
			ResFL(i,j) = res;
			ResFL(j,i) = res;
		case 'SED'			
			res = StochasticEditDistLog03(s1,s2,param);
			ResSED(i,j) = res;
			ResSED(j,i) = res;
		otherwise
			printf('Not a valid algorithm\n');
			fflush(stdout);
		endswitch	
		aux(i,j) = res;
		aux(j,i) = res;
	end
	%=== we store the intermmediate matrix ===
    cd '../kernels';
    save('-ascii',["Temp_",dataset,"_",algorithm,"_",mat2str(param)],'aux');
    cd '../computeKernels';

end

toc()

%%%%%%%%%%%%%%%%%%% Normalization and storage %%%%%%%%%%%%%%%%
e = ones(nr,1);
H = (eye(nr) - (e*e')/nr);

cd '../kernels';
switch (algorithm)

case 'RED'
save('-ascii',["ResRED_",dataset,"_",mat2str(param)],'ResRED');
ResRED = (-1/2)*H*ResRED*H;
D = diag(1./diag(ResRED)); 
ResRED = sqrt(D)*ResRED*sqrt(D); 
cd '../normKernels';
save('-ascii',["ResRED_",dataset,"_",mat2str(param)],'ResRED');
kernel = ResRED;

case 'RK'
save('-ascii',["ResRK_",dataset,"_",mat2str(param)],'ResRK');
ResRK = H*ResRK*H;
D = diag(1./diag(ResRK));
ResRK = sqrt(D)*ResRK*sqrt(D);
cd '../normKernels';
save('-ascii',["ResRK_",dataset,"_",mat2str(param)],'ResRK');
kernel = ResRK;

case 'NRK'
save('-ascii',["ResNRK_",dataset,"_",mat2str(param)],'ResNRK');
ResNRK = H*ResNRK*H;
D = diag(1./diag(ResNRK));
ResNRK = sqrt(D)*ResNRK*sqrt(D);
cd '../normKernels';
save('-ascii',["ResNRK_",dataset,"_",mat2str(param)],'ResNRK');
kernel = ResNRK;

case 'NRED'
save('-ascii',["ResNRED_",dataset,"_",mat2str(param)],'ResNRED');
ResNRED = (-1/2)*H*ResNRED*H;
D = diag(1./diag(ResNRED)); 
ResNRED = sqrt(D)*ResNRED*sqrt(D); 
cd '../normKernels';
save('-ascii',["ResNRED_",dataset,"_",mat2str(param)],'ResNRED');
kernel = ResNRED;

case 'AS'
save('-ascii',["ResAS_",dataset],'ResAS');
ResAS = H*ResAS*H;
D = diag(1./diag(ResAS));
ResAS = sqrt(D)*ResAS*sqrt(D);
cd '../normKernels';
save('-ascii',["ResAS_",dataset],'ResAS');
kernel = ResAS;

case 'LED'
save('-ascii',["ResLED_",dataset],'ResLED');
ResLED = (-1/2)*H*ResLED*H;
D = diag(1./diag(ResLED)); 
ResLED = sqrt(D)*ResLED*sqrt(D); 
cd '../normKernels';
save('-ascii',["ResLED_",dataset],'ResLED');
kernel = ResLED;

case 'LCS'
save('-ascii',["ResLCS_",dataset],'ResLCS');
ResLCS = H*ResLCS*H; 
D = diag(1./diag(ResLCS));
ResLCS = sqrt(D)*ResLCS*sqrt(D);
cd '../normKernels';
save('-ascii',["ResLCS_",dataset],'ResLCS');
kernel = ResLCS;

case 'GAS'
save('-ascii',["ResGAS_",dataset,"_",mat2str(param)],'ResGAS');
ResGAS = H*ResGAS*H;
D = diag(1./diag(ResGAS));
ResGAS = sqrt(D)*ResGAS*sqrt(D);
cd '../normKernels';
save('-ascii',["ResGAS_",dataset,"_",mat2str(param)],'ResGAS');
kernel = ResGAS;

case 'PSPEC'
save('-ascii',["ResPSPEC_",dataset,"_",mat2str(param)],'ResPSPEC');
ResPSPEC = H*ResPSPEC*H;
D = diag(1./diag(ResPSPEC));
ResPSPEC = sqrt(D)*ResPSPEC*sqrt(D);
cd '../normKernels';
save('-ascii',["ResPSPEC_",dataset,"_",mat2str(param)],'ResPSPEC');
kernel = ResPSPEC;

case 'FL'
save('-ascii',["ResFL_",dataset,"_",mat2str(param)],'ResFL');
ResFL = H*ResFL*H;
D = diag(1./diag(ResFL));
ResFL = sqrt(D)*ResFL*sqrt(D);
cd '../normKernels';
save('-ascii',["ResFL_",dataset,"_",mat2str(param)],'ResFL');
kernel = ResFL;

case 'SED'
save('-ascii',["ResSED_",dataset,"_",mat2str(param)],'ResSED');
ResSED = (-1/2)*H*ResSED*H;
D = diag(1./diag(ResSED)); 
ResSED = sqrt(D)*ResSED*sqrt(D); 
cd '../normKernels';
save('-ascii',["ResSED_",dataset,"_",mat2str(param)],'ResSED');
kernel = ResSED;

endswitch
cd '../computeKernels';

return
