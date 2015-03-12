function ar = averageRanking(res,myclass)
%=== This function computes the average ranking
% of a list of songs
%============================================

%=== We first sort the class vector ===
[a,b] = sort(myclass);
myclass = a;
res = res(b,b);

%=== We plot the graph ===
%imagesc(res);

%=== We compute the average ranking ===
totalRanking = [];
for i=1:2:length(myclass)
    aux = res(i,:);
    [a,b] = sort(aux,'descend');
    %=== We look for the other memeber of the class in the ranking
    ranking = 1;
    for j=2:length(b)
        if b(j) == (i+1)
            break;
        else
            ranking = ranking + 1;
        end
    end
    %ranking
    totalRanking = [totalRanking ranking];
end

totalRanking
ar = mean(totalRanking)


return