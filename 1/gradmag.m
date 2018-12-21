function [magnitude,orientation] = gradmag(img, sigma)
im = rgb2gray(img);
G = gaussian(sigma);
Gd = gaussianDer(G,sigma);
[row,column] = size(im);
G_x = zeros(size(im));
G_y = zeros(size(im));
% G_x = conv2(im,Gd,'same');
% G_y = conv2(im,Gd','same');
for i = 1:column
    G_x(:,i) = conv(im(:,i),Gd,'same');
end
for i = 1:row
    G_y(i,:) = conv(im(i,:),Gd,'same');
end
magnitude = sqrt(G_x.^2+G_y.^2);
orientation = atan2(G_y,G_x);
end