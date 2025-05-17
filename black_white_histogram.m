% Local Histogram Equalization in MATLAB 2022b

% Step 1: Read the input image
img = imread('input1.jpg');  % Replace with your image file name

% Step 2: Convert to grayscale if it's RGB
if size(img, 3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end

% Step 3: Apply local histogram equalization
% Use 'adapthisteq' which performs contrast-limited adaptive histogram equalization (CLAHE)
local_eq_img = adapthisteq(gray_img, 'NumTiles', [8 8], 'ClipLimit', 0.01);

% Step 4: Display results
figure;
subplot(1,2,1);
imshow(gray_img);
title('Grayscale Image');

subplot(1,2,2);
imshow(local_eq_img);
title('Locally Histogram Equalized Image');
