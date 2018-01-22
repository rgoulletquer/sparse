I = imread('img.jpg');

I = double(rgb2gray(I));
[h, w] = size(I);
figure
imshow(I, [])
colorbar

%% FFT
I_FFT = fft2(I);
I_FFT = fftshift(I_FFT);
I_abs = log(abs(I_FFT));
%I_abs = mat2gray(I_abs);
figure
imshow(mat2gray(I_abs), [])
colorbar
title('abs(FFT)')
% Il y a deux directions dominantes dans la FFT du fait de la forme
% rectangulaire de l'image
% Décalage de Pi/2 car H(?f)=[H(f)]?

I_phase = (angle(I_FFT));
%I_phase = mat2gray(I_phase);
figure()
imshow(I_phase, [])
colorbar
title('phase(FFT)')

Irec_abs = uint8(real(ifftshift(ifft2(exp(I_abs)))));
figure
%Irec_abs = mat2gray((Irec_abs));
imshow(Irec_abs, [])%, [min(Irec_abs(:)) max(Irec_abs(:))])
colorbar
title('reconstruction from magnitude')

Irec_ph = ((histeq(real(ifft2(exp(1i*I_phase))))));
figure
imshow((mat2gray(real(Irec_ph))), [])
colorbar
title('reconstruction from phase')

Irec_fft = (ifft2(I_FFT));
figure
imshow(uint8(Irec_fft), [])
colorbar
title('reconstruction from magnitude and phase')

%% DCT
I_DCT = ((dct2(I)));

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


% seuil
s=[0 1 2 5 10 20 50 100 200];
j = 1;
cnt = 0;
t1 = zeros(size(s));
SNR = zeros(size(s));
figure
for i = s
I_DCT(I_DCT < i) = 0.0;
Irec_DCT = double(uint8(idct2(I_DCT)));
cnt = sum(Irec_DCT(:) == 0);
t1(j) = 1 - cnt/(w*h);
SNR(j) = snr(I, Irec_DCT);
subplot(3, 3, j)
imshow(Irec_DCT, [])
colorbar
title(['DCT reconstruction with seuil = ', num2str(i)])
j = j+1;
end

