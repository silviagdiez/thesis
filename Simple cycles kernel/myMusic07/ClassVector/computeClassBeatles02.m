function v = computeClassBeatles02()
%============================================
% Computes Class vector
%============================================

mydir = '../Self-avoiding/CyclesBeatles';

%=== This is the vector class with songs identifiers ===
ids = tdfread('IdsTotal.txt');
ids = ids.Ids;
[nr,nc] = size(ids);
classes = load('classTotal.txt');

%=== This is the order in which they will be read ===
mylist = ls(mydir);
numItems = (length(mylist)/41);
n = 0;
cbegin = 1;
cend = 0;
v = [];

%=== For each song ===
for i=1:numItems 
	cend = cbegin + 39;
	myfile = mylist(cbegin:(cend-4))
	cbegin = cend + 2;
	
	%=== We verify the real class of the song ===
	for j=1:nr
		if strcmp(ids(j,:),myfile)
			v(i) = classes(j);
		end
	end	
end
