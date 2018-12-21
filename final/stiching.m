function [ best_points, best_ind ] = stiching( points_3d, points_ind )

cols = size(points_3d,2);
rows = size(points_3d,1);

best_points = [];
best_ind = [];
best_size = 0;

for view = 1:cols
    for set = 1:rows
        if ~isempty(points_3d{set,view})
            stiched_points = [points_3d{set,view}];
            stiched_ind = [points_ind{set,view}];
            newly_added = true;
            while newly_added
                newly_added = false;
                for j = 1:rows
                    for i = 1:cols
                        ind = points_ind{j,i};
                        points = points_3d{j,i};
                        [intersection_points, intersection_ind_local, intersection_ind_global] = intersect(ind, stiched_ind);
                        if size(intersection_points,2) > 9 && size(intersection_points,2) < length(ind)
                            newly_added = true;
                            X = stiched_points(:,intersection_ind_global);
                            Y = points(:, intersection_ind_local);
                            [~,~,transform] = procrustes(X',Y');            
                            c = repmat(transform.c(1,:),size(points,2),1);
                            transformed_points = (transform.b*points'*transform.T + c)';

                            stiched_points = [stiched_points transformed_points];
                            stiched_ind = [stiched_ind ind];
                        end
                    end
                end
            end
            if length(stiched_ind) > best_size
                best_size = length(stiched_ind);
                best_points = stiched_points;
                best_ind = stiched_ind;
            end
        end
    end
end
end

