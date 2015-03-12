function [EstIndex,RITrue] = DKC_fuzzy_db (Kernel,k,TrueID)
% kmeansCluster va lancer le programme dckmeans uncertain nombre de fois
% (donné par Repetitions) et renvoyer à la sortie la solution à la variance
% in intra-cluster totale minimale.
%
% Kernel est la matrice kernel des données.
% k    est le nombre de cluster qu'il faudra trouver.
% TrueID est l'attribution exacte des données, c'est un vecteur contenant
%        le n° de classe de chaque élément (param facultatif, []->non connu).
% dessin = 1 si on veut le graphe de l'évolution de taux de classification 
% Repetitions (facultatif)est le nombre de fois qu'il faudra relancer 
%             l'algorithme de clustering (1 par défaut).
%
% EstIndex est le label de classe donné par la solution optimale de
%          dckmeans.
% RITrue est le "(adjusted) Rand Index" par rapport à la vraie solution (si
%        connue).
% variold  est la variance intra-classe totale pour tous les clusters
%
% Luh Yen
%

if nargin < 2
   error('DKC requires at least 2 arguments');
   help DKC
   return
end
[R,C]=size(Kernel)
if nargin < 3, TrueID = []; end	
if nargin < 5, dessin = 0; end		
if nargin < 6, Repetitions = 20; end

lengthTrueID=length(TrueID)
if length(TrueID)>0 && length(TrueID)~=R
   error('KMEANSCLUSTER number of labels doesn''t match number of records');
   return
end

if k == 1			%Only want one cluster? Well, ...OK
   RITrue=0;
   EstIndex=ones(R,1);
   return
end

if R ~= C
    error('Kernel non carree, calcul de kernel\n');
end


variold = realmax;  % beware!! we take realmin because of the normalized kernel
trace = [];
dkc = [];

%Do the clustering
i = 1;
while i < Repetitions
	i
	[pos,J] = kernel_db (Kernel,k);
	if !isempty(pos)
		i = i+1;
	end
    variance = J(end);
   
   if variance < variold 
       variold = variance;
       EstIndex = pos;
       elu = i;
   end          
end %of repetitions loop


% return adjusted Rand index (accuracy) for each itaration if true 
   % labels are giv
if length(TrueID)>0
   RITrue=RandIndex(EstIndex, TrueID);   
else
    lengthTrueID2=length(TrueID)
   RITrue=-1;
end
   
