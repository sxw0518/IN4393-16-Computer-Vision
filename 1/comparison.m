imshow('zebra.png');
figure
im_gaussian = gaussianConv('zebra.png',2,2);
imshow(im_gaussian);
figure
G = fspecial('gaussian',10,2);
im = im2double(imread('zebra.png'));
[row,column,channel] = size(im);
for i = 1:channel
    imOut(:,:,i) = conv2(im(:,:,i),G,'same');
end
imshow(imOut);