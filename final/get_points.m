function [ points_3d, point_indexes] = get_points( indexes, point_view_matrix, features )

j = size(indexes, 2);
points_indx = point_view_matrix(indexes,:);
% find columns do not contain 0
column_id = find(min(points_indx)~=0);
num_column = size(column_id,2);
% if the number of columns is smaller than 3;
% because the rank of the measurement matrix must have to be 3
if num_column < 3
    points_3d = [];
    point_indexes = [];
else
    points_indx = points_indx(:,column_id);
    measurement_matrix = zeros(2*j,num_column);
    for p = 1:j
        for q = 1:num_column
            measurement_matrix(2*p-1,q) = features{indexes(p)}(points_indx(p,q),1);
            measurement_matrix(2*p,q) = features{indexes(p)}(points_indx(p,q),2);
        end
    end
    [~,S] = estimate_3d(measurement_matrix);
    points_3d = S;
    if size(points_3d,2)== 0 
        point_indexes = [];
    else
        point_indexes = column_id;
    end
end
end

