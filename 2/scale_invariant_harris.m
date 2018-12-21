function points = scale_invariant_harris(im,sigma)
lapla_scno = zeros(size(im,1),size(im,2),size(sigma,2));
harris_corner = zeros(0,3);
for i = 1:size(sigma,2)
    [r,c] = harris(im,sigma(i));
    num_harris = size(r,1);
    harris_corner(end+1:end+num_harris,:) = [r,c,ones(num_harris,1)*i];
    lapla_scno(:,:,i) = sigma(i)*sigma(i)*imfilter(im,fspecial('log',ceil(sigma(i)*6+1), sigma(i)),'replicate','same'); 
end
num_corner = size(harris_corner,1);
number = 0;
points = zeros(num_corner,3);
for i = 1:num_corner
    r = harris_corner(i,1);
    c = harris_corner(i,2);
    s = harris_corner(i,3);
    val = lapla_scno(r,c,s);
    if s == 1
        if val > lapla_scno(r,c,2)
            number = number + 1;
            points(number,:) = harris_corner(i,:);
        end
    elseif s == size(sigma,2)
        if val > lapla_scno(r,c,s-1)
           number = number + 1;
           points(number,:) = harris_corner(i,:);
        end
    elseif s>1 && s<size(sigma,2)
        if val > lapla_scno(r,c,s-1) && val > lapla_scno(r,c,s+1)
           number = number + 1;
           points(number,:) = harris_corner(i,:);
        end
    end
end
points(number+1:end,:) = [];
end