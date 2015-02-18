function dist = gravityDistance(Ktrain,Ktest,Kself,trainClass)
% Function that computes the distance of a set of observations to its center of gravity
% "Ktrain" > kernel training matrix (nxn) 
% "Ktest" > kernel test matrix (mxn, m<n)
% "Kself" > kernel of the observations of test set with themselves (1xm)
% "trainClass" > training trainClass vector

epsilon = 1e-6; % small value that avoids 1/0
[nb_data,nc] = size(Ktrain);

%=== We count the number of observations of each trainClass in the training set ===
nb_cl = length(unique(trainClass));
n = zeros(1,nb_cl);
for i = 1:nb_cl
   	n(i) = sum(trainClass == i);
end

%=== We create the prototype vectors from the training set===
h = zeros(nb_cl,nb_data);
for i = 1:nb_cl
   	for j = 1:nb_data
   		if (trainClass(j) == i)
   			h(i,j) = (1/n(i));
   		end
   	end
end
%=== we have to transpose the matrix in order for the following operations to be valid ===
h = h';

%=== We compute the distances from each observation to the gravity centers ===
[nb_data,nc] = size(Ktest);
dist = zeros(nb_cl,nb_data);
for i = 1:nb_cl
    hKh = h(:,i)' * Ktrain * h(:,i);
    for j = 1:nb_data
    	kh = Ktest(j,:)*h(:,i);
    	kxx = Kself(j);
       	dist(i,j) = kxx + hKh - 2*kh;
    end
end

return;  
    
    
