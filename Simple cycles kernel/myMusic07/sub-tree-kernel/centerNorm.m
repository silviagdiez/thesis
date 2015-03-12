function [K1,K2] = centerNorm(K,opt)
% This function centers and normalizes the kernel
% "opt" > (1) for similarity (2) for distance

 [nr,nc] = size(K);
 e = ones(nr,1);
 H = (eye(nr) - (e*e')/nr);
 if opt == 1
 	K1 = H*K*H;
 else
 	K1 = (-1/2)*H*K*H;
 end
 D = diag(1./diag(K1));
 K2 = sqrt(D)*K1*sqrt(D);
 
 return