function [matches, match_points] = match_descriptor(features,descriptors,num)
% This function is to match descriptors of two consecutive images.
% Input: the coordinates of interest points; the SIFT descriptors around
% the interest points; the number of images;
% Output: the index of matched points(matches); the homogeneous coordinates
% of matched points by pairs of consecutive images(match_points).
matches = cell(1,num);
match_points = cell(2,num);
for this = 1:num
    that = mod(this,num) + 1;
    
    [matches{this},~] = vl_ubcmatch(descriptors{this}',descriptors{that}');
    match_points{1,this} = features{this}(matches{this}(1,:),:);
    match_points{2,this} = features{that}(matches{this}(2,:),:);
    match_num = size(match_points{1,this},1);
    match_points{1,this} = [match_points{1,this},ones(match_num,1)];
    match_points{2,this} = [match_points{2,this},ones(match_num,1)];
end
end