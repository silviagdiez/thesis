function [ip1,ip2] = pathKernel03(cycles1,cycles2,paths1,paths2)
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================

countLabel = 1;

%=== First set of cycles ===
e1 = cycles1.keys();
while e1.hasMoreElements()
	key = e1.nextElement();
	cycles{countLabel} = key;
    weightsC(countLabel) = cycles1.get(key);
	countLabel = countLabel + 1;
end

%=== Second set of cycles ===
e2 = cycles2.keys();
while e2.hasMoreElements()
	key = e2.nextElement();
	%=== We verify if this key exist already in the first set ===
	value = cycles1.get(key);
	if length(value) == 0 % New label
		cycles{countLabel} = key;
        weightsC(countLabel) = cycles2.get(key);
		countLabel = countLabel + 1;
    else % Existing label
        for i=1:countLabel
            if strcmp(key,cycles{i})
                weightsC(i) = (weightsC(i) + cycles2.get(key))/2;
                break;
            end
        end
    end
end

%cycles
%weightsC
sumW = sum(weightsC);
weightsCN = weightsC/sumW;

%=== First set of paths ===
countPath = 1;
e1 = paths1.keys();
while e1.hasMoreElements()
	key = e1.nextElement();
	paths{countPath} = key;
    weightsP(countPath) = paths1.get(key);
	countPath = countPath + 1;
end

%=== Second set of paths ===
e2 = paths2.keys();
while e2.hasMoreElements()
	key = e2.nextElement();
	%=== We verify if this key exist already in the first set ===
	value = paths1.get(key);
	if length(value) == 0 % New label
		paths{countPath} = key;
        weightsP(countPath) = paths2.get(key);
		countPath = countPath + 1;
    else % Existing label
        for i=1:countPath
            if strcmp(key,paths{i})
                weightsP(i) = (weightsP(i) + paths2.get(key))/2;
                break;
            end
        end
    end
end
%paths
%weightsP
sumW = sum(weightsP);
weightsPN = weightsP/sumW;

%=== We compute the WEIGHTED inner product (cycle length) ===
%ip = 0;
%length(cycles)
numCycles = 0;
numCyclesCoincidence = 0;
weightCycles = 0;
for i=1:length(cycles)
	label = cycles{i};
	c1 = cycles1.get(label);
	c2 = cycles2.get(label);
    
    parts = strsplit(' ',label);
    if ((length(parts) - 1) < 6) && ((length(parts) - 1) > 1)
        numCycles = numCycles + 1;
        if ~isempty(c1) && ~isempty(c2)
             label;
             numCyclesCoincidence = numCyclesCoincidence + 1;
             weightCycles = weightCycles + weightsCN(i);
             %ip = ip + weightsN(i); % This weights already the cycles because cycles of length n appear n times
        end   
    end
end
%numCycles
%weightCycles

%=== We compute the WEIGHTED inner product (cycle length) ===
%ip = 0;
%length(paths)
numPaths = 0;
numPathsCoincidence = 0;
weightPaths = 0;
for i=1:length(paths)
	label = paths{i};
	p1 = paths1.get(label);
	p2 = paths2.get(label);
    
    parts = strsplit(' ',label);
    if ((length(parts) - 1) < 6) && ((length(parts) - 1) > 1)
        numPaths = numPaths + 1;
    
        if ~isempty(p1) && ~isempty(p2)
             label;
             numPathsCoincidence = numPathsCoincidence + 1;
             weightPaths = weightPaths + weightsPN(i);
             %ip = ip + weightsN(i); % This weights already the cycles because cycles of length n appear n times
        end     
    end
end
%numPaths
%weightPaths

ip1 = weightCycles + weightPaths;
ip2 = (numCyclesCoincidence/numCycles) + (numPathsCoincidence/numPaths);

return