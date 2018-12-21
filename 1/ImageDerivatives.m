function F = ImageDerivatives(img, sigma, type)
% img = rgb2gray(img);
G = gaussian(sigma);
Gd = gaussianDer(G,sigma);
x = -3*sigma:3*sigma;
Gd2 = (x.^2-sigma^2).*G/sigma^4;
switch type
    case 'x'
        F = conv2(img,Gd,'same');
    case 'y'
        F = conv2(img,Gd','same');
    case 'xx'
        F = conv2(img,Gd2,'same');
    case 'yy'
        F = conv2(img,Gd2','same');
    case 'xy'
        G_x = conv2(img,Gd,'same');
        F = conv2(G_x,Gd','same');
    case 'yx'
        G_x = conv2(img,Gd,'same');
        F = conv2(G_x,Gd','same');
end
% if type == 'y'
%     mess = type;
%     G = gaussian(sigma);
%     Gd = gaussianDer(G,sigma);
%     F = zeros(size(img));
%     F = conv2(img,Gd','same');
% else
% if type == 'xx'
%     mess = type;
%     G = gaussian(sigma);
%     x = -3*sigma:3*sigma;
%     Gd2 = (x.^2-sigma^2).*G/sigma^4;
%     F = zeros(size(img));
%     F = conv2(img,Gd2,'same');
% else
% if type == 'yy'
%     mess = type;
%     G = gaussian(sigma);
%     x = -3*sigma:3*sigma;
%     Gd2 = (x.^2-sigma^2).*G/sigma^4;
%     F = zeros(size(img));
%     F = conv2(img,Gd2','same');
% else
% if type == 'xy'|'yx'
%     mess = type;
%     G = gaussian(sigma);
%     Gd = gaussianDer(G,sigma);
%     G_x = conv2(img,Gd,'same');
%     F = conv2(G_x,Gd','same');
% %     F = sqrt(G_x.^2+G_y.^2);
% end
% if type == 'x'
%     mess = type;
%     G = gaussian(sigma);
%     Gd = gaussianDer(G,sigma);
%     F = zeros(size(img));
%     F = conv2(img,Gd,'same');
% end
end