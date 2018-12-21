function F=createF(coor1,coor2)

    %find the normalization
    [coor1n,T1] = normalizePoints(coor1);
    [coor2n,T2] = normalizePoints(coor2);
      
    x1 = coor1n(:,1);
    x2 = coor2n(:,1);
    y1 = coor1n(:,2);
    y2 = coor2n(:,2);    
    
    % Construct matrix A
    A = [x1.*x2 x1.*y2 x1 y1.*x2 y1.*y2 y1 x2 y2 ones(length(x1),1)];
  
    % Find SVD of A
    [~,~,V] = svd(A);
    
    % find the fundamental matrix
    F = reshape(V(:,end),3,3);
    
    %make the fundamental matrix non-singular (i.e. det(F) = 0)
    [Uf,Df,Vf] = svd(F);
    Df(3,3)=0;
    F = Uf*Df*Vf';
    
    %transform back
    F = T2'*F*T1;
end