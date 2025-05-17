% Local Histogram Equalization with Complete Visualization

% Step 1: Read the input image
img = imread('input1.jpg');  % Replace with your image file

% Step 2: Show original image
figure;
subplot(2,3,1);
imshow(img);
title('Original Image');

% Step 3: Convert to grayscale if needed
if size(img, 3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end

% Step 4: Convert to uint8 if needed
if ~isa(gray_img, 'uint8')
    gray_img = im2uint8(gray_img);
end

% Step 5: Show grayscale image
subplot(2,3,2);
imshow(gray_img);
title('Grayscale Image');

% Step 6: Local histogram equalization
local_eq_img = adapthisteq(gray_img, 'NumTiles', [8 8], 'ClipLimit', 0.01);

% Step 7: Show locally histogram-equalized image
subplot(2,3,3);
imshow(local_eq_img);
title('Locally Histogram Equalized');

% Step 8: Show histogram of grayscale image
subplot(2,3,5);
imhist(gray_img);
title('Histogram of Grayscale');

% Step 9: Show histogram of equalized image
subplot(2,3,6);
imhist(local_eq_img);
title('Histogram after Local Equalization');
