
clc;
clear all;



[x,fs]=audioread('1.wav')
x=x(:,1);
N=length(x);
t=(0:N-1)/fs;
N/fs
%time domain signal
plot(t,x);
grid on
xlabel('Time');
ylabel('Amplitude');
title('signal in time domain');

maxvalue=max(x);
minvalue=min(x);
meanvalue=mean(x);
stdvalue=std(x);


spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
title('spectrogram of the signal');

%w=hanning(N,'periodic');
%periodogram(x,w,N,fs,'power');






