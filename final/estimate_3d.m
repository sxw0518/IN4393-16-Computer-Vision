function [M,S] = estimate_3d(measurement_matrix)
% This function is to estimate 3D coordinates using affine structure from
% motion.
% Input: point matrix(size:2m*n; m: the number of images; n: the number of
% points);
% Output: M: motion matrix; S: 
%Shift the mean of the points to zero
measurement_matrix = measurement_matrix - repmat(mean(measurement_matrix,2),1,size(measurement_matrix,2));
%singular value decomposition
[u,w,v] = svd(measurement_matrix);
U = u(:,1:3);
W = w(1:3,1:3);
V = v(:,1:3);
M = U*(W^0.5);
S = (W^0.5)*V';
%solve for affine ambiguity using non-linear least squares
A = M(1:2,:);
L0 = pinv(A'*A);
save('M','M')
L = lsqnonlin(@myfun,L0);
[C,p] = chol(L,'lower');
if p>0 % the matrix L is not positive definite matrix
    M = M;
    S = S;
else
    %update M and S
    M = M*C;
    S = pinv(C)*S;
end
end