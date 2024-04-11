function [AvgPitchPeriod]=HilbertAvgPitch(henv,sampfreq,framesize,frameshift)

% [AvgPitchPeriod]=HilbertAvgPitch(henv,framesize,frameshift)
%
%   Input:
%           henv: Hilbert envelope of LP residual
%           sampfreq: sampling frequency (Hz)
%           framesize: framesize for autocorrelation (samples)
%           frameshift: frameshift for autocorrelation (samples)
%
%   Output:
%           AvgPitchPeriod: Average pitch period

% Basis:
%       Identify voiced regions by first major peak strength. If it is
%       greater than some threshold, then the period of that frame is
%       considered for computing the avg. period, else the frame is
%       discarded.

AvgPitchPeriod=0;

onemsec=sampfreq/1000;
minpitch=(2.5*sampfreq)/1000;
maxpitch=(20*sampfreq)/1000;

nfrms=0;
%figure
for i=1:frameshift:length(henv)-framesize

    frmhen=henv(i:i+framesize-1);

    frmhen=frmhen-mean(frmhen);

    xfrmhen=xcorr(frmhen);

    xfrmhen=xfrmhen./max(xfrmhen);

    xfrmhen=xfrmhen(ceil(length(xfrmhen)/2):length(xfrmhen));

    xfrmhen=xfrmhen(minpitch:maxpitch);

    %wt=length(xfrmhen)-[1:length(xfrmhen)];

    %wt=wt./length(xfrmhen);

    %xfrmhen=xfrmhen.*wt';

    [mvalue,mloc]=max(xfrmhen);

    if(mvalue > 0.4)
        pitch=mloc/onemsec + minpitch/onemsec;
        if(pitch>3)
            AvgPitchPeriod=(AvgPitchPeriod+pitch)/2;
            nfrms=nfrms+1;
        end
    end

    %     xfrmhen=[zeros(minpitch,1);xfrmhen];
    %     subplot(2,1,1);plot(frmhen./max(frmhen));grid;axis([1,length(frmhen),0,1]);
    %     subplot(2,1,2);plot(xfrmhen);grid;axis([1,length(xfrmhen),0,1]);
    %     pause
end
nfrms;