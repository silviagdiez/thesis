function ip = cycleKernel(cycles1,cycles2)
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================

countLabel = 1;

%=== First set of labels ===
e1 = cycles1.keys();
while e1.hasMoreElements()
	key = e1.nextElement();
	labels{countLabel} = key;
	countLabel = countLabel + 1;
end

%=== Second set of labels ===
e2 = cycles2.keys();
while e2.hasMoreElements()
	key = e2.nextElement();
	%=== We verify if this key exist already in the first set ===
	value = cycles1.get(key);
	if length(value) == 0
		labels{countLabel} = key;
		countLabel = countLabel + 1;
    end
end

labels;

%=== We compute the WEIGHTED inner product (cycle length) ===
ip = 0;
totalParts = 0;
for i=1:length(labels)
	label = labels{i};
	c1 = cycles1.get(label);
	c2 = cycles2.get(label);
	
    %=== We count the total parts of cycles ===
    parts = strsplit(' ',label);
    totalParts = totalParts + length(parts) - 1;
    
	if ~isempty(c1) && ~isempty(c2)
        ip = ip + (length(parts)-1);
    end
end

ip = (ip/totalParts);

return