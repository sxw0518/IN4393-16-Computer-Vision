%% image alignment
im1 = imread('boat/img1.pgm');
im2 = imread('boat/img2.pgm');
im1 = single(im1);
im2 = single(im2);
%%
[frames1,desc1] = vl_sift(im1);
[frames2,desc2] = vl_sift(im2);
matches = vl_ubcmatch(desc1,desc2,35);
match_1 = frames1(:,matches(1,:));
match_2 = frames2(:,matches(2,:));
%%
P = 3;
numT = size(matches,2);
num = size(match_1,2);
transformed_points = zeros(2,num);
threshold = 10;
previous_num = 0;
N = 50;
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
        best_A = seedA;
        best_b = seedb;
        best_transform = transformed_points;
        best_i = i;
    end
end
%%
imshow([imread('boat/img1.pgm'),imread('boat/img2.pgm')]);
hold on;
line([match_1(1,:);size(im1,2)+best_transform(1,:)],[match_1(2,:);best_transform(2,:)]);
%%
T = [best_x(1) best_x(2) best_x(5);
    best_x(3) best_x(4) best_x(6);
    0 0 1];
tform = maketform('affine',T');
image1_transformed = imtransform(im1,tform,'bicubic');
tform = maketform('affine',inv(T)');
image2_transformed = imtransform(im2,tform,'bicubic');
%%
figure;
subplot(2,2,1);
imshow(imread('boat/img1.pgm'),[]);
title('image 1');
subplot(2,2,2);
imshow(imread('boat/img2.pgm'),[]);
title('image 2');
subplot(2,2,3);
imshow(image1_transformed,[]);
title('image 1 transformed to image 2');
subplot(2,2,4);
imshow(image2_transformed,[]);
title('image 2 transformed to image 1');
%% image stitching
im1 = imread('left.jpg');
im2 = imread('right.jpg');
im1 = single(rgb2gray(im1));
im2 = single(rgb2gray(im2));
%%
P = 3;
N = 100;
[best_x,inliers,best_seedA,best_seedb] = im_affine(im1,im2,P,N);
T = [best_x(1) best_x(2) best_x(5);
    best_x(3) best_x(4) best_x(6);
    0 0 1];
tform = maketform('affine',T');
image1_transformed = imtransform(im1,tform,'bicubic');
tform = maketform('affine',inv(T)');
image2_transformed = imtransform(im2,tform,'bicubic');
%%
figure;
subplot(2,2,1);
imshow(im1,[]);
title('image 1');
subplot(2,2,2);
imshow(im2,[]);
title('image 2');
subplot(2,2,3);
imshow(image1_transformed,[]);
title('image 1 transformed to image 2');
subplot(2,2,4);
imshow(image2_transformed,[]);
title('image 2 transformed to image 1');
%%
mean1 = round(mean(best_seedA,2));
mean2 = round(mean(best_seedb,2));
temp_image = zeros(size(im2));
temp_image(mean2(2), mean2(1)) = 255;
temp_transformed = imtransform(temp_image,tform,'bicubic');
[~,ind] = max(temp_transformed(:));
[mean2_t(2) ,mean2_t(1)] = ind2sub(size(temp_transformed),ind);
top = mean2_t(2) - mean1(2);
left = mean2_t(1) - mean1(1);
right = size(image2_transformed,2) - mean2_t(1) - size(im1,2) + mean1(1);
bottom = size(image2_transformed,1) - mean2_t(2) - size(im1,1) + mean1(2);
estimated_y = size(im1,1) + max(top, 0) + max(bottom, 0);
estimated_x = size(im1,2) + max(left, 0) + max(right, 0);
new_image = zeros(estimated_y, estimated_x);
new_image(max(-top,1):min(end, max(-top,1) + size(image2_transformed,1) - 1), max(-left,1):min(end, max(-left,1) + size(image2_transformed,2) - 1)) = image2_transformed(1:min(end, estimated_y - max(-top,1) + 1), 1:min(end, estimated_x - max(-left,1)+1));
space_needed = double(im1(1:min(end, estimated_y - max(top,1) + 1), 1:min(end, estimated_x - max(left,1)+1)));
space_available = new_image(max(top,1):min(end, max(top,1) + size(im1,1) - 1), max(left,1):min(end, max(left,1) + size(im1,2) - 1));
new_image(max(top,1):min(end, max(top,1) + size(im1,1) - 1), max(left,1):min(end, max(left,1) + size(im1,2) - 1)) = max(space_needed, space_available);
figure;
% imshow(image2_transformed,[]);
imshow(new_image,[]);

