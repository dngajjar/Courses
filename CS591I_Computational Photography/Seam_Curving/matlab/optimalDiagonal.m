function [value, im_size, M] = optimalDiagonal(image, r, c, energyFunc)
%% Function optimalDiagonal is to find the totally minimal reduced energy 
%  of cutting indicated numbers of rows and cols
%  Input:
%       image: the input image required to be modifed
%       newH, newW: the new size of the image
%   Output:
%       im_size: the output image conducted the optimal diagonal cutting
%       seams

    if size(size(image),2) == 3 %color image
       [imgH, imgW, imgD] = size(image);
       im_size = image; %copy the image
       %tmp = image;
       %indicate which of the two options (horizontal VS vertical) was to
       %choose; 
       %left neighbor corresponds to a vertical seam removal
       %top neighbor corresponds to a horizontal seam removal
       M=zeros(r+10, c+10); 
       
       if c == 0 && r == 0 %no change need to make
           disp('Original sized image.')
           return;
       end
       % initialize the values in matrix      
       
          
        value = 0;
        i = 1;
        j = 1;
        h = 1;
        w = 1;
        while i<=r && j<=c
              G = energyFunc(im_size);
              [min_horiz, v_Horiz] = findSeam_horizontal(G);
              [min_vert, v_Vert] = findSeam_vertical(G);
              if (value+min_horiz)> (value+min_vert)
                  value = value+min_vert;
                  im_size = removeSeam(im_size, v_Vert, 'vertical');
                  i=i+1; 
                  h = h+1;
                  M(h, w) = 1;
                 
                 % disp('vertical');
                 % disp(value);
              else
                  value = value+min_horiz;
                  im_size = removeSeam(im_size, v_Horiz, 'horizontal');
                  j=j+1;
                  w = w+1;
                  M(h, w) = 1;
                  
                 % disp('horizontal');
                 % disp(value);
              end
        end
       if j>c 
           % find and cut vertical seams
           for l = i:r
               G = energyFunc(im_size);
               [min_vert, v_Vert] = findSeam_vertical(G);
               value= value+min_vert;
               im_size = removeSeam(im_size, v_Vert, 'vertical');
              % disp('vertical');disp(value);
               h = h+1; 
               M(h, w) = 1;
               
           end
       end
       if i>r
           
           % find and cut horizontal seams
           for l = j:c
               G = energyFunc(im_size);
               [min_horiz, v_Horiz] = findSeam_horizontal(G);
               value= value+min_horiz;
               im_size = removeSeam(im_size, v_Horiz, 'horizontal');
              % disp('horizontal');disp(value);
              w = w+1;
              M(h, w) = 1;
              
           end
       end
    end
end



