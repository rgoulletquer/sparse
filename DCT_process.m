load_img;

I_DCT = dct2(I);

figure
imshow(log(abs(I_DCT)), [])
colormap(gca,jet(64))
colorbar
title('DCT')
% on observe que la majorité des basses fréquences se situent dans le coin 
% en haut à gauche

% séparation hautes et basses fréquences
cutoff = round(2.0 * 256);
High_DCT = fliplr(tril(fliplr(I_DCT), cutoff));
Low_DCT = I_DCT - High_DCT;
% DCT inverse
I_High = idct2(High_DCT);
I_Low = idct2(Low_DCT);

figure
colormap gray
subplot(3,2,1), imagesc(I), title('Original'), colorbar 
subplot(3,2,2), imagesc(log(abs(I_DCT))), title('log(DTC(Original))'), colorbar

subplot(3,2,3), imagesc(log(abs(Low_DCT))), title('log(DTC(LF))'), colorbar
subplot(3,2,4), imagesc(log(abs(High_DCT))), title('log(DTC(HF))'), colorbar

subplot(3,2,5), imagesc(I_Low), title('LF'), colorbar
subplot(3,2,6), imagesc(I_High), title('HF'), colorbar