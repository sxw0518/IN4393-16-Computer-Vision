% the Lukas Kanade Tracker:
% the initial points in the first frams are tracked. In the video
% 'tracked.avi' this is shown, where yellow dots are the ground truth and
% pink dots are the tracked points
%%%You can also not follow this instrcution and implement the tracker
%%%according to your own interpretation!
function [pointsx, pointsy] = LKtracker(p,im,sigma)

%pre-alocate point locations and image depointsx = zeros(size(im,3),size(p,2));
pointsx = zeros(size(im,3),size(p,2));
pointsy = zeros(size(im,3),size(p,2));
pointsx(1,:) = p(1,:);
pointsy(1,:) = p(2,:);

%fill in starting points

It=zeros(size(im) - [0 0 1]);
Ix=zeros(size(im) - [0 0 1]);
Iy=zeros(size(im) - [0 0 1]);

%calculate the gaussian derivative
G = gaussian(sigma);
Gd = gaussianDer(G,sigma);

%find x,y and t derivative
for i=1:size(im,3)-1
    Ix(:,:,i)= conv2(conv2(im(:,:,i),Gd,'same'),G','same');
    Iy(:,:,i)= conv2(conv2(im(:,:,i),Gd','same'),G,'same');
    It(:,:,i)= im(:,:,i+1)-im(:,:,i);
end

% writerObj = VideoWriter('test.avi');
% open(writerObj);

for num = 1:size(im,3)-1 % iterating through images
    for i = 1:size(p,2) % iterating throught points
        % make a matrix consisting of derivatives around the pixel location
        x = floor(pointsx(num,i));                     %%%center of the patch
        y = floor(pointsy(num,i));                     %%%center of the patch
        A1 = reshape(Ix((y-7:y+7),(x-7:x+7),num)',225,1);
        A2 = reshape(Iy((y-7:y+7),(x-7:x+7),num)',225,1);
        A = [A1,A2];
        % make b matrix consisting of derivatives in time
        b = reshape(-It((y-7:y+7),(x-7:x+7),num)',225,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        v = pinv(A'*A)*A'*b;
        pointsx(num+1,i) = v(1)+ pointsx(num,i);
        pointsy(num+1,i) = v(2)+ pointsy(num,i);
    end
% %     %     figure(1)
% %     %     imshow(im(:,:,num),[])
% %     %     hold on
% %     %     plot(pointsx(num,:),pointsy(num,:),'.y') %tracked points
% %     %     plot(p(num*2-1,:),p(num*2,:),'.m')  %ground truth
% %     %     frame = getframe;
% %     %     writeVideo(writerObj,frame);
end
%close(writerObj);


end
