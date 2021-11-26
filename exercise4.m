clear all;
close all;
clc;
% initializing basic parameters and data
load s5.mat
fs = 8000;%Hz
sample_size = 320;
% section_o
samplenumber_o = [7300:7300+sample_size-1];
sample_o_original = s5(samplenumber_o);
% section_s
samplenumber_s = [4650:4650+sample_size-1];
sample_s_original = s5(samplenumber_s);
p = 12;
hamming_window = hamming(sample_size);
% add window to sample set
sample_o = sample_o_original .* hamming_window;
sample_s = sample_s_original .* hamming_window;
% LPC
[A_o, G_o, r_o, a_o] = autolpc(sample_o, p);
[A_s, G_s, r_s, a_s] = autolpc(sample_s, p);

% Magnitude response of vocal tract filter
[vocaltract_o, w_o] = freqz(1,A_o,sample_size/2);
[vocaltract_s,w_s] = freqz(1,A_s,sample_size/2);
vocaltract_o_dB = mag2db(abs(vocaltract_o));
vocaltract_s_dB = mag2db(abs(vocaltract_s));

%DFT of sample
F_sample_o = fft(sample_o);
dB_mag_sample_o = mag2db(abs(F_sample_o/(G_o*26)));
F_sample_s = fft(sample_s);
dB_mag_sample_s = mag2db(abs(F_sample_s/(G_s*26)));
% plotting 
figure()
subplot(1,2,1)
plot(w_o/pi,dB_mag_sample_o(1:sample_size/2))
hold on
plot(w_o/pi,vocaltract_o_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('DFT of samples','vocal tract filter FR')
title('Magnitude of DFT and vocal tract filter FR of phoneme "o"')

subplot(1,2,2)
plot(w_s/pi,dB_mag_sample_s(1:sample_size/2))
hold on
plot(w_s/pi,vocaltract_s_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('DFT of samples','vocal tract filter FR')

title('Magnitude of DFT and vocal tract filter FR of phoneme "s"')