clear all;
close all;
clc;
% initializing basic parameters and data
load s5.mat
fs = 8000;%Hz
sample_size = 320;
% section_sh = [15500:16750] to take middle 320 sample
samplenumber_sh = [15965:16284];
sample_sh_original = s5(samplenumber_sh);
% section_aa = [16750:18800]; to take middle 320 sample
samplenumber_aa = [17615:17934];
sample_aa_original = s5(samplenumber_aa);
p = 12;
hamming_window = hamming(sample_size);
% add window to sample set
sample_sh = sample_sh_original .* hamming_window;
sample_aa = sample_aa_original .* hamming_window;
% LPC
[A_sh, G_sh, r_sh, a_sh] = autolpc(sample_sh, p);
[A_aa, G_aa, r_aa, a_aa] = autolpc(sample_aa, p);

% Magnitude response of vocal tract filter
[vocaltract_sh, w_sh] = freqz(1,A_sh,sample_size/2);
[vocaltract_aa,w_aa] = freqz(1,A_aa,sample_size/2);
vocaltract_sh_dB = mag2db(abs(vocaltract_sh));
vocaltract_aa_dB = mag2db(abs(vocaltract_aa));

%DFT of sample
F_sample_sh = fft(sample_sh)
dB_mag_sample_sh = mag2db(abs(F_sample_sh/(G_sh*30)))
F_sample_aa = fft(sample_aa)
dB_mag_sample_aa = mag2db(abs(F_sample_aa/(G_aa*30)))
% plotting 
figure()
plot(w_sh/pi,dB_mag_sample_sh(1:sample_size/2))
hold on
plot(w_sh/pi,vocaltract_sh_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('DFT of samples','vocal tract filter FR')
title('Magnitude of DFT and vocal tract filter FR of phoneme "sh"')

figure()
plot(w_aa/pi,dB_mag_sample_aa(1:sample_size/2))
hold on
plot(w_aa/pi,vocaltract_aa_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('DFT of samples','vocal tract filter FR')

title('Magnitude of DFT and vocal tract filter FR of phoneme "aa"')
