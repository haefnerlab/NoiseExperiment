function [res,seed] = coloredNoise2D(width,height,expt,std_clip,seed)

% function coloredNoise2D(width,height,expt=1,std_clip=2)

% returns a random noise image of height 'height' and width 'width' (in
% pixels) with a frequency amplitude spectrum that falls as 1/f^expt.
% the constructed image has mean = 0 and sd = 1, and is clipped at +/-
% std_clip.

% Author: Melchi M. Michel  (11/2012)

% define maximum (signed, 32-bit) integer
MAX_INT = 2147483648;

% Set default values for exponent and extreme value clipping
if nargin < 3 || isempty(expt)
   expt = 1.0;
end

if nargin < 4 || isempty(std_clip)
   std_clip = 3.0;
end

if nargin < 5 || isempty(seed)
    seed = int32(randi(MAX_INT));
end

% compute nyquist frequencies
nyquist_freqx = floor(width/2);
nyquist_freqy = floor(height/2);
% compute the set of x and y frequencies
xx = -nyquist_freqx:(-nyquist_freqx+width-1);
yy = -nyquist_freqy:(-nyquist_freqy+height-1);
[x,y] = meshgrid(xx,yy);
% make the frequency-space filter
rfreq = sqrt(x.^2+y.^2);
ft_filter = ifftshift(1./rfreq.^expt);
ft_filter(1,1) = 0;

% now, construct noise 
rng(seed);
white_noise = randn(height,width);

% filter this noise 
colored_noise = ifft2(fft2(white_noise).*ft_filter);
% normalize by the standard deviation
colored_noise = colored_noise./std(colored_noise(:));
% clip extreme values and return result
colored_noise = min(max(colored_noise,-std_clip),std_clip);
res = colored_noise;