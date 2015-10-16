%% ratio_calc: Computes log likelihood ratios from given noisy images
%%Usage: ratio_calc(Image size, nubmer of trials, Images array, covariance
%%matrix)
function [outputs] = ratio_calc(im_size, trials, images, analytical_cov_mat)

	%% Read in image template
	im_size_squared = im_size * im_size;
	I = imread('pioverfour.png');
	I = double(imresize(I, [im_size,im_size]));
	I = (I - min(I(:)))/(max(I(:))-min(I(:)));

	log_ratios = zeros(2,11* trials);
	temp_vect = reshape(I, 1, im_size_squared);
	wrong_temp_vect = reshape(imrotate(I, 90), 1, im_size_squared);


	%% Compute inverse of Covariance Matrix
	iac = inv(analytical_cov_mat);


	%% Calculate ratios. 
	% mu is the expectation at this point from the template. Sigma =1
	% N(x | mu, sigma) = 1/(sigma * sqrt(2pi)) * e^(-(x-mu)^2/(2sigma^2))
	% N(x | mu, 1) = 1/sqrt(2pi) * e^(-(x-mu)^2/(2))
	% Likelihood Ratio = N(x (Image) | mu (Correct Template)) /  N(x (Image) | mu (Incorrect Template))
	% log(N) = (-(x-mu)^2/(2))
	% log(N) = (-1/2(Image - Template) * (Image - Template)')
	% log likelihood ratio = log(N(Image | Correct Template)) - log(N(Image | Incorrect Template)) = log( Likelihood Ratio)
	% Pink Noise Case: log(N) = (-1/2 (Image - Template) * inv(Covariance) * (Image- Template)')

	noise='pink'
	for j=1:2,
			for i=1:(trials*11),

				im = squeeze(images(j,i, :, :));
				I_vect = reshape(im, 1, im_size_squared);
				I_wrong_vect = reshape(double(imrotate(im, 90)), 1, im_size_squared);
			
			
				if strcmp(noise, 'pink'),
					t1 = squeeze(I_vect - temp_vect).^2;
					t2 = squeeze(I_vect-wrong_temp_vect).^2;
			
					likelihood =((t1) *(iac*(t1')));
					wrong_likelihood =((t2) *( iac*(t2')));
					log_ratios(j, i) = -.5*(likelihood - wrong_likelihood);
				else 
					likelihood = sum(((I_vect(:) - temp_vect(:)).^2));
					wrong_likelihood = sum(((I_vect(:) - wrong_temp_vect(:)).^2));
					log_ratios(j,i) =-.5* (likelihood - wrong_likelihood);
				end

		end
		noise='white'
	end
	outputs = log_ratios;
	end
