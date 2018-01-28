load_trump;

I_FFT = fft2(I);
I_DCT = dct2(I);

fft2_block = @(block_struct) fft2(block_struct.data);
ifft2_block = @(block_struct) ifft2(block_struct.data);
dct2_block = @(block_struct) dct2(block_struct.data);
idct2_block = @(block_struct) idct2(block_struct.data);
I_FFTBLOCK = blockproc(I, [9 9], fft2_block);
I_DCTBLOCK = blockproc(I, [9 9], dct2_block);

tx_FFT = [];
e_FFT = [];
tx_DCT = [];
e_DCT = [];
tx_FFTBLOCK = [];
e_FFTBLOCK = [];
tx_DCTBLOCK = [];
e_DCTBLOCK = [];

k = 10;
K = 15;

figure
for i = k:K
    
    s_fft = max(I_FFT(:))/(2^i);
    i_fft = I_FFT;
    % threshold
    i_fft(abs(i_fft) < s_fft) = 0.0;
    % count nb of coef set to 0
    cnt_FFT = sum(sum(abs(i_fft) >= s_fft));
    % reconstruction
    Irec_FFT = double((ifft2(i_fft)));
    % compression ratio and error
    t_FFT = (w*h)/cnt_FFT;
    tx_FFT = [tx_FFT t_FFT];
    e_FFT = [e_FFT norm(I - Irec_FFT, 'fro')];
    
    s_dct = max(I_DCT(:))/(2^i);
    i_dct = I_DCT;
    % threshold
    i_dct(abs(i_dct) < s_dct) = 0.0;
    % count nb of coef set to 0
    cnt_DCT = sum(sum(abs(i_dct) >= s_dct));
    % reconstruction
    Irec_DCT = double((idct2(i_dct)));
    % compression ratio and error
    t_DCT = (w*h)/cnt_DCT;
    tx_DCT = [tx_DCT t_DCT];
    e_DCT = [e_DCT norm(I - Irec_DCT, 'fro')];
    
    subplot(2,K - k + 1,i - k + 1) , imshow(Irec_FFT, []);
    title(strcat('fft compression :', num2str(t_FFT)));
    subplot(2,K - k + 1, i + (K - k + 1) - k + 1) , imshow(Irec_DCT, []);
    title(strcat('dct compression :', num2str(t_DCT)));
    
end

k = k-6;
K = K-6;
figure
for i = k:K
    
    s_fftblock = max(I_FFTBLOCK(:))/(2^i);
    i_fftblock = I_FFTBLOCK;
    % threshold
    i_fftblock(abs(i_fftblock) < s_fftblock) = 0.0;
    % count nb of coef set to 0
    cnt_FFTBLOCK = sum(sum(abs(i_fftblock) >= s_fftblock));
    % reconstruction
    Irec_FFTBLOCK = blockproc(i_fftblock, [9 9], ifft2_block);
    % compression ratio and error
    t_FFTBLOCK = (w*h)/cnt_FFTBLOCK;
    tx_FFTBLOCK = [tx_FFTBLOCK t_FFTBLOCK];
    e_FFTBLOCK = [e_FFTBLOCK norm(I - Irec_FFTBLOCK, 'fro')];
    
    s_dctblock = max(I_DCTBLOCK(:))/(2^i);
    i_dctblock = I_DCTBLOCK;
    % threshold
    i_dctblock(abs(i_dctblock) < s_dctblock) = 0.0;
    % count nb of coef set to 0
    cnt_DCTBLOCK = sum(sum(abs(i_dctblock) >= s_dctblock));
    % reconstruction
    Irec_DCTBLOCK = blockproc(i_dctblock, [9 9], idct2_block);
    % compression ratio and error
    t_DCTBLOCK = (w*h)/cnt_DCTBLOCK;
    tx_DCTBLOCK = [tx_DCTBLOCK t_DCTBLOCK];
    e_DCTBLOCK = [e_DCTBLOCK norm(I - Irec_DCTBLOCK, 'fro')];
    
    subplot(2,K - k + 1,i - k + 1) , imshow(Irec_FFTBLOCK, []);
    title(strcat('fft block compression :', num2str(t_FFTBLOCK)));
    subplot(2,K - k + 1, i + (K - k + 1) - k + 1) , imshow(Irec_DCTBLOCK, []);
    title(strcat('dct block compression :', num2str(t_DCTBLOCK)));
end

figure
plot(tx_FFT , e_FFT);
hold on
plot(tx_DCT, e_DCT);
hold on
plot(tx_FFTBLOCK , e_FFTBLOCK);
hold on
plot(tx_DCTBLOCK , e_DCTBLOCK);
hold on
xlabel('compression ratio')
ylabel('error')
legend('FFT', 'DCT', 'FFT block', 'DCT block')