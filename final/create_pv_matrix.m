function point_view_matrix = create_pv_matrix(best_matches,num)
% This function is for creating point-view matrix for all consecutive
% castle images. The point-view matrix has views in the rows, and points in
% the columns.
% Input: indices of the best matched points; the number of images;
% Output: point-view matrix for all consecutive castle images.
point_view_matrix = zeros(num,0);
for i = 1:num
    if i == 1
        point_view_matrix(i,1:size(best_matches{i},2)) = best_matches{i}(1,:)';
        point_view_matrix(i+1,1:size(best_matches{i},2)) = best_matches{i}(2,:)';
    else
        if i < num
            previous_match = point_view_matrix(i,:);
            % already appearing correspondence
            [~,IA,IB] = intersect(best_matches{i}(1,:)',previous_match);
            matrix = best_matches{i}(2,:);
            point_view_matrix(i+1,IB) = matrix(IA);
            % new matching points
            [difference, IA] = setdiff(best_matches{i}(1,:)',previous_match);
            temp = size(point_view_matrix,2);
            point_view_matrix = [point_view_matrix zeros(num,size(difference,1))];
            point_view_matrix(i,temp+1:end) = difference';
            point_view_matrix(i+1,temp+1:end) = matrix(IA);
        else
            previous_match_num = point_view_matrix(i,:);
            previous_match_1 = point_view_matrix(1,:);
            % correspondences appear in preivous_num not previous_1
            [~,IA_0,IB_0] = intersect(best_matches{i}(1,:)',previous_match_num);
            [difference1_,~] = setdiff(best_matches{i}(2,:)',previous_match_1);
            [~,IA10,IB10] = intersect(previous_match_num(IB_0),difference1_);
            point_view_matrix(1,IB_0(IA10)) = difference1_(IB10);
            % correspondences appear in previous_1 not previous_num
            [~,IA0_,IB0_] = intersect(best_matches{i}(2,:)',previous_match_1);
            [difference_1,~] = setdiff(best_matches{i}(1,:)',previous_match_num);
            [~,IA01,IB01] = intersect(previous_match_1(IB0_),difference_1);
            point_view_matrix(num,IB0_(IA01)) = difference_1(IB01);
            % correspondences appearing both previous ones
            [~,IA00,IB00] = intersect(best_matches{i}(1,IA_0),best_matches{i}(2,IA0_));
            IB1 = IB_0(IA00,:);
            IB2 = IB0_(IB00,:);
            point_view_matrix(:,IB2) = max(point_view_matrix(:,IB1),point_view_matrix(:,IB2));
            point_view_matrix(:,IB1) = [];
            % new correspondences for both previous ones
            [~,IA11,IB11] = intersect(difference1_,difference_1);
            temp = size(point_view_matrix,2);
            point_view_matrix = [point_view_matrix zeros(num,size(IA11,1))];
            point_view_matrix(i,temp+1:end) = difference1_(IA11);
            point_view_matrix(1,temp+1:end) = difference_1(IB11);
        end
    end
end
end