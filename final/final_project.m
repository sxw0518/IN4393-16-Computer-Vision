% This file is for the final project of IN4393-16 Computer Vision (2018).
% And this project contains several steps, of which the details can be
% found below.
%%
% The first step:Feature point detection,and the extraction of SIFT descriptors
directory = 'modelCastle_features';
images = dir(strcat(directory,'\*.png'));
num = size(images,1);
[features,descriptors] = extract_SIFT(directory,images);

%%
% The second step:Apply normalized 8-point RANSAC algorithm to find best matches
% 2.1 match descriptors of two consecutive images
[matches, match_points] = match_descriptor(features,descriptors,num);

%%
% 2.2 use normalized 8-point RANSAC algorithm to find best matches
iteration = 200; % the number of iteration for RANSAC
num_correspond = 8; % select at least 8 correspondences from matched descriptors
threshold = 100;
[best_matches,best_match_points] = normalRANSAC(matches,match_points,iteration,num_correspond,threshold,num);

%%
% The third step:Chaining:Create point_view matrix
point_view_matrix = create_pv_matrix(best_matches,num);

% Get the colour from the images for each point. Average the colors between the images. 
color_matrix = get_color(point_view_matrix,images,features);

%%
% The fourth step: Generating 3d points from the 2d points
% 4.1 estimate 3D coordinates of the points using affine structure from
% motion
consecutive_images = 3:4;
[points_3d, points_ind] = generate_3d_clouds(point_view_matrix, features, consecutive_images);

%%
% 4.2 Combine the different 3d point clouds into a single point cloud by
% finding the transformation function using points that are in both clouds.
[point_cloud, point_indexes] = stiching(points_3d, points_ind);

% Grab the colors corresponding to the points in the 3d point cloud.
point_colors = color_matrix(:, point_indexes);

%%
% Step six: Apply bundel adjustmant. Both on the 3d points and on the
% corresponding colours.
final_point_cloud = bundle_adjust(point_cloud, point_indexes);
final_point_colors = bundle_adjust(point_colors, point_indexes);

%%
% Additional step, cluster the points using single linkage. By selcting the
% largest cluster we are able to filter out some of the outliers and
% thereby improving our results.

% Set this to 1 to disable the clustering. Otherwise use it to finetune the
% model from the noise.
number_cluster = 1;

Z = linkage(final_point_cloud','single','chebychev');
clusters = cluster(Z,'maxclust',number_cluster);


% Selecting the biggest cluster
biggest_cluster = 0;
biggest_cluster_size = 0;

for i = 1:length(unique(clusters))
    cluster_size = sum(clusters==i);
    if cluster_size > biggest_cluster_size
        biggest_cluster = i;
        biggest_cluster_size = cluster_size;  
    end
end

% Only using the points and colors corresponding to the biggest cluster
cluster_points = final_point_cloud(:,clusters==biggest_cluster);
cluster_colors = final_point_colors(:,clusters==biggest_cluster);

%%

% ---- JUST FIGURES FROM HERE ---- END OF CODE ----

%%
% Prepare the variables
x = cluster_points(3,:)';
y = cluster_points(1,:)';
z = cluster_points(2,:)';
c = double(permute(cluster_colors,[2 1]))/255;

% Make a scatter plot of the 3d points with color
figure
scatter3(x,y,z,4,c)

% Make a plot of the 3d model with surface and color.
figure
k = boundary(x,y,z,1);
trisurf(k,x,y,z,'FaceVertexCData',c,'FaceColor','interp','EdgeColor','interp')
grid off
axis([-1000 1000 -1000 1000 -1000 1000])

%%
% Depicts the features of image i
figure
i = 19;
I = imread([directory, '/', images(i).name]);
imshow(I)
hold on
f = features{i};
scatter(f(:,1), f(:,2), 'r.')


%%
% Depicts the matches between image i and i+1 on image i
figure
i = 1;
I = imread([directory, '/', images(i).name]);
imshow(I)
hold on
f = match_points{1,i};
scatter(f(:,1), f(:,2), 'r.')

%%
% Depicts the best_matches between image i and i+1 on image i+1
figure
i = 1;
I = imread([directory, '/', images(i+1).name]);
imshow(I)
hold on
f = best_match_points{2,i};
scatter(f(:,1), f(:,2), 'r.')

%%
% Depict the features that are matched between images i,...,1+c-1
figure
c = 3;
i = 1;
I = imread([directory, '/', images(i).name]);
imshow(I)
hold on
col_index = min(point_view_matrix(i: i+c-1,:),[],1) ~= 0;
f = features{i}(point_view_matrix(i,col_index),:);
scatter(f(:,1), f(:,2), 'r.')
