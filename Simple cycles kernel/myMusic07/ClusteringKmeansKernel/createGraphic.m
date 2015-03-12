function G = createGraphic()

	theta = [0.1 0.5 1 1.5 2 2.5 3 3.5 4];
	rand = [38.920149	49.151971	84.61456	84.61456	82.799755	78.155953	67.788292	63.277806	55.931833];
	class = [68	76.67	94.67	94.67	94	92	87.33	85.33	82];
	hold("on");
	grid on
	title('Classification Rate (blue) and Rand Index (red) for Fuzzy K-Means Clustering of a RSP Edit Distance')
	axis([0.1, 4, 30, 100])
	xlabel('Theta values')
	plot(theta,rand,"r*");
	plot(theta,rand,"r-");
	plot(theta,class,"b*");
	plot(theta,class,"b-");
	hold("off");
	
return