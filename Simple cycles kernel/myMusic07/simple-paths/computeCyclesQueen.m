function computeCyclesQueen()
%=== This function computes all simple cycles
% and cycles of the graphs in a directory and 
% save the results as hashtables .mat objects
%============================================

dirs = {'../AdjacencyIntervalsQueen'};
dirout = '../Self-avoiding/';
data = 'Queen';
p = 7; % We fix the length of the longest cycle or path to 7
tic();

for l = 1:length(dirs)

	dir = dirs{l};
	mylist = ls(dir);
	numItems = (length(mylist)/37);
	n = 0;
	cbegin = 1;
	cend = 0;
	
	for i=1:numItems 
		'%%%%%%%%%%%%%% NEW ITEM %%%%%%%%%%%%%%'
		cend = cbegin + 35;
		myfile = mylist(cbegin:cend)
		cbegin = cend + 2;
	
		%=== For each graph ADJACENCY MATRIX ===
		path = [dir,'/',myfile]
		adj = load(path);
		adj = spconvert(adj);
		testQueen(data,myfile,dirout,adj,p,2); % (2) intervals
		
	end
end
toc()
