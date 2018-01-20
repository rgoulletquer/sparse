I = imread('trump.jpg');

I = rgb2gray(I);

figure()
imshow(I)

%% FFT
I_FFT = fft2(I);
I_FFT = fftshift(I_FFT);
I_abs = log(abs(I_FFT));
%I_abs = mat2gray(I_abs);
figure()
imshow(mat2gray(I_abs))
colorbar
title('abs(FFT)')
% Il y a deux directions dominantes dans la FFT du fait de la forme
% rectangulaire de l'image
% Décalage de Pi/2 car H(?f)=[H(f)]?

I_phase = (angle(I_FFT));
%I_phase = mat2gray(I_phase);
figure()
imshow(I_phase)
colorbar
title('phase(FFT)')

Irec_abs = uint8(real(ifftshift(ifft2(exp(I_abs)))));
figure
%Irec_abs = mat2gray((Irec_abs));
imshow(Irec_abs)%, [min(Irec_abs(:)) max(Irec_abs(:))])
colorbar
title('reconstruction from magnitude')

Irec_ph = ((histeq(real(ifft2(exp(1i*I_phase))))));
figure
imshow((mat2gray(real(Irec_ph))))
colorbar
title('reconstruction from phase')

Irec_fft = (ifft2(I_FFT));
figure
imshow(uint8(Irec_fft))
colorbar
title('reconstruction from magnitude and phase')
%% DCT
% DCT_T = dct2(trump_gray);
% image(I_F);
% 
% image(DCT_T);
% 
% plot (DCT_T)
% 

% %seuil
% k=1000;
% s= max(I_F)/(2^k);
% 
% plot(I_F);
% 
% B_F = I_F