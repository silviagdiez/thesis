function [EstIndex,RITrue] = DKC_fuzzy_db (Kernel,k,TrueID)
% kmeansCluster va lancer le programme dckmeans uncertain nombre de fois
% (donn� par Repetitions) et renvoyer � la sortie la solution � la variance
% in intra-cluster totale minimale.
%
% Kernel est la matrice kernel des donn�es.
% k    est le nombre de cluster qu'il faudra trouver.
% TrueID est l'attribution exacte des donn�es, c'est un vecteur contenant
%        le n� de classe de chaque �l�ment (param facultatif, []->non connu).
% dessin = 1 si on veut le graphe de l'�volution de taux de classification 
% Repetitions (facultatif)est le nombre de fois qu'il faudra relancer 
%             l'algorithme de clustering (1 par d�faut).
%
% EstIndex est le label de classe donn� par la solution optimale de
%          dckmeans.
% RITrue est le "(adjusted) Rand Index" par rapport � la vraie solution (si
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
   
