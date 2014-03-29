function G = energyFunction3(I)
%% Function energyFunction1: 
%  to get the gradient image using a Sobel operator
%  Input:
%       image (color or gray-level); 
%  Output:
%       G: energy map related to the input image

% compute the e1
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
    
 % compute the entropy energy over a 9*9 window and add it to e1
 for j = 2: imgW-1
     for i = 2:imgH-1
        tmp = I(i-1:i+1, j-1:j+1);
        value = entropy(tmp);
        G(i, j) = G(i, j) + value;
     end
 end

end

