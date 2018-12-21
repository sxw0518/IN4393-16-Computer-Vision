function imOut = gaussianConv(image_path, sigma_x, sigma_y)
im = im2double(imread(image_path));
[row,column,channel] = size(im);
imOut = zeros(size(im));
gaussian_x = gaussian(sigma_x,row);
gaussian_y = gaussian(sigma_y,column)';
gaussian_2d = gaussian_y*gaussian_x;
for i = 1:channel
    imOut(:,:,i) = conv2(im(:,:,i), gaussian_2d, 'same');
end
end