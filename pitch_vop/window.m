clc;
clear all;


%L = 256; nVals = 0:L-1;
[x,fs]=audioread('1.wav');
%sig = x(256+nVals+1);
x=x(:,1);
N=length(x);
t=(0:N-1)/fs;
subplot(311);
plot(t,x);
title('original signal');
w=hamming(256);
subplot(312);
plot(w);
title('hamming window');
r=sigwin.hamming;
subplot(313);
plot(r);
title('output');