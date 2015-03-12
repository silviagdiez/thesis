function [res1,res_conf1,res2,res_conf2] = global_fuzzy(K, nbclu, classe, nbrep)
% Lance un certain nombre de fois l'algorithme de clustering et affiche en
% sortie la moyenne et l'intervalle de confiance des résultats.
%
% K = kernel
% nbclu = nombre de cluster
% classe = le vecteur de classe des données
% nbrep = le nombre de répétitions (facultatif)
%
% Luh Yen
%

if nargin < 4
    nbrep = 10;
end

param = 1.2;

taux = [];
adrand = [];

for i = 1:nbrep 
    fprintf('run n: %d\n',i);
	fflush(stdout);
    [EstIndex,RITrue] = DKC_fuzzy_db (K,nbclu,classe,param,0);
    taux = [taux confusion(EstIndex,classe,nbclu)];
    adrand = [adrand RITrue];
end
fprintf('\n');
res1 = mean(taux)*100;
res_conf1 = 1.96*std(100*taux)/sqrt(nbrep);
fprintf('le taux de classification est de %f +/- %f\n',res1, res_conf1);

res2 = mean(adrand)*100;
res_conf2 = 1.96*std(100*adrand)/sqrt(nbrep);
fprintf('adjusted RAND index est de %f +/- %f\n',res2, res_conf2);