function Graphs = computeCycles()
%=== This function computes all simple cycles
% and cycles of the graphs in a directory and 
% save the results as hashtables .mat objects
%============================================

dirs = {'../AdjacencyIntervalsSelected03','../AdjacencyIntervalsRandom03'};
dirout = '../Self-avoiding';
%p = 7; % We fix the length of the longest cycle to 7
p = 6; % We fix the length of the longest cycle to 7
tic();

%for l = 1:length(dirs)
for l = 2:length(dirs)

	dir = dirs{l};
	mylist = ls(dir);
	numItems = (length(mylist)/37);
	n = 0;
	cbegin = 1;
	cend = 0;
	
	for i=1:numItems 
		'%%%%%%%%%%%%%% NEW ITEM %%%%%%%%%%%%%%'
		cend = cbegin + 35;
		myfile = mylist(cbegin:cend);
		cbegin = cend + 2;
	
		%=== For each graph ADJACENCY MATRIX ===
		path = [dir,'/',myfile]
		adj = load(path);
		adj = spconvert(adj);
		test03(myfile,adj,p,dirout,2); % (2) intervals
		
	end
end
toc()
