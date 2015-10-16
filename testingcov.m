	%% testingcov : Computes likelihood ratios and experimental covariance. 
    %% Replaced by ratio_calc and analytical_gen
    %% Usage: testingcov(image size, trials, noise type, contrast level, convariance)
	function[cov_mat] = testingcov(im_size, trials, snr)
	im_size_squared = im_size * im_size;

	%Prepare Image, in this case a pi over four gabor 
	I = imread('pioverfour.png');
	I = double(imresize(I, [im_size,im_size]));
	I = (I - min(I(:)))/(max(I(:))-min(I(:)));

	%Data matrices
	W = zeros(trials, im_size ,im_size);
	for i=1:trials,
		%Make and save Noisy Image 
		O = scaled_contrast(I, 'pink', snr, im_size);
		W(i, :, :) = O.noise; 

	end
 
 	%Make covariance matrix
	cov_mat = zeros(im_size_squared,im_size_squared);
	ave_w = mean(W);
   

	for i=1:trials,
        cov_mat = cov_mat + (squeeze(reshape(W(i, :, :)-ave_w, im_size_squared, 1)))* (squeeze(reshape(W(i, :,:)-ave_w, im_size_squared, 1)))';

    end
    cov_mat = cov_mat./trials; 
