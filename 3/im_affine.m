function [best_x,inliers,best_seedA,best_seedb] = im_affine(im1,im2,P,N)
[frames1,desc1] = vl_sift(im1);
[frames2,desc2] = vl_sift(im2);
matches = vl_ubcmatch(desc1,desc2,35);
match_1 = frames1(:,matches(1,:));
match_2 = frames2(:,matches(2,:));
numT = size(matches,2);
num = size(match_1,2);
transformed_points = zeros(2,num);
threshold = 10;
previous_num = 0;
for i = 1:N
    perm = randperm(numT);
    seed = perm(1:P);
    seedA = frames1(1:2,matches(1,seed));
    seedb = frames2(1:2,matches(2,seed));
    A = [seedA(1,1) seedA(2,1) 0 0 1 0;
        0 0 seedA(1,1) seedA(2,1) 0 1;
        seedA(1,2) seedA(2,2) 0 0 1 0;
        0 0 seedA(1,2) seedA(2,2) 0 1;
        seedA(1,3) seedA(2,3) 0 0 1 0;
        0 0 seedA(1,3) seedA(2,3) 0 1];
    b = [seedb(1,1);seedb(2,1);seedb(1,2);seedb(2,2);seedb(1,3);seedb(2,3)];
    x = pinv(A)*b;
    for j = 1:num
        origin = [match_1(1,j) match_1(2,j) 0 0 1 0;0 0 match_1(1,j) match_1(2,j) 0 1];
        transformed = origin*x;
        transformed_points(1,j) = transformed(1);
        transformed_points(2,j) = transformed(2);
    end
    len = sqrt(sum((transformed_points - match_2(1:2,:)).^2));
    inliers = len<threshold;
    inliers = find(inliers);
    num = size(inliers,2);
    if num > previous_num
        previous_num = num;
        best_x = x;
        best_seedA = seedA;
        best_seedb = seedb;
    end
end
end