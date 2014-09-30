function np = bvp_fdf02(t0,tf,z0,zf,N) 
%=============================================================================
% solve BVP2: z" + (- 4 - s(x,y)) * z = 0 
% with z(t0) = z0, z(tf) = zf by the finite difference method 
% for a NxN grid
% Implemented by Silvia Garcia 2011.
% From the book "Applied Numerical Methods for Engineers: Using Matlab anc C"
% Schilling and Harris.
%=============================================================================

%=== step and time values ===
h = (tf - t0)/N; 
h2 = 2*h^2;
t = t0+[0:N]'*h;

%=== values of function V(x,y) ===
V = inline('mvnpdf([x y],[2 2],[0.1 0; 0 0.5])','x','y'); 
%V = inline('1','x','y');
for i=1:length(t)
	for j=1:length(t)
		s(i,j) = V(t(i),t(j));
	end
end

subplot(2,2,1)
imagesc(s)

%=== we create the matrix B ===
B = [];
for i=1:N
	%=== template A (N x N) ===
	A = []; 
	for j=1:N
		if (j==1)
			A = [(-4 -s(i,j)) 1 repmat(0,1,N-2)];
		elseif (j==N)
			A = [A; repmat(0,1,N-2) 1 (- 4 - s(i,j))];
		else
			A = [A; repmat(0,1,(j-2)) 1 (- 4 - s(i,j)) 1 repmat(0,1,(N-1-j))];
		end
	end
	
	%=== matrix B (N*N x N*N)===
	if (i==1)
		B = [A eye(N) repmat(zeros(N,N),1,N-2)];
	elseif (i==N)
		B = [B; repmat(zeros(N,N),1,N-2) eye(N) A];
	else
		B = [B; repmat(zeros(N,N),1,(i-2)) eye(N) A eye(N) repmat(zeros(N,N),1,(N-1-i))];
	end
end

%=== solution vectors: b1 for (z0,zf)=(1,0) and b2 for (z0,zf)=(0,1) ===
for i=1:N*N
	if (i==1)
		b1(i) = -2*z0;
		b2(i) = 0;
	elseif (i==N*N)
		b1(i) = 0;
		b2(i) = -2*z0;
	else
		b1(i) = 0;
		b2(i) = 0;
	end
end

%=== solve the systems ===
sol1 = (inv(B)*b1')';
sol2 = (inv(B)*b2')';

%=== solution matrices ===
j = 1;
mat1 = [];
for i=1:N
	mat1 = [mat1; sol1(j:N*i)];
	j = j+N;
end

subplot(2,2,2)
imagesc(mat1)

j = 1;
mat2 = [];
for i=1:N
	mat2 = [mat2; sol2(j:N*i)];
	j = j+N;
end

subplot(2,2,3)
imagesc(mat2)

%=== average number of passages ===
rfr0 = sol1(N);
np = zeros(N,N);
for i=1:N
	for j=1:N
		np(i,j) = (mat1(i,j)*mat2(i,j))/rfr0;
	end
end

subplot(2,2,4)
imagesc(np)



