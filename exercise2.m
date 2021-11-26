clear all;
close all;
clc;
set(groot, 'defaultFigureUnits','normalized')
set(groot, 'defaultFigurePosition',[0 0 0.3 0.333])
% initializing basic parameters and data
load s5.mat
fs = 8000;%Hz
sample_size = 320;
p = 12;
% section_sh = [15500:16750] to take middle 320 sample
samplenumber_sh = [15965:16284];
sample_sh_original = s5(samplenumber_sh);
% section_aa = [16750:18800]; to take middle 320 sample
samplenumber_aa = [17615:17934];
sample_aa_original = s5(samplenumber_aa);
hamming_window = hamming(sample_size);
% add window to sample set
sample_sh = sample_sh_original .* hamming_window;
sample_aa = sample_aa_original .* hamming_window;
% LPC
[A_sh, G_sh, r_sh, a_sh] = autolpc(sample_sh, p);
[A_aa, G_aa, r_aa, a_aa] = autolpc(sample_aa, p);
% Frequency response of prediction error filter
[error_sh,w_sh] = freqz(A_sh,1);
[error_aa,w_aa] = freqz(A_aa,1);
error_sh_dB = mag2db(abs(error_sh));
error_aa_dB = mag2db(abs(error_aa));
% Magnitude response of vocal tract filter
[vocaltract_sh, w_sh] = freqz(1,A_sh);
[vocaltract_aa,w_aa] = freqz(1,A_aa);
vocaltract_sh_dB = mag2db(abs(vocaltract_sh));
vocaltract_aa_dB = mag2db(abs(vocaltract_aa));

% plotting 
figure(1)
plot(w_sh/pi,error_sh_dB)
hold on
plot(w_sh/pi,vocaltract_sh_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('prediction error filter','vocal tract filter')
title('Frequency response of two filters of phoneme "sh"')

figure(2)
plot(w_aa/pi,error_aa_dB)
hold on
plot(w_aa/pi,vocaltract_aa_dB)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('prediction error filter','vocal tract filter')
title('Frequency response of two filters of phoneme "aa"')

%zplane of prediction error filters
figure()
zplane(A_sh,1)
title('zeros and poles of prediction error filters for "sh"')
figure()
zplane(A_aa,1)
title('zeros and poles of prediction error filters for "aa"')