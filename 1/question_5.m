%%5.1
img = im2double(imread('zebra.png'));
sigma = 2;
[magnitude,orientation] = gradmag(img,sigma);
% imshow(magnitude);
% figure;
imshow(orientation, [-pi,pi]);
colormap(hsv);
colorbar;
figure;
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
    G_y(i,:) = conv(im(i,:),Gd','same');
end
[x,y] = meshgrid(1:row,1:column);
quiver(x,y,G_x,G_y);
%% 5.2
figure;
for i = 1:6
    sigma = 2;
    sigma = sigma*i;
    [magnitude,orientation] = gradmag(img,sigma);
    subplot(3,2,i);
    imshow(orientation, [-pi,pi]);
    title(sigma);
end
figure
for i = 1:6
    sigma = 2;
    sigma = sigma*i;
    [magnitude,orientation] = gradmag(img,sigma);
    subplot(3,2,i);
    imshow(magnitude);
    title(sigma);
end
%% 5.3
% threshold (0.04~0.05) for sigma = 2
% threshold (0.03~0.04) for sigma = 3
% larger sigma, smaller threshold
threshold = 0.04;
sigma = 3;
figure;
[magnitude,orientation] = gradmag(img,sigma);
imshow(magnitude);
figure
magnitude(magnitude<threshold) = 0;
magnitude(magnitude>0) = 1;
imshow(magnitude);
%% 5.5
figure;
sigma = 100;
impulse_im = zeros([51,51]);
impulse_im(26,26) = 1;
imshow(impulse_im);
figure;
F = ImageDerivatives(impulse_im, sigma, 'x');

subplot(2,3,1);
imshow(F,[]);
title('x');
F = ImageDerivatives(impulse_im, sigma, 'y');

subplot(2,3,2);
imshow(F,[]);
title('y');
F = ImageDerivatives(impulse_im, sigma, 'xy');

subplot(2,3,3);
imshow(F,[]);
title('xy or yx');
F = ImageDerivatives(impulse_im, sigma, 'xx');

subplot(2,3,4);
imshow(F,[]);
title('xx');
F = ImageDerivatives(impulse_im, sigma, 'yy');

subplot(2,3,5);
imshow(F,[]);
title('yy');
