function [A, G, r, a] = autolpc(x, p)
%AUTOLPC Autocorrelation Method for LPC
% Usage: [A, G, r, a] = autolpc(x, p)
% x : input samples
% p : order of LPC
% A : prediction error filter, (A = [1; -a])
% G : rms prediction error
% r : autocorrelation coefficients
% a : predictor coefficients
corr = xcorr(x,p);
r =corr(p+1:end);
r = r';
rs = r(2:end);
Rs = toeplitz (r(1:end-1));
a = Rs\rs';
A = [1;-a];
e = filter(A,1,x);
G = rms(e);
end
