% Read the input grayscale image
img = imread('inputColor1.jpg');  % Replace with your image file

% Convert to grayscale if the image is RGB
if size(img, 3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end

% Ensure the image is uint8
if ~isa(gray_img, 'uint8')
    gray_img = im2uint8(gray_img);
end

% Apply adaptive histogram equalization with NumTiles = [8 8]
local_eq_img_8x8 = adapthisteq(gray_img, 'NumTiles', [8 8], 'ClipLimit', 0.01);

% Apply adaptive histogram equalization with NumTiles = [16 16]
local_eq_img_16x16 = adapthisteq(gray_img, 'NumTiles', [16 16], 'ClipLimit', 0.01);
local_eq_img_32x32 = adapthisteq(gray_img, 'NumTiles', [32 32], 'ClipLimit', 0.01);


% Display the results in a 2x2 subplot layout
figure;
subplot(2,4,1);
imshow(gray_img);
title('Original Grayscale Image');

subplot(2,4,2);
imshow(local_eq_img_8x8);
title('Local Equalization (8x8 Tiles)');

subplot(2,4,3);
imshow(local_eq_img_16x16);
title('Local Equalization (16x16 Tiles)');

subplot(2,4,4);
imshow(local_eq_img_32x32);
title('Local Equalization (32x32 Tiles)');

% Display histograms of the different images
subplot(2,4,6);
imhist(local_eq_img_8x8);

subplot(2,4,7);
imhist(local_eq_img_16x16);


subplot(2,4,8);
imhist(local_eq_img_16x16);