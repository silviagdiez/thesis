function testGradient01() 
%=============================================================================
% "N" < size of the grid
% "D" < diffussion coefficient [0,1)
% solve BVP2: D*z" + (- 4*D - V(x,y)) * z = -4*D*delta(x)*delta(y)
% with z(t0) = z0, z(tf) = zf by the finite difference method 
% for a NxN grid
% Implemented by Silvia Garcia 2011.
% From the book "Applied Numerical Methods for Engineers: Using Matlab anc C"
% Schilling and Harris.
%=============================================================================

%=== Useful variables ===
t0 = 0;
tf = 4;
z0 = 1;
zf = 1;
Ds = [0 0.001 1 10];
N = 36;

for i=1:length(Ds)
    D = Ds(i)

    %=== Solution for MAZE_01 ===
    [np,t2,t3,aux,LogZb] = bvp_fdf07(t0,tf,z0,zf,N,D,0);
    
    if (i == 1)
        %=== We plot the maze ===
        %subplot(4,1,1);
        figure
        imagesc(aux);
        h = title({'Maze (red) and source and'; 'goal nodes (yellow)'});
        set(h,'FontSize',12);
    else
        %=== We plot the gradient ===
        [DX,DY] = gradient(LogZb);

        %=== We compute the norm of the gradient ===
        for j=1:size(DX,1)
            for k=1:size(DY,2)
                norms(j,k) = norm([DX(j,k) DY(j,k)]);
            end
        end
        %subplot(4,1,i);
        figure
        hold on
        contour(t2,t3,np);
        quiver(t2,t3,DX./norms,DY./norms);
        %surf(np)
        h = title({'Path planning (gradient) and contour plot';['of the function (D = ',mat2str(D),')']});
        set(h,'FontSize',12);
        hold off
    end
   
end

return;