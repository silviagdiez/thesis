function ip = cycleKernelTfIdf(cycles1,cycles2,doc1,doc2,tf_idf,cycles)
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
	if isempty(value)
		labels{countLabel} = key;
		countLabel = countLabel + 1;
    end
end

labels;

%=== We compute the TF-IDF inner product (cycle length) ===
ip = 0;
totalParts = 0;
for i=1:length(labels)
	label = labels{i}
	c1 = cycles1.get(label);
	c2 = cycles2.get(label);
    
    %=== We get the tf_idf for this label ===
    %=== 1) This is the identifier of the label ===
    idLabel = cycles.get(label)
    doc1
    doc2
    
    %=== 2) This is the tf_idf weigth for this document and this label ===
    myTf1 = tf_idf(doc1,idLabel)
    myTf2 = tf_idf(doc2,idLabel)
	
    %=== We count the total parts of cycles ===
    parts = strsplit(' ',label);
    totalParts = totalParts + ((length(parts)-1)*myTf1*(length(parts)-1)*myTf2); % TF-IDF
    
    %=== Total inner product TF1*length(cycle1)*TF2*length(cycle2) ===
	if ~isempty(c1) && ~isempty(c2)
        ip = ip + ((length(parts)-1)*myTf1*(length(parts)-1)*myTf2); % TF-IDF
    end
end

ip = (ip/totalParts);

return