function color_matrix = get_color(point_view_matrix,images,features)

%%
num_points = size(point_view_matrix,2);
color_matrix = zeros(3,num_points);
color_count = zeros(1,num_points);
num = size(images,1);
for i = 1:num
    im = imread([images(i).folder,'/',images(i).name]);
    ind = find(point_view_matrix(i,:)~=0);
    points_ind = point_view_matrix(i,ind);
    for j = 1:length(points_ind)
        coordinates = floor(features{i}(points_ind(j),:));
        
        color_matrix(:,ind(j)) = color_matrix(:,ind(j)) + double(squeeze(im(coordinates(:,2),coordinates(:,1),:)));
        color_count(:,ind(j)) = color_count(:,ind(j)) + 1;
    end
end
color_matrix = uint8(color_matrix./color_count);
end