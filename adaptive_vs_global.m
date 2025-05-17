% Read and preprocess image
img = imread('inputColor1.jpg');  % Replace with your image
if size(img, 3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end
gray_img = im2uint8(gray_img);

% Global and Adaptive Equalization
global_eq = histeq(gray_img);
adaptive_eq = adapthisteq(gray_img, 'NumTiles', [8 8], 'ClipLimit', 0.01);

% ---------- Figure 1: Global Histogram Equalization ----------
figure;
subplot(1,2,1);
imshow(global_eq);
title('Global Histogram Equalization');

subplot(1,2,2);
imhist(global_eq);
title('Histogram: Global Equalization');

% ---------- Figure 2: Adaptive Histogram Equalization ----------
figure;
subplot(1,2,1);
imshow(adaptive_eq);
title('Adaptive Histogram Equalization');

subplot(1,2,2);
imhist(adaptive_eq);
title('Histogram: Adaptive Equalization');
