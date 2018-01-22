function snr = snr(im,im_t)
im_square = im.^2;
im_square_dif = im_square - im_t.^2;
snr = 10*log10(sum(im_square(:))/sum(im_square_dif(:)));