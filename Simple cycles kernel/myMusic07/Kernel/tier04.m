function [r,t1,t2,ar,a1,a2] = tier04(res,myclass,alpha)
%=== This function computes the first and second 
% tiers of the ranking of a list of songs
% First tier: # of correctly retrieved songs within the best (C-1) matches
%            divided by (C-1) where C is the size of the song class.
% Second tier: # of correctly retrieved songs within the best (2C-1)
%                matches divided by (2C-1).
%============================================

%=== This is the Z for the confidence interval ===
z = norminv(1-(alpha/2),0,1)
e = length(res)

%=== We first sort the class vector ===
[a,b] = sort(myclass);
myclass = a;
res = res(b,b);

%=== We plot the graph ===
%imagesc(res);

%=== We compute the average ranking ===
totalRanking = [];
badClass = [];
goodClass = [];
for i=1:2:length(myclass)
    aux = res(i,:);
    [a,b] = sort(aux,'descend');
    %=== We look for the other memeber of the class in the ranking
    ranking = 1;
    for j=2:length(b)
        if b(j) == (i+1)
            break;
        else
        	if mod(b(j),2) == 0
            	ranking = ranking + 1;
            end
        end
    end
    ranking;
    
    totalRanking = [totalRanking ranking];
end

r = totalRanking
ar = mean(totalRanking)
icr = z*std(r)/sqrt(e)

%=== We compute the 1st tier ===
% For classes of size 2 we only search for the first (2-1 = 1) position
% and we always divide by (2-1 = 1).
tier1 = zeros(1,length(totalRanking));
for i=1:length(totalRanking)
    if totalRanking(i) == 1
        tier1(i) = 1/1;
    else
        tier1(i) = 0/1;
    end
end
t1 = tier1
a1 = mean(tier1)
ic1 = z*std(t1)/sqrt(e)

%=== We compute the 2nd tier ===
% For classes of size 2 we only search for the first (2*2-1 = 3) positions
% and we always divide by (2*2-1 = 3).
tier2 = zeros(1,length(totalRanking));
for i=1:length(totalRanking)
    if totalRanking(i) <= 3
        tier2(i) = 3/3;
    else
        tier2(i) = 0/3;
    end
end
t2 = tier2
a2 = mean(tier2)
ic2 = z*std(t2)/sqrt(e)

return