function [thetaOpt,cOpt] = grid(preds)

% we calculate the means matrix (row = theta, col = c)

means = zeros(size(preds,1),size(preds,2));	
for j=1:size(preds,1)
	for k=1:size(preds,2)
		if (j == 1)
			rows = j:j+1;
		elseif (j == size(preds,1))
			rows = j-1:j;
		else
			rows = j-1:j+1;
		end
		if (k == 1)
			cols = k:k+1;
		elseif (k == size(preds,2))
			cols = k-1:k;
		else	
			cols = k-1:k+1;
		end
		means(j,k) = sum(sum(preds(rows,cols)))/(length(rows)*length(cols));
	end
end
	
means;

% we chose the center of the 9-cells that contains the maximum
max = 0;
for j=1:size(preds,1)
	for k=1:size(preds,2)
		if (means(j,k) > max)
			max = means(j,k);
			row = j;
			col = k;
		end
	end
end
	
thetaOpt = row;
cOpt = col;

return;