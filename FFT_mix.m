load_img;
load_putin;

img_FFT = fft2(I);
putin_FFT = fft2(I2);

mix1_FFT = abs(img_FFT) .* exp(1i * angle(putin_FFT));
mix2_FFT = abs(putin_FFT) .* exp(1i * angle(img_FFT));

figure
subplot(1,2,1)
imshow(real(ifft2(mix1_FFT)),[]);
title('Img module Putin phase')
subplot(1,2,2)
imshow(real(ifft2(mix2_FFT)),[]);
title('Putin module Img phase')
