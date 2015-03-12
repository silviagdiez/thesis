function kernel = computeRandData(dataset,nsec)
% Function that creates a dataset from a random subset of a bigger 
% given dataset
% "dataset" > dataset
% "nsec" > number of observations of each digit

% Open file with sequences
cd 'datasets';
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
printf('OK\n');

% Take random elements of dataset
block = length(sequences)/10
perm = randperm(block)
seq28 = [];
seq37 = [];
seq257 = [];
seq678 = [];
seq014 = [];

for i=1:10
	seqaux = [];
	ini = ((i-1)*block)+1;
	fin = i*block;
	seqaux = sequences(ini:fin,:);
	seqaux = seqaux(perm < nsec+1,:);
	if ((i == 3) || (i == 9))
		seq28 = [seq28 ; seqaux];
	end
	if ((i == 4) || (i == 8))
		seq37 = [seq37 ; seqaux];
	end
	if ((i == 3) || (i == 6) || (i == 8))
		seq257 = [seq257 ; seqaux];
	end
	if ((i == 7) || (i == 8) || (i == 9))
		seq678 = [seq678 ; seqaux];
	end
	if ((i == 1) || (i == 2) || (i == 5))
		seq014 = [seq014 ; seqaux];
	end
end

% Store random dataset
%save('-text','28','seq28');
%save('-text','37','seq37');
%save('-text','257','seq257');
%save('-text','678','seq678');
save('-text','014','seq014');
cd '..';

return
