function [ final_3d_points ] = bundle_adjust( points, indexes )
%BUNDLE_ADJUST Applies bundel adjustment to each point.

index_values = unique(indexes);
final_3d_points = zeros(3,length(index_values));
for i = 1:length(index_values)
    values = points(:,indexes == index_values(i));
    final_3d_points(:,i) = mean(values,2);
    
%     When we try to minimize the sum of the squares of the euclidean
%     distances, we get the exact same value as taking the mean. This shows
%     that our math is correct.
%     fun = @(x)sum(sum((values-x).^2));
%     x1 = fminsearch(fun,[0;0;0])
end

end

