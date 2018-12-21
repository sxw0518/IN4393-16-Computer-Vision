%%
% 1 Harris corner detector
im = imread('landscape-a.jpg');
% im = im2double(im);
im = rgb2gray(im);
sigma = 2;
[r,c] = harris(im,sigma);
% alpha = (0:12);
% sigma = 12.^alpha;
% for i = 1:size(alpha,2)
%     [r,c] = harris(im,sigma(i));
% %     figure;
imshow(im);
hold on;
scatter(c,r,10);
% end
%%
%scale invariant
alpha = (0:12);
sigma = 1.2.^alpha;
im = imread('landscape-a.jpg');
% im = im2double(im);
im = rgb2gray(im);
% points = scale_invariant_harris(im,sigma);
points = scale_invariant_harris(im,sigma);
figure;
imshow(im);
hold on;
scatter(points(:,2),points(:,1),points(:,3));
hold off;
%% section 2 SIFT 
alpha = (0:12);
sigma = 1.2.^alpha;
im_a = imread('landscape-a.jpg');
im_a = rgb2gray(im_a);
im_b = imread('landscape-b.jpg');
im_b = rgb2gray(im_b);
points_a = scale_invariant_harris(im_a,sigma);
points_b = scale_invariant_harris(im_b,sigma);
[f1,d1] = vl_sift(single(im_a));
[f2,d2] = vl_sift(single(im_b));
figure;
imshow(im_a);
% imshow([im_a,im_b]);
hold on;
scatter(points_a(2,:),points_a(1,:));
% hold on;
% scatter(size(im_a,2)+points_b(1,:),points_b(2,:));
match_a = [];
match_b = [];
matches = vl_ubcmatch(d1, d2,10);
match_a = f1(:,matches(1,:));
match_b = f2(:,matches(2,:));
line([match_a(1,:);size(im_a,2)+match_b(1,:)],[match_a(2,:);match_b(2,:)]);

%%
alpha = (0:12);
sigma = 1.2.^alpha;
im_a = imread('landscape-a.jpg');
im_a = rgb2gray(im_a);
points_a = scale_invariant_harris(im_a,sigma);
im_b = imread('landscape-b.jpg');
im_b = rgb2gray(im_b);
points_b = scale_invariant_harris(im_b,sigma);
%%
figure;
imshow([im_a,im_b]);
hold on;
scatter(points_a(:,2),points_a(:,1),points_a(:,3));
% figure;
% imshow(im_b);
hold on;
scatter(size(im_a,2)+points_b(:,2),points_b(:,1),points_b(:,3));
%%
[f1,d1] = vl_sift(single(im_a));
[f2,d2] = vl_sift(single(im_b));
%%
match_a = [];
match_b = [];
matches = vl_ubcmatch(d1, d2, 10);
match_a = f1(:,matches(1,:));
match_b = f2(:,matches(2,:));
line([match_a(1,:);size(im_a,2)+match_b(1,:)],[match_a(2,:);match_b(2,:)]);
%%
threshold = 0.8;
match_a = [];
match_b = [];
for i = i:size(d1,2)
	match = [0 0];
	distance = Inf;
	second_distance = Inf;
	for j = 1:size(d2,2);
		dis = sqrt(sum(d1(:,i)-d2(:,j).^2));
		if dis<threshold
			if second_distance>dis
				if distance>dis
					second_distance = distance;
					distance = dis;
					mathc = [i j];
				else
					second_distance = dis;
				end
			end
		end
	end
	if distance/second_distance < 0.8
		match_a = [match_a, f1(:,match(1))];
		match_b = [match_b, f2(:,match(2))];
	end
end
line([match_a(1,:);size(im_a,2)+match_b(1,:)],[match_a(2,:);match_b(2,:)]);