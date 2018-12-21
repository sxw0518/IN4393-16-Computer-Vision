function [coordinates,T] = normalizePoints(coordinates)
%find mean and variance
m= mean(coordinates(:,1:2));
d = mean(sqrt( (coordinates(:,1)-m(1)).^2 + (coordinates(:,2)-m(2)).^2 ));
%construct matrix for normalization
T = [sqrt(2)/d 0 -m(1)*sqrt(2)/d;0 sqrt(2)/d -m(2)*sqrt(2)/d;0 0 1];
%Apply normalization on homogeneous coordinates
for i=1:size(coordinates,1)
    coordinates(i,:) = T*coordinates(i,:)';
end
end