function ip = cycleKernel03(cycles1,cycles2)
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================

countLabel = 1;

%=== First set of labels ===
e1 = cycles1.keys();
while e1.hasMoreElements()
	key = e1.nextElement();
	labels{countLabel} = key;
    weights(countLabel) = cycles1.get(key);
	countLabel = countLabel + 1;
end

%=== Second set of labels ===
e2 = cycles2.keys();
while e2.hasMoreElements()
	key = e2.nextElement();
	%=== We verify if this key exist already in the first set ===
	value = cycles1.get(key);
	if length(value) == 0 % New label
		labels{countLabel} = key;
        %weights(countLabel) = cycles2.get(key);
		countLabel = countLabel + 1;
    %else % Existing label
    %    for i=1:countLabel
    %        if strcmp(key,labels{i})
    %            weights(i) = (weights(i) + cycles2.get(key))/2;
    %            break;
    %        end
    %    end
    end
end
%weights
sumW = sum(weights);
weightsN = weights/sumW;


%=== We compute the WEIGHTED inner product (cycle length) ===
ip = 0;
for i=1:length(labels)
	label = labels{i};
	c1 = cycles1.get(label);
	c2 = cycles2.get(label);
    
    if ~isempty(c1) && ~isempty(c2)
        ip = ip + weightsN(i); % This weights already the cycles because cycles of length n appear n times
    end     
end

return