function [features,descriptors] = extract_SIFT(directory, images)
% The function is to extract the SIFT descriptors of castle images.
% Input: directory where Harris and Hessian interest points are stored, the
% number of images;
% Output: the coordinates of interst points(features); the SIFT descriptors
% around the interest points(descriptors).
num = size(images,1);
features = cell(1,num);
descriptors = cell(1,num);
for i = 1:num
    har_file = [directory, '/', images(i).name, '.haraff.sift'];
    hes_file = [directory, '/', images(i).name, '.hesaff.sift'];
%     har_file = [directory,'/8ADT8',num2str(i+585,'%03d'),'.png.haraff.sift'];
%     hes_file = [directory,'/8ADT8',num2str(i+585,'%03d'),'.png.hesaff.sift'];
    har = importdata(har_file,' ',2);
    hes = importdata(hes_file,' ',2);
    har_fea = har.data(:,1:2);
    hes_fea = hes.data(:,1:2);
    har_des = har.data(:,6:end);
    hes_des = hes.data(:,6:end);
    % concatenate SIFT descriptors extracted for the same image(Harris and Hessian)
    features{i} = [har_fea;hes_fea];
    descriptors{i} = [har_des;hes_des];
end
end