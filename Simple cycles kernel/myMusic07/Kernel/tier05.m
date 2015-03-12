function [r,t1,t2,ar,a1,a2] = tier05(res,myclass,alpha,v)
%=== This function computes the first and second 
% tiers of the ranking of a list of songs with the number of classes
% "res" > is the similarity matrix
% "myclass" > is the vector class (row vector)
% "alpha" > (1-alpha) is the confidence for the intervals
% "v" > is the vector of songs which are used as queries 
% First tier: # of correctly retrieved songs within the best (C-1) matches
%            divided by (C-1) where C is the size of the song class.
% Second tier: # of correctly retrieved songs within the best (2C-1)
%                matches divided by (2C-1).
%============================================

%=== This is the Z for the confidence interval ===
z = norminv(1-(alpha/2),0,1);
e = length(res);

%=== We separate the songs into query songs and the rest ===
[nr,nc] = size(res);
songs = 1:nr;
querySongs = v;
restSongs = setdiff(songs,querySongs);


%=== For each query song ===
for i=1:length(querySongs)
    
    %=== We extract the position of the query song ===
    pos_query = querySongs(i);
    
    %=== We extract its class ===
    class = myclass(pos_query);
    
    %=== We compute the size of the class (C) ===
    C = sum(myclass == class);
    
    %=== We extract the similarity and class vectors ===
    simVec = res(pos_query,restSongs);
    classVec = myclass(restSongs);
    
    %=== We order the similarity vector ===
    [a,b] = sort(simVec,'descend');
    simVec = a;
    classVec = classVec(b);
    
    %=== We count the first (C-1) matches for the first tier ===
    numMatch1 = 0;
    for j=1:(C-1)
        if classVec(j) == class
            numMatch1 = numMatch1 + 1;
        end
    end
    %numMatch1;
    tier1(i) = numMatch1/(C-1);
    
    %=== We count the first (2C-1) matches for the second tier ===
    numMatch2 = 0;
    for j=1:((2*C)-1)
        if classVec(j) == class
            numMatch2 = numMatch2 + 1;
        end
    end
    %numMatch2;
    tier2(i) = numMatch2/(C-1);
    
    %=== We count the ranking for all matches ===
    ranking = 0;
    for j=1:length(classVec)
        if classVec(j) == class
            ranking = ranking + j;
        end
    end
    totalRanking(i) = ranking/(C-1);
end

ar = mean(totalRanking);
icr = z*std(totalRanking)/sqrt(e);

a1 = mean(tier1);
ic1 = z*std(tier1)/sqrt(e);

a2 = mean(tier2);
ic2 = z*std(tier2)/sqrt(e);

[ar icr a1 ic1 a2 ic2]

return