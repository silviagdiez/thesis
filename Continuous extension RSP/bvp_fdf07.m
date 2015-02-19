function [np,t2,t3,aux,LogZb] = bvp_fdf07(t0,tf,z0,zf,N,D,pl) 
%=============================================================================
% solve BVP2: D*z" + (- 4*D - V(x,y)) * z = -4*D*delta(x)*delta(y)
% with z(t0) = z0, z(tf) = zf by the finite difference method 
% for a NxN grid
% We assume D = 1/(4 x theta)
% Implemented by Silvia Garcia 2011.
% From the book "Applied Numerical Methods for Engineers: Using Matlab anc C"
% Schilling and Harris.
%=============================================================================

%=== step and time values ===
h = (tf - t0)/N; 
h2 = h^2;
t = t0+[0:N]'*h;

%=== Here we chose the maze to solve ===
%=== s is the cost matrix ===
%=== aux is only for representation with source and destination ===
[s,aux] = computeMaze01(N);

%=== We plot the maze ===
if (pl == 1)
    subplot(2,2,1);
    imagesc(aux);
    h = title({'Maze (red) and source'; 'and goal nodes (yellow)'});
    set(h,'FontSize',12);
end

%=== we create the matrix B ===
B = [];
for i=1:N
	%=== template A (N x N) ===
	A = []; 
	for j=1:N
		if (j==1)
			A = [(-(4*D/h2) -s(i,j)) (D/h2) repmat(0,1,N-2)];
		elseif (j==N)
			A = [A; repmat(0,1,N-2) (D/h2) (-(4*D/h2) - s(i,j))];
		else
			A = [A; repmat(0,1,(j-2)) (D/h2) (-(4*D/h2) - s(i,j)) (D/h2) repmat(0,1,(N-1-j))];
		end
	end
	
	%=== matrix B (N*N x N*N)===
	if (i==1)
		B = [A eye(N)*(D/h2) repmat(zeros(N,N),1,N-2)];
	elseif (i==N)
		B = [B; repmat(zeros(N,N),1,N-2) eye(N)*(D/h2) A];
	else
		B = [B; repmat(zeros(N,N),1,(i-2)) eye(N)*(D/h2) A eye(N)*(D/h2) repmat(zeros(N,N),1,(N-1-i))];
	end
end

%=== solution vectors: b1 for (z0,zf)=(1,0) and b2 for (z0,zf)=(0,1) ===
source = (14*N/18);
for i=1:N*N
	if i == ((source-1)*N)+1
		b1(i) = -z0-(4*D);
		b2(i) = 0;
	elseif i == (source*N)
		b1(i) = 0;
		b2(i) = -z0-(4*D);
    %%%%%%%%%%%%%%%%%%%%%%%%
    elseif i == (36*19)
		b1(i) = 0;
		b2(i) = -z0-(4*D);
	%%%%%%%%%%%%%%%%%%%%%%%%
	else
		b1(i) = 0;
		b2(i) = 0;
	end
end

%=== solve the systems ===
sol1 = (inv(B)*b1')';
sol2 = (inv(B)*b2')';

%=== solution matrices FORWARD VARIABLE ===
j = 1;
mat1 = [];
for i=1:N
	mat1 = [mat1; sol1(j:N*i)];
	j = j+N;
end

if (pl == 1)
    subplot(2,2,2)
    imagesc(log(mat1))
    h = title('Forward variable');
    set(h,'FontSize',12);
end

%=== solution matrices BACKWARD VARIABLE ===
j = 1;
mat2 = [];
for i=1:N
	mat2 = [mat2; sol2(j:N*i)];
	j = j+N;
end

if (pl == 1)
    subplot(2,2,3)
    imagesc(log(mat2))
    h = title('Backward variable');
    set(h,'FontSize',12);
end

%=== average number of passages ===
rfr0 = sol1(N); % This is the partition function
np = zeros(N,N);
for i=1:N
	for j=1:N
		np(i,j) = (mat1(i,j)*mat2(i,j))/rfr0;
	end
end

if (pl == 1)
    subplot(2,2,4)
    imagesc(np);
    h = title({'Mean number of';'passages per node'});
    set(h,'FontSize',12);
end

%=== We compute the -log(Z) with the backward variables ===
LogZb = zeros(N,N);
for i=1:N
	for j=1:N
		LogZb(i,j) = -log(mat2(i,j));
	end
end

%=== We compute the optimal probabilities p*_kk' ===
optP = zeros(N,N);
theta = 1/(4*D)
for i=1:N
	for j=1:N
        c_ij = s(i,j);
        w_ij = (1/4)*exp(-theta*c_ij);
        z_jn = mat2(i,j);
        z_in = 
		optP(i,j) = (w_kk*z_jn)/z_in;
	end
end

%=== We plot the maze ===
%figure
t2 = t(2:length(t));
t3 = sort(t2,'descend');
%[DX,DY] = gradient(np);
%subplot(1,2,1);
%imagesc(aux);
%h = title('Maze (red) and source and goal nodes (yellow)');
%set(h,'FontSize',12);
%=== We plot the gradient ===
%subplot(1,2,2);
%hold on
%contour(t2,t3,np);
%quiver(t2,t3,DX,DY);
%h = title({'Path planning (gradient) and contour plot';['of the function (D = ',mat2str(D),')']});
%set(h,'FontSize',12);
%hold off

return;

