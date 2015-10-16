%% TLDRwrapper: Function runs the setup process
%%Usage: TLDRwrapper(image size, trials per contrast level). 
function [outputs] = TLDRwrapper(im_size, trials)
	
disp('Generating images')
tic
I = image_generator(trials, im_size);
toc
disp('Calculating covariance matrix')
tic
A = analytical_gen(im_size);
toc
disp('Calculating log-likelihood ratios')
tic
R = ratio_calc(im_size, trials, I, A);
toc
disp('Matching noisy images with similiar log-likelihood ratios')
tic
map = image_map(R, trials);
toc
disp('Sorting images based on log-likelihood ratios')
tic
sorted_map = image_sort(map, R);
toc
disp('Saving data')
save('ExperimentalData.mat');

outputs.I = I;
outputs.A =A;
outputs.R= R;
outputs.map = map;
outputs.sorted_map = sorted_map;

end 
