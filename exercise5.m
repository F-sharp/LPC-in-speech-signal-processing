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
p = [8 10 12 20];
hamming_window = hamming(sample_size);
% add window to sample set
sample_sh = sample_sh_original .* hamming_window;
sample_aa = sample_aa_original .* hamming_window;
% LPC
A_sh = cell(1,4);a_sh = cell(1,4);r_sh = cell(1,4);G_sh = zeros(4,1);
A_aa = cell(1,4);a_aa = cell(1,4);r_aa = cell(1,4);G_aa = zeros(4,1);

%DFT of sample
F_sample_sh = fft(sample_sh);
dB_mag_sample_sh = mag2db(abs(F_sample_sh/10^3.8));
F_sample_aa = fft(sample_aa);
dB_mag_sample_aa = mag2db(abs(F_sample_aa/10^4.4));
%Vocal tract model filter FR calculation
for i = 1:4
    [A_sh{1,i}, G_sh(i),r_sh{1,i},a_sh{1,i}] = autolpc(sample_sh, p(i));
    [A_aa{1,i}, G_aa(i),r_aa{1,i},a_aa{1,i}] = autolpc(sample_aa, p(i));
    [vocaltract_sh(:,i), w_sh] = freqz(1,A_sh{1,i},sample_size/2);
    [vocaltract_aa(:,i),w_aa] = freqz(1,A_aa{1,i},sample_size/2);
    vocaltract_sh_dB(:,i) = mag2db(abs(vocaltract_sh(:,i)));
    vocaltract_aa_dB(:,i) = mag2db(abs(vocaltract_aa(:,i)));
    figure(1)
    plot(w_sh/pi,vocaltract_sh_dB(:,i),'linewidth',1.1)
    hold on
    figure(2)
    plot(w_aa/pi,vocaltract_aa_dB(:,i),'linewidth',1.1)
    hold on
end

figure(1)
plot(w_sh/pi,dB_mag_sample_sh(1:sample_size/2),'--','linewidth',1.1)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('p=8','p=10','p=12','p=20','DFT of samples')
title('Magnitude of DFT and vocal tract filter FR of phoneme "sh"')

figure(2)
plot(w_aa/pi,dB_mag_sample_aa(1:sample_size/2),'--','linewidth',1.1)
xlabel('\omega / \pi')
ylabel('Magnitude (dB)')
legend('p=8','p=10','p=12','p=20','DFT of samples')
title('Magnitude of DFT and vocal tract filter FR of phoneme "aa"')