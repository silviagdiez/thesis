function np = bvp_fdf(t0,tf,z0,zf,N,lambda,alpha,m) 
% solve BVP2: z" + (- 4 - h^2 * lambda * s) * z = 0 
% with z(t0) = z0, z(tf) = zf 
% by the finite difference method 
% and for a NxN grid

%=== gaussian parameter values ===
s11 = 0.0001;
s22 = 0.0001;
m1 = 2;
m2 = 2;

%=== step and time values ===
h = (tf - t0)/N; 
h2 = 2*h^2;
t = t0+[0:N]'*h;

%=== values of function V(x,y) ===
%V = inline('1 + m * 1/(2*pi*sqrt(s11*s22)) * exp(-0.5 * alpha * ( ((x-m1)/sqrt(s11))^2 + ((y-m2)/sqrt(s22))^2 ))','x','y');
V = inline('1','x','y');
for i=1:N
	for j=1:N
		s(i,j) = V(t(i+1),t(j+1));
	end
end

%=== we create the matrix B ===
B = [];
for i=1:N
	%=== template A (N x N) ===
	A = []; 
	for j=1:N
		if (j==1)
			A = [(- 4 - h^2 * lambda * s(i,j)) 1 repmat(0,1,N-2)];
		elseif (j==N)
			A = [A; repmat(0,1,N-2) 1 (- 4 - h^2 * lambda * s(i,j))];
		else
			A = [A; repmat(0,1,(j-2)) 1 (- 4 - h^2 * lambda * s(i,j)) 1 repmat(0,1,(N-1-j))];
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

%B1 = B;
%B1(1,1) = 0
%B2 = B;
%B2(N*N,N*N) = 0

%=== solution vectors: b1 for (z0,zf)=(1,0) and b2 for (z0,zf)=(0,1) ===
for i=1:N*N
	if (i==1)
		b1(i) = -z0;
		b2(i) = 0;
	elseif (i==N*N)
		b1(i) = 0;
		b2(i) = -z0;
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
	mat1 = [mat1; sol1(j:N*i) ];
	j = j+N;
end

j = 1;
mat2 = [];
for i=1:N
	mat2 = [mat2; sol2(j:N*i) ];
	j = j+N;
end

%=== average number of passages ===
rfr0 = sol1(N);
np = zeros(N,N);
for i=1:N
	for j=1:N
		np(i,j) = (mat1(i,j)*mat2(i,j))/rfr0;
	end
end

