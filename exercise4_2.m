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

% Frequency response of prediction error filter
[error_o,w_o] = freqz(A_o,1);
[error_s,w_s] = freqz(A_s,1);
error_o_dB = mag2db(abs(error_o));
error_s_dB = mag2db(abs(error_s));
% Magnitude response of vocal tract filter
[vocaltract_o, w_o] = freqz(1,A_o);
[vocaltract_s,w_s] = freqz(1,A_s);
vocaltract_o_dB = mag2db(abs(vocaltract_o));
vocaltract_s_dB = mag2db(abs(vocaltract_s));

% plotting 
figure(1)
subplot(1,2,1)
plot(w_o/pi,error_o_dB)
hold on
plot(w_o/pi,vocaltract_o_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('prediction error filter','vocal tract filter')
title('Frequency response of two filters of phoneme "o"')

figure(1)
subplot(1,2,2)
plot(w_s/pi,error_s_dB)
hold on
plot(w_s/pi,vocaltract_s_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('prediction error filter','vocal tract filter')
title('Frequency response of two filters of phoneme "s"')

%zplane of prediction error filters
figure(2)
subplot(1,2,1)
zplane(A_o,1)
title('zeros and poles of prediction error filters for "sh"')
ylim([-1 1])
xlim([-1.5 1.5])
figure(2)
subplot(1,2,2)
zplane(A_s,1)
title('zeros and poles of prediction error filters for "aa"')
ylim([-1 1])
xlim([-1.5 1.5])
