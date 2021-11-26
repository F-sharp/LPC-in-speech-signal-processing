clear all;
close all;
clc;
% initializing basic parameters and data
load s5.mat
fs = 8000;%Hz
sample_size = 320;
y = filter([1, -0.98], 1, s5);
% section_sh = [15500:16750] to take middle 320 sample
samplenumber_sh = [15965:16284];
sample_sh_original = s5(samplenumber_sh);
% section_aa = [16750:18800]; to take middle 320 sample
sample_sh_original_pre = y(samplenumber_sh);
p = 12;
hamming_window = hamming(sample_size);
% add window to sample set
sample_sh = sample_sh_original .* hamming_window;
sample_sh_pre = sample_sh_original_pre .* hamming_window;
% LPC
[A_sh, G_sh, r_sh, a_sh] = autolpc(sample_sh, p);
[A_sh_pre, G_sh_pre, r_sh_pre, a_sh_pre] = autolpc(sample_sh_pre, p);

% Magnitude response of vocal tract filter
[vocaltract_sh, w_sh] = freqz(1,A_sh,sample_size/2);
[vocaltract_sh_pre,w_sh_pre] = freqz(1,A_sh_pre,sample_size/2);
vocaltract_sh_dB = mag2db(abs(vocaltract_sh));
vocaltract_sh_pre_dB = mag2db(abs(vocaltract_sh_pre));

%DFT of sample
F_sample_sh = fft(sample_sh)
dB_mag_sample_sh = mag2db(abs(F_sample_sh/(G_sh*30)))
F_sample_sh_pre = fft(sample_sh_pre)
dB_mag_sample_sh_pre = mag2db(abs(F_sample_sh_pre/(G_sh_pre*30)))
% plotting 
figure()
plot(w_sh/pi,dB_mag_sample_sh(1:sample_size/2),'--','linewidth',1.1)
hold on
plot(w_sh_pre/pi,dB_mag_sample_sh_pre(1:sample_size/2),'linewidth',1.1)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('Directly LPC','Pre-smphasis & LPC')
title('Magnitude of DFT for phoneme "sh"')

figure()
plot(w_sh/pi,vocaltract_sh_dB,'--','linewidth',1.1)
hold on
plot(w_sh_pre/pi,vocaltract_sh_pre_dB,'linewidth',1.1)
xlabel('\omega / \pi')
legend('Directly LPC','Pre-smphasis & LPC')
title('vocal tract filter FR of "sh"')
