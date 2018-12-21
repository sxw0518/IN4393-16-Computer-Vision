function F = estifundamentalM()
%%
filename1 = 'extract_features/obj02_001.png.haraff.sift';
filename2 = 'extract_features/obj02_002.png.haraff.sift';
point1 = importdata(filename1, ' ', 2);
point2 = importdata(filename2, ' ',2);
desc1 = point1.data(:,6:end);
desc2 = point2.data(:,6:end);
coor1 = point1.data(:,1:2);
coor2 = point2.data(:,1:2);
[matches,scores] = vl_ubcmatch(desc1',desc2');
%%
coor1 = coor1(matches(1,:),:);
coor2 = coor2(matches(2,:),:);
num = size(coor1,1);
coor1 = [coor1,ones(num,1)];
coor2 = [coor2,ones(num,1)];
%%
N = 100;
L = 20;
bestInliers = 0;
bestInti = [];
threshold = 1;
for round=1:N
    %select only the top L of the permutated points
    permutation = randperm(num);
    p1p = coor1(permutation(1:L),:);
    p2p = coor2(permutation(1:L),:);

    % this function creates the Fundamental Matrix out of 8 point
    F=create_fundamental_matrix(p1p,p2p);
    inliers = 0;
    inti = [];
    for i=1:num
        Dis = SampsonDist(coor1(i,:),coor2(i,:),F);
        if Dis < threshold
            inliers = inliers +  1;
            inti = [inti,i];
        end
    end

    %If the current estimate improves the best estimate replace the
    %current estimate
    if inliers > bestInliers
        bestInliers = inliers;
        bestP1 = p1p;
        bestP2 = p2p;
        bestInti = inti;
    end
end
%%
F = create_fundamental_matrix(coor1(bestInti,:),coor2(bestInti,:));
%%
im1 = imread('obj02_001.png');
im2 = imread('obj02_002.png');
imshow([im1,im2]);
hold on;
%plot([bestP1(:,1),bestP2(:,1)+size(im1,2)]',[bestP1(:,2),bestP2(:,2)]');
%%
for i = 1:7
    trans = bestP2(i,:)*F;
    a=trans(1); 
    b=trans(2); 
    c=trans(3);
    x = [1,size(im1,2)];
    y = -a/b*x-c/b;
    plot(x,y)
end

for i = 1:7
    trans = F*bestP1(i,:)';
    a=trans(1); 
    b=trans(2); 
    c=trans(3);
    x = [1,size(im1,2)];
    y = -a/b*x-c/b;
    plot(x+size(im1,2),y)
end
end