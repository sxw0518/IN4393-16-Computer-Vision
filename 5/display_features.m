function display_features(file1,imf1,dx,dy)
%
%Displays affine regions on the image
%
%disp_features(file1,imf1,dx,dy)
%
%file1 - 'filename' - ASCII file with affine regions
%imf1 - 'filename'- image
%dx - shifts all the regions in the image by dx  
%dy - shifts all the regions in the image by dy
%
%example:
%disp_features('img1.haraff','img1.ppm',0,0)

[feat1 nb dim]=loadFeatures(file1);
clf;imshow(imf1);
for c1=1:nb,%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drawellipse([feat1(3,c1) feat1(4,c1); feat1(4,c1) feat1(5,c1) ], feat1(1,c1)+dx, feat1(2,c1)+dy,'y');
end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
