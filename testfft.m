%% Image
I = imread('trump.jpg');
colormap gray;

%% Grey Scale
%image en nuance de gris 
trump_gray = rgb2gray(I);
figure();
imshow(trump_gray);

%% FFT
 I_F = fft2(I);
 GI_F = fft2(trump_gray);
 
%% DCT
DCT_T = dct2(trump_gray);

%% Plots
figure
imshow(I_F); 
title('fft')

figure
imshow(DCT_T);
title('DCT')

%% FFT Shift

shifted_fft = fftshift(I_F);

figure
imshow(shifted_fft); 
title('fft')

