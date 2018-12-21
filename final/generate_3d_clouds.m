function [ points_3d, points_ind ] = generate_3d_clouds( point_view_matrix, features, j_range )
%GENERATE_3D_CLOUDS Summary of this function goes here
%   Detailed explanation goes here
num = size(point_view_matrix,1);
points_3d = cell(size(j_range,2),num);
points_ind = cell(size(j_range,2),num);
% for recording the 3D point cloud of the castle; 3 represents three
% different numbers(two, three and four) of consecutive images in each image set
    
for j_ind = 1:size(j_range,2)
    j = j_range(j_ind);
    for i = 1:num
        ind = mod(i-1:i+j-2,num)+1;
        [points_3d{j_ind,i}, points_ind{j_ind,i}] = get_points(ind, point_view_matrix, features);
    end
end

end

