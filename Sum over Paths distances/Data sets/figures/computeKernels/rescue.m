function kernel = rescue(dataset,algo,param,line)
% Recovers the execution of a kernel from a certain line

lambda = 1; %penalization cost of gaps
opcost = [1 1 1]; %insert, delete, do nothing

% Open file with sequences
cd '../dataset';
fid = fopen (dataset);
if (fid==-1)
	error('Cannot open %s',dataset);
end
sequences = [];
printf('Loading sequences in memory...\n');
fflush(stdout);

% Read sequences into a cell array structure
while((txt = fgetl(fid))!=-1)
	sequences=[sequences;txt];
end
fclose(fid);
cd '../computeKernels';
printf('OK\n');

% Load temporary kernel
res = load(["Temp_",algo,"_",mat2str(param)]);

%%%%%%%%%%%%%%%%%%% Calculation of distances %%%%%%%%%%%%%%%%

% Create a matrix to store the distances
nr = size(sequences,1);
nc = nr;

for i=line:nr
	s1 = sequences(i,:);
	printf('Run %d\n',i);
	fflush(stdout);
	for j=i:nc 
		s2 = sequences(j,:);
		switch (algorithm)
		case 'NRK'
			res = RspKernelNorm(s1,s2,param);
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
			p = minLength(s1,s2);
			res = GapAllSubsequence04(s1,s2,p,param);
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
		otherwise
			printf('Not a valid algorithm\n');
			fflush(stdout);
		endswitch	
		aux(i,j) = res;
		aux(j,i) = res;
	end
	%=== we store the intermidiate matrix ===
	save('-ascii',["Temp_",dataset,"_",algorithm,"_",mat2str(param)],'aux');
end

%%%%%%%%%%%%%%%%%%% Normalization and storage %%%%%%%%%%%%%%%%
e = ones(nr,1);
H = (eye(nr) - (e*e')/nr);

cd '../kernels';
switch (algorithm)

case 'RED'
ResRED = (-1/2)*H*ResRED*H;
D = diag(1./diag(ResRED)); 
ResRED = sqrt(D)*ResRED*sqrt(D); 
save('-ascii',["ResRED_",dataset,"_",mat2str(param)],'ResRED');
kernel = ResRED;

case 'RK'
ResRK = H*ResRK*H;
D = diag(1./diag(ResRK));
ResRK = sqrt(D)*ResRK*sqrt(D);
save('-ascii',["ResRK_",dataset,"_",mat2str(param)],'ResRK');
kernel = ResRK;

case 'NRK'
save('-ascii',["DisNRK_",dataset,"_",mat2str(param)],'ResNRK');
ResNRK = H*ResNRK*H;
D = diag(1./diag(ResNRK));
ResNRK = sqrt(D)*ResNRK*sqrt(D);
save('-ascii',["ResNRK_",dataset,"_",mat2str(param)],'ResNRK');
kernel = ResNRK;

case 'NRED'
save('-ascii',["DisNRED_",dataset,"_",mat2str(param)],'ResNRED');
ResNRED = (-1/2)*H*ResNRED*H;
D = diag(1./diag(ResNRED)); 
ResNRED = sqrt(D)*ResNRED*sqrt(D); 
save('-ascii',["ResNRED_",dataset,"_",mat2str(param)],'ResNRED');
kernel = ResNRED;

case 'AS'
ResAS = H*ResAS*H;
D = diag(1./diag(ResAS));
ResAS = sqrt(D)*ResAS*sqrt(D);
save('-ascii',["ResAS_",dataset],'ResAS');
kernel = ResAS;

case 'LED'
ResLED = (-1/2)*H*ResLED*H;
D = diag(1./diag(ResLED)); 
ResLED = sqrt(D)*ResLED*sqrt(D); 
save('-ascii',["ResLED_",dataset],'ResLED');
kernel = ResLED;

case 'LCS'
ResLCS = H*ResLCS*H; 
D = diag(1./diag(ResLCS));
ResLCS = sqrt(D)*ResLCS*sqrt(D);
save('-ascii',["ResLCS_",dataset],'ResLCS');
kernel = ResLCS;

case 'GAS'
ResGAS = H*ResGAS*H;
D = diag(1./diag(ResGAS));
ResGAS = sqrt(D)*ResGAS*sqrt(D);
save('-ascii',["ResGAS_",dataset,"_",mat2str(param)],'ResGAS');
kernel = ResGAS;

case 'PSPEC'
ResPSPEC = H*ResPSPEC*H;
D = diag(1./diag(ResPSPEC));
ResPSPEC = sqrt(D)*ResPSPEC*sqrt(D);
save('-ascii',["ResPSPEC_",dataset,"_",mat2str(param)],'ResPSPEC');
kernel = ResPSPEC;

case 'FL'
ResFL = H*ResFL*H;
D = diag(1./diag(ResFL));
ResFL = sqrt(D)*ResFL*sqrt(D);
save('-ascii',["ResFL_",dataset,"_",mat2str(param)],'ResFL');
kernel = ResFL;

endswitch
cd '../computeKernels';

return
