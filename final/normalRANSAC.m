function [best_matches,best_match_points] = normalRANSAC(matches,match_points,iteration,num_correspond,threshold,num)
% This function is to select the best matches from matched descriptors.
% Given two consecutive images and their matches, the fundamental matrix
% and the best matches of two imaes should satisfy the epipolar geometry.
% And this function the normalized eight-point algorithm with RANSAC to
% select the inliers of two consecutive images.
% Input: index of matched decriptors; the homogeneous coordinates of
% matched points; the number of iteration of RANSAC; the number of
% correspondences for fundamental matrix estimation; threshold for RANSAC;
% the number of images;
% Output: index of best matched descriptors(best_matches); the homogeneous
% coordinates of best matched points(best_match_points).
best_matches = cell(1,num);
best_match_points = cell(2,num);
F = cell(1,num);
for i = 1:num
    num_best_inliers = 0;
    best_inliers = [];
    for round = 1:iteration
        match_num = size(match_points{1,i},1);
        random_index = randperm(match_num);
        p1 = match_points{1,i}(random_index(1:num_correspond),:);
        p2 = match_points{2,i}(random_index(1:num_correspond),:);
        F{i} = create_fundamental_matrix(p1,p2);
        num_inliers = 0;
        inliers = [];
        for j = 1:match_num
            dis = SampsonDist(match_points{1,i}(j,:),match_points{2,i}(j,:),F{i});
            if dis < threshold
                num_inliers = num_inliers + 1;
                inliers = [inliers,j];
            end
        end
        if num_inliers > num_best_inliers
            num_best_inliers = num_inliers;
            best_inliers = inliers;
        end
    end
    best_matches{i} = matches{i}(:,best_inliers);
    best_match_points{1,i} = match_points{1,i}(best_inliers,:);
    best_match_points{2,i} = match_points{2,i}(best_inliers,:);
    F{i} = create_fundamental_matrix(best_match_points{1,i},best_match_points{2,i});
end
end