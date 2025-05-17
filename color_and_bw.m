% Local Histogram Equalization for Color or Grayscale Images

% Step 1: Read the input image
img = imread('inputColor1.jpg');  % Replace with your image file

% Step 2: Convert to grayscale if it's an RGB image
if size(img, 3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end

% Step 3: Ensure the grayscale image is in uint8 format
if ~isa(gray_img, 'uint8')
    gray_img = im2uint8(gray_img);
end

% Step 4: Apply local histogram equalization
local_eq_img = adapthisteq(gray_img, 'NumTiles', [8 8], 'ClipLimit', 0.01);

% Step 5: Display the results
figure;
subplot(1,2,1);
imshow(gray_img);
title('Grayscale Image');

subplot(1,2,2);
imshow(local_eq_img);
title('Locally Histogram Equalized Image');
