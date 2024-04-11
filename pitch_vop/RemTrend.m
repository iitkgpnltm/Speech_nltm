function y = RemTrend(henv,Fs,Tms)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USAGE : y = RemTrend(henv,Fs,Tms);
%
% PURPOSE	:
%	Remove trend is typically used on the hilbert envelop of the residual
%	signal. This operation helps sharpen the peaks around the instants of
%	glottal closure, while at the same time clamps down the valleys close
%	zero or one.
%
% TIPS		:
%	Use a typical value of Tms = 4 ms for best performance
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nms	= floor(Fs*Tms/1000); % convert ms to no. of samples

hmu	= RunMean(henv,Nms);

hmu(find(hmu == 0))=1; % To avoid divide by zero

y	= (henv .* henv) ./ hmu;

return;

