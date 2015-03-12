function ip = cycleKernel02(cycles1,cycles2)
%=== This function computes the interior product from
% cycles among all pairs of cycles
%============================================

countLabel = 1;

%=== First set of labels ===
e1 = cycles1.keys();
while e1.hasMoreElements()
	key = e1.nextElement();
	labels{countLabel} = key;
    %weights{countLabel} = e1.get(key);
	countLabel = countLabel + 1;
end
%num1 = countLabel;
%=== We normalize the weigths ===
%weights1 = sum(weights)

%=== Second set of labels ===
e2 = cycles2.keys();
while e2.hasMoreElements()
	key = e2.nextElement();
	%=== We verify if this key exist already in the first set ===
	value = cycles1.get(key);
	if length(value) == 0
		labels{countLabel} = key;
        %weights{countLabel} = e2.get(key);
		countLabel = countLabel + 1;
    end
end
%num2 = countLabel - num1;
%weights2 = sum(weights) - weights1

%labels
%weights

%=== We compute the WEIGHTED inner product (cycle length) ===
ip = 0;
totalCycles = length(labels);
%totalWeight = sum(weights);
for i=1:length(labels)
	label = labels{i};
	c1 = cycles1.get(label);
	c2 = cycles2.get(label);
    
    %parts = strsplit(' ',label);
    %if ((length(parts) - 1) < 6)
     %   totalCycles = totalCycles + 1;
        
        if ~isempty(c1) && ~isempty(c2)
            ip = ip + 1; % This weights already the cycles because cycles of length n appear n times
        end
   %end     
end

ip = (ip/totalCycles);
%ip
%ip = ip/(min(num1,num2))

return