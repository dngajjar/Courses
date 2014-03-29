
function G = energyFunction1(I)
%% Function energyFunction1: 
%  to get the gradient image
%  Input:
%       I: image (color or gray-level); 
%       (x, y): the coordinate to get its gradient
%  Output:
%       energy_point: the gradient value of a specific point indicated by coordinate (x,y)


    % get the size of the image
    if size(size(I),2) == 3
        [imgH, imgW, imgD] = size(I);
        % convert the image to double type
        I = double(I);
        for i = 1:imgD
            % get the horizontal and vertical gradient of the image
            [Gx(:,:,i), Gy(:,:,i)] = gradient(I(:,:,i));
            G(:,:,i) = abs(Gx(:,:,i))+abs(Gy(:,:,i));
        end

        % get the average of the gradient in RGB channels
            G = sum(G, 3)/3;
    else
        I = double(I);
        [Gx, Gy] = gradient(I);
        G = abs(Gx)+abs(Gy);
    end
end

