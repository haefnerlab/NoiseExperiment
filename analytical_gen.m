%% analytical_gen: Generates an analytically found covariance matrix for pink noise. 
function [analytical_cov_mat] = analytical_gen(im_size)
	im_size_squared = im_size *im_size;
	analytical_cov_mat = zeros(im_size_squared, im_size_squared);

	for i=1:im_size_squared
		x_i = mod(i,im_size)+1;
		x_j = floor(i/im_size)+1; 
		for j=1:im_size_squared
			if i==j,
				analytical_cov_mat(i, j) = .01;
            else
                %Some counting tricks 
				y_i = mod(j, im_size)+1;
				y_j = floor(j/im_size)+1;
                %Handles min of distances
				i_l =min( min((x_i-y_i)^2, (x_i-(y_i+im_size) )^2), (x_i-(y_i-im_size) )^2);

				j_l = min(min((x_j-y_j)^2, (x_j-(y_j+im_size) )^2), (x_j-(y_j-im_size) )^2);
				analytical_cov_mat(i,j) = i_l+j_l;
				end
		end
    end

    %Final processing
	analytical_cov_mat = double(analytical_cov_mat);
	analytical_cov_mat = sqrt(analytical_cov_mat);
	lambda = 1;
	analytical_cov_mat = lambda .* analytical_cov_mat.* exp(.577215)./8;
	analytical_cov_mat = -log(analytical_cov_mat);
	analytical_cov_mat = (analytical_cov_mat - min(analytical_cov_mat(:))) / (max(analytical_cov_mat(:)) - min(analytical_cov_mat(:)));
