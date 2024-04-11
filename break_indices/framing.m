%function framing

function [FRMS] = framing(x, frlen, hop, fs)
% signal segmentation
[FRMS, ~] = buffer(x, frlen, frlen-hop, 'nodelay');
end