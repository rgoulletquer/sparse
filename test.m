load_img;
I_FFT = fftshift(fft2(I));
I_m = log(abs(I_FFT));
I_ph = (angle(I_FFT));
Irec_abs = uint8(real(ifftshift(ifft2(exp(I_m)))));
Irec_ph = ((histeq(real(ifft2(exp(1i*I_ph))))));
figure
%Irec_abs = mat2gray((Irec_abs));
imshow(Irec_abs, [min(Irec_abs(:)) max(Irec_abs(:))])
colorbar
title('rec')
figure
imshow(mat2gray(real(Irec_ph)))%, [min(Irec_ph(:)) max(Irec_ph(:))])