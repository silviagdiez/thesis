function numb = countCycles(res)

e = res.saveCycles.keys();
count = zeros(1,20);
%count = zeros(1,7);
while e.hasMoreElements()
	label = e.nextElement();
    
    parts = strsplit(' ',label);
    lenParts = (length(parts) - 1);
    count(lenParts) = count(lenParts)+1;    
    
end
count;

%for i=1:7
for i=1:20
    numb(i) = count(i)/i;
end
numb;

return
        