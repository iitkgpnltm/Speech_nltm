
% This programm is written to find pitch related parameters.
% input
%    speech signal
%    sampling frequency,by default 8000;

% %  output

%    pitch
%    avg. pitch
%    log avg pitch
%    max pitch
%    min pitch
%    range of pitch
%    slope of pitch

% The pitch values obtained by hilbert envelope modified with instants location methods.

function [t0,logt0,f0,logf0,mnf0,lmnf0,lmaxf0,lminf0,lrnf0,spf0]=pitch_hilbert_instant_parameters(sp1sig);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%computing pitch contours from given speakers data
% sp1sig=sphere2mulaw('D:\programms\NIST_1999\30\Test/ebwa.sph');
% sp1sig=sphere2mulaw('D:\programms\NIST_1999\30\Train/4001A.sph');

% sp1sig = wavReadTimit('D:\programms\TIMIT\TIMIT\TEST\DR1\FJEM0/sa1.wav');
% sp1sig = wavReadTimit('D:\programms\TIMIT\TIMIT\TEST\DR1\FAKS0/sa1.wav');
% sp1sig = wavReadTimit('D:\programms\TIMIT\TIMIT\TEST\DR1\FJEM0/sa2.wav');

% sp1sig = wavReadTimit('D:\programms\TIMIT\TIMIT\TEST\DR2\MCEM0\SX408.wav');
% sp1sig = wavReadTimit('D:\programms\TIMIT\TIMIT\TEST\DR1\MSTK0/sa1.wav');
%   sp1sig = wavReadTimit('D:\programms\TIMIT\TIMIT\TEST\DR1\MSJS1/sa1.wav');



%resample for timit
% sp1sig = resample(sp1sig,1,2);

%uncomment for NIST
%sp1sig=sp1sig(1:40000);

if(size(sp1sig,2) ~= 1)
    sp1sig=sp1sig';
end

sp1sig=sp1sig./(1.01*max(abs(sp1sig)));

fs=8000; %original timit at 16k


%compute lp residual

ressp1=LPres(sp1sig,fs,20,5,10,1);

clear sp1sig

%compute Hilbert envelope

hensp1=HilbertEnv(ressp1,fs,1);

clear ressp1

avgpitchperiod=HilbertAvgPitch(hensp1,fs,(30*fs)/1000,(10*fs)/1000);

winlength=round(avgpitchperiod);

[zsp1,gclocssp1,epssp1,f0sp1]=svlzfsig2(hensp1,fs,winlength);

clear zsp1;
% clear gclocssp1;

epssp1=epssp1./(max(epssp1));

meanessp1=mean(epssp1);

%epssp1=resample(epssp1,length(sp1sig),length(epssp1));

epssp1=epssp1>0.7*meanessp1;

pitchperiodcont=HilbertPitch(hensp1,fs,(30*fs)/1000,(10*fs)/1000);% pitch obtained in msec.

maxlength=max(length(pitchperiodcont),length(epssp1));

epssp1=resample(epssp1,maxlength,length(epssp1));

pitchperiodcont=resample(pitchperiodcont,maxlength,length(pitchperiodcont));

pitchperiodcont=pitchperiodcont.*epssp1';

pitchloc=find(pitchperiodcont~=0);

pitchperiodcont2=pitchperiodcont(pitchloc); % modified pitch obtained in msec

pitchperiodcont2=pitchperiodcont2';% make a column vector similar to instant method

pitchfrequencycont=(1./pitchperiodcont2)*1000; %modified pitch frequency in Hertz

% figure;
% subplot(4,1,1);plot(sp1sig,'k');grid;
% %subplot(4,1,2);plot(sp1sig1,'k');grid;
% subplot(4,1,2);plot(hensp1,'k');grid;
% subplot(4,1,3);plot(pitchperiodcont,'k.');grid;
% subplot(4,1,4);plot(pitchperiodcont2,'k.');grid;


%  study of pitch and strength features.
%         % some pitch parameters are studied with log operation.
%         % for log operation zero value gives -inf.
%        % to avoide this we first eliminate from pitch values the zero values.
%
t0=pitchperiodcont2;
ptinstants=find(pitchperiodcont2~=0);% instants where pitch period not equal to zero.
logt0=log10(pitchperiodcont2(ptinstants));

f0=pitchfrequencycont;
pinstants=find(pitchfrequencycont~=0);% instants where pitch frequency not equal to zero.
logf0=log10(pitchfrequencycont(pinstants));

mnf0=mean(pitchfrequencycont);
lmnf0=(log10(mean(pitchfrequencycont(pinstants))));
lmaxf0=(log10(max(pitchfrequencycont(pinstants))));
lminf0=(log10(min(pitchfrequencycont(pinstants))));
lrnf0=(log10(max(pitchfrequencycont(pinstants)-min(pitchfrequencycont(pinstants)))));
spf0=(pitchfrequencycont(end)-pitchfrequencycont(1))./length(pitchfrequencycont);








