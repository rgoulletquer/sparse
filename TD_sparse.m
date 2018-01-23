I = imread('img.jpg');

I = double(rgb2gray(I));
[h, w] = size(I);
figure
imshow(I, [])
colorbar

%% FFT
I_FFT = fft2(I);
I_FFTSHIFT = fftshift(I_FFT);

I_abs = log(abs(I_FFT));
%I_abs = mat2gray(I_abs);
figure
imshow(mat2gray(log(abs(I_FFTSHIFT))), [])
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


%% threshold
s_FFT = linspace(1, max(I_FFT(:))/1000, 9);
s_DCT = linspace(1, max(I_DCT(:))/1000, 9);

% initialisation
j = 1;
t1_FFT = zeros(1, 9);
e_FFT = zeros(1, 9);
figure
for i = s_FFT
i_fft = I_FFT;
% threshold
i_fft(abs(i_fft) < i) = 0.0;
% count nb of coef set to 0
cnt_FFT = sum(i_fft(:) == 0);
% reconstruction
Irec_FFT = double((ifft2(i_fft)));
% compression ratio and error
t1_FFT(j) =  (w*h)/cnt_FFT;
e_FFT(j) = norm(I - Irec_FFT, 'fro');
% plot
subplot(3, 3, j)
imshow(Irec_FFT, [])
colorbar
title(['FFT reconstruction with seuil = ', num2str(i)])
j = j+1;
end

% initialisation
j = 1;
t1_DCT = zeros(1,9);
e_DCT = zeros(1,9);
figure
for i = s_DCT
i_dct = I_DCT;
% threshold
i_dct(abs(i_dct) < i) = 0.0;
% count nb of coef set to 0
cnt_DCT = sum(i_dct(:) == 0);
% reconstruction
Irec_DCT = double((idct2(i_dct)));
% compression ratio and error
t1_DCT(j) = (w*h)/cnt_DCT;
e_DCT(j) = norm(I - Irec_DCT, 'fro');
% plot
subplot(3, 3, j)
imshow(uint8(Irec_DCT), [])
colorbar
title(['DCT reconstruction with seuil = ', num2str(i)])
j = j+1;
end

figure
plot(t1_FFT, e_FFT, t1_DCT, e_DCT)

%% FFT block processing

fft2_block = @(block_struct) fft2(block_struct.data);
ifft2_block = @(block_struct) ifft2(block_struct.data);
I_FFTBLOCK = blockproc(I, [9 9], fft2_block);
Irec_fftblock = blockproc(I_FFTBLOCK, [9 9], ifft2_block);
figure
imshow(uint8(Irec_fftblock), [])
colorbar
title('reconstruction from fft on blocks')

%% DCT block processing

dct2_block = @(block_struct) dct2(block_struct.data);
idct2_block = @(block_struct) idct2(block_struct.data);
I_DCTBLOCK = blockproc(I, [9 9], dct2_block);
Irec_dctblock = blockproc(I_DCTBLOCK, [9 9], idct2_block);
figure
imshow(uint8(Irec_dctblock), [])
colorbar
title('reconstruction from dct on blocks')