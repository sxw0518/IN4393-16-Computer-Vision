function matching_teddy()
% This function is created for IN4393-16 Computer Vision
% Lab Exercise 6: Chaining, 1 Matching, 2 Chaining
% This function creates matches between all 16 consecutive teddy bear
% images
%% Detect interest points, extract SIFT descriptors, concatenate SIFT
num = 16;
har_file = cell(1,num);
hes_file = cell(1,num);
har_point = cell(1,num);
hes_point = cell(1,num);
har_des = cell(1,num);
hes_des = cell(1,num);
har_coor = cell(1,num);
hes_coor = cell(1,num);
descriptor = cell(1,num);
feature = cell(1,num);
for i =1:num
    har_file{i} = ['extract_features/obj02_',num2str(i,'%03d'),'.png.haraff.sift'];
    hes_file{i} = ['extract_features/obj02_',num2str(i,'%03d'),'.png.hesaff.sift'];
    har = importdata(har_file{i},' ',2);
    hes = importdata(hes_file{i},' ',2);
    har_des{i} = har.data(:,6:end);
    hes_des{i} = hes.data(:,6:end);
    har_coor{i} = har.data(:,1:2);
    hes_coor{i} = hes.data(:,1:2);
    har_point{i} = har.data;
    hes_point{i} = hes.data;
    feature{i} = [har_coor{i};hes_coor{i}];
    descriptor{i} = [har_des{i};hes_des{i}];
end
%% Match descriptors of two consecutive images
match_points = cell(2,num);
matches = cell(1,num);
for i = 1:num
    if i < num
        [matches{i},scores] = vl_ubcmatch(descriptor{i}',descriptor{i+1}');
        match_points{1,i} = feature{i}(matches{i}(1,:),:);
        match_points{2,i} = feature{i+1}(matches{i}(2,:),:);
        match_num = size(match_points{1,i},1);
        match_points{1,i} = [match_points{1,i},ones(match_num,1)];
        match_points{2,i} = [match_points{2,i},ones(match_num,1)];
    else
        [matches{i},scores] = vl_ubcmatch(descriptor{i}',descriptor{1}');
        match_points{1,i} = feature{i}(matches{i}(1,:),:);
        match_points{2,i} = feature{1}(matches{i}(2,:),:);
        match_num = size(match_points{1,i},1);
        match_points{1,i} = [match_points{1,i},ones(match_num,1)];
        match_points{2,i} = [match_points{2,i},ones(match_num,1)];
    end
    
end
%% Normalized eight-point with RANSAC; Construct point-view matrix
newmatches = cell(2,num);
N = 100;
L = 8;
threshold = 50;
F = cell(1,num);
point_view_matrix = zeros(num,1);
for i = 1:num
    bestInliers = 0;
    bestInti = [];
    for round = 1:N
        match_num = size(match_points{1,i},1);
        permutation = randperm(match_num);
        p1p = match_points{1,i}(permutation(1:L),:);
        p2p = match_points{2,i}(permutation(1:L),:);
        F{i} = create_fundamental_matrix(p1p,p2p);
        inliers = 0;
        inti = [];
        for j = 1:match_num
            Dis = SampsonDist(match_points{1,i}(j,:),match_points{2,i}(j,:),F{i});
            if Dis<threshold
                inliers = inliers + 1;
                inti = [inti,j];
            end
        end
        if inliers>bestInliers
            bestInliers = inliers;
            best1 = p1p;
            best2 = p2p;
            bestInti = inti;
        end
    end
    newmatch = matches{i}(:,bestInti);
    newmatches{1,i} = newmatch(1,:);
    newmatches{2,i} = newmatch(2,:);
    F{i} = create_fundamental_matrix(match_points{1,i}(bestInti,:),match_points{2,i}(bestInti,:));
    if i<2
        point_view_matrix(i,1:bestInliers) = newmatches{1,i}';
        point_view_matrix(i+1,1:bestInliers) = newmatches{2,i}';
    else
        if i<num
            previous_match = point_view_matrix(i,:);
            % already appearing correspondence
            [~,IA,IB] = intersect(newmatches{1,i}',previous_match);
            point_view_matrix(i+1,IB) = newmatches{2,i}(IA);
            % new matching points
            [difference, IA] = setdiff(newmatches{1,i}',previous_match);
            temp = size(point_view_matrix,2);
            point_view_matrix = [point_view_matrix zeros(num,size(difference,1))];
            point_view_matrix(i,temp+1:end) = difference';
            point_view_matrix(i+1,temp+1:end) = newmatches{2,i}(IA);
        else
            previous_match_num = point_view_matrix(i,:);
            previous_match_1 = point_view_matrix(1,:);
            % correspondences appear in preivous_num not previous_1
            [~,IA_0,IB_0] = intersect(newmatches{1,i}',previous_match_num);
            [difference1_,IA1_] = setdiff(newmatches{2,i}',previous_match_1);
            [~,IA10,IB10] = intersect(previous_match_num(IB_0),difference1_);
            point_view_matrix(1,IB_0(IA10)) = difference1_(IB10);
            % correspondences appear in previous_1 not previous_num
            [~,IA0_,IB0_] = intersect(newmatches{2,i}',previous_match_1);
            [difference_1,IA_1] = setdiff(newmatches{1,i}',previous_match_num);
            [~,IA01,IB01] = intersect(previous_match_1(IB0_),difference_1);
            point_view_matrix(num,IB0_(IA01)) = difference_1(IB01);
            % correspondences appearing both previous ones
            [~,IA00,IB00] = intersect(IA_0,IA0_);
            IB1 = IB_0(IA00,:);
            IB2 = IB0_(IB00,:);
            point_view_matrix(:,IB2) = point_view_matrix(:,IB1) + point_view_matrix(:,IB2);
            point_view_matrix(:,IB1) = [];
            % new correspondences for both previous ones
            [~,IA11,IB11] = intersect(difference1_,difference_1);
            temp = size(point_view_matrix,2);
            point_view_matrix = [point_view_matrix zeros(num,size(IA11,1))];
            point_view_matrix(i,temp+1:end) = difference1_(IA11);
            point_view_matrix(1,temp+1:end) = difference_1(IB11);
        end
    end
end
end










