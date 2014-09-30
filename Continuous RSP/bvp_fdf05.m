function np = bvp_fdf05(t0,tf,z0,zf,N,D) 
%=============================================================================
% solve BVP2: D*z" + (- 4*D - V(x,y)) * z = -4*D*delta(x)*delta(y)
% with z(t0) = z0, z(tf) = zf by the finite difference method 
% for a NxN grid
% Implemented by Silvia Garcia 2011.
% From the book "Applied Numerical Methods for Engineers: Using Matlab anc C"
% Schilling and Harris.
%=============================================================================

%=== step and time values ===
h = (tf - t0)/N; 
h2 = h^2;
t = t0+[0:N]'*h

%=== values of function V(x,y) ===
V1 = inline('mvnpdf([x y],[z 0.0000],[0.00001 0; 0 0.00001])','x','y','z');
V2 = inline('mvnpdf([x y],[z 0.1333],[0.00001 0; 0 0.00001])','x','y','z');
V3 = inline('mvnpdf([x y],[z 0.2667],[0.00001 0; 0 0.00001])','x','y','z');
V4 = inline('mvnpdf([x y],[z 0.4000],[0.00001 0; 0 0.00001])','x','y','z');
V5 = inline('mvnpdf([x y],[z 0.5333],[0.00001 0; 0 0.00001])','x','y','z');
V6 = inline('mvnpdf([x y],[z 0.6667],[0.00001 0; 0 0.00001])','x','y','z');
V7 = inline('mvnpdf([x y],[z 0.8000],[0.00001 0; 0 0.00001])','x','y','z');
V8 = inline('mvnpdf([x y],[z 0.9333],[0.00001 0; 0 0.00001])','x','y','z');
V9 = inline('mvnpdf([x y],[z 1.0667],[0.00001 0; 0 0.00001])','x','y','z');
V10 = inline('mvnpdf([x y],[z 1.2000],[0.00001 0; 0 0.00001])','x','y','z');
V11 = inline('mvnpdf([x y],[z 1.3333],[0.00001 0; 0 0.00001])','x','y','z');
V12 = inline('mvnpdf([x y],[z 1.4667],[0.00001 0; 0 0.00001])','x','y','z');
V13 = inline('mvnpdf([x y],[z 1.6000],[0.00001 0; 0 0.00001])','x','y','z');
V14 = inline('mvnpdf([x y],[z 1.7333],[0.00001 0; 0 0.00001])','x','y','z');
V15 = inline('mvnpdf([x y],[z 1.8667],[0.00001 0; 0 0.00001])','x','y','z');
V16 = inline('mvnpdf([x y],[z 2.0000],[0.00001 0; 0 0.00001])','x','y','z');
V17 = inline('mvnpdf([x y],[z 2.1333],[0.00001 0; 0 0.00001])','x','y','z');
V18 = inline('mvnpdf([x y],[z 2.2667],[0.00001 0; 0 0.00001])','x','y','z');
V19 = inline('mvnpdf([x y],[z 2.4000],[0.00001 0; 0 0.00001])','x','y','z');
V20 = inline('mvnpdf([x y],[z 2.5333],[0.00001 0; 0 0.00001])','x','y','z');
V21 = inline('mvnpdf([x y],[z 2.6667],[0.00001 0; 0 0.00001])','x','y','z');
V22 = inline('mvnpdf([x y],[z 2.8000],[0.00001 0; 0 0.00001])','x','y','z');
V23 = inline('mvnpdf([x y],[z 2.9333],[0.00001 0; 0 0.00001])','x','y','z');
V24 = inline('mvnpdf([x y],[z 3.0667],[0.00001 0; 0 0.00001])','x','y','z');
V25 = inline('mvnpdf([x y],[z 3.2000],[0.00001 0; 0 0.00001])','x','y','z');
V26 = inline('mvnpdf([x y],[z 3.3333],[0.00001 0; 0 0.00001])','x','y','z');
V27 = inline('mvnpdf([x y],[z 3.4667],[0.00001 0; 0 0.00001])','x','y','z');
V28 = inline('mvnpdf([x y],[z 3.6000],[0.00001 0; 0 0.00001])','x','y','z');
V29 = inline('mvnpdf([x y],[z 3.7333],[0.00001 0; 0 0.00001])','x','y','z');
V30 = inline('mvnpdf([x y],[z 3.8667],[0.00001 0; 0 0.00001])','x','y','z');
V31 = inline('mvnpdf([x y],[z 4.0000],[0.00001 0; 0 0.00001])','x','y','z');


for i=1:length(t)
	for j=1:length(t)
		s(i,j) = V1(t(i),t(j),2) + V2(t(i),t(j),2) + V3(t(i),t(j),2) + V4(t(i),t(j),2) + V5(t(i),t(j),2) + V6(t(i),t(j),2) + V7(t(i),t(j),2) + V8(t(i),t(j),2) + V9(t(i),t(j),2) + V10(t(i),t(j),2) + V11(t(i),t(j),2) + V12(t(i),t(j),2)+ V13(t(i),t(j),2)+ V14(t(i),t(j),2)+ V15(t(i),t(j),2) ...
		+ V15(t(i),t(j),3.0667) + V16(t(i),t(j),3.0667) + V17(t(i),t(j),3.0667) + V18(t(i),t(j),3.0667) + V19(t(i),t(j),3.0667) + V20(t(i),t(j),3.0667) + V21(t(i),t(j),3.0667) + V22(t(i),t(j),3.0667) + V23(t(i),t(j),3.0667) + V24(t(i),t(j),3.0667) + V25(t(i),t(j),3.0667) + V26(t(i),t(j),3.0667) + V27(t(i),t(j),3.0667) + V28(t(i),t(j),3.0667) + V29(t(i),t(j),3.0667) + V30(t(i),t(j),3.0667) + V31(t(i),t(j),3.0667) ...
		+ V15(t(i),t(j),1.0667) + V16(t(i),t(j),1.0667) + V17(t(i),t(j),1.0667) + V18(t(i),t(j),1.0667) + V19(t(i),t(j),1.0667) + V20(t(i),t(j),1.0667) + V21(t(i),t(j),1.0667) + V22(t(i),t(j),1.0667) + V23(t(i),t(j),1.0667) + V24(t(i),t(j),1.0667) + V25(t(i),t(j),1.0667) + V26(t(i),t(j),1.0667) + V27(t(i),t(j),1.0667) + V28(t(i),t(j),1.0667) + V29(t(i),t(j),1.0667) + V30(t(i),t(j),1.0667) + V31(t(i),t(j),1.0667);
	end
end

subplot(2,2,1);
imagesc(s);
title('Gaussian used as V(x,y)');

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
for i=1:N*N
	if (i==1)
		b1(i) = -(2*z0)-(4*D);
		b2(i) = 0;
	elseif (i==N*N)
		b1(i) = 0;
		b2(i) = -(2*z0)-(4*D);
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
imagesc(log(mat1))
title('Forward variable');

j = 1;
mat2 = [];
for i=1:N
	mat2 = [mat2; sol2(j:N*i)];
	j = j+N;
end

subplot(2,2,3)
imagesc(log(mat2))
title('Backward variable');

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
title('Mean number of passages per node');

%=== Global title ===
ax = gca;
fig = gcf;
title_handle = axes('position',[.1 -0.05 .8 .05],'Box','off','Visible','off');
title(['Continuous RSP (D = ',mat2str(D),')']);
set(get(gca,'Title'),'Visible','On');
set(get(gca,'Title'),'FontSize',16);
set(get(gca,'Title'),'FontWeight','bold');
axes(ax);



