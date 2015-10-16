% README and Example for Noise Experiment 
% This code generates images of pink and white noise, calculates 
% log likelihoods ratios , and sorts information based on that. 

% analytical_gen(im_size) ~ Generates the covariance matrix of pink noise 
% taking in the size of the images you want to make. Images more then 100
% pixels will quickly slow down a computer 
%
%check_snr(Image, template, non noise) ~ Defunct. Can be used to calculate
%the SNR as defined by matlab. Not used in actual experiment . 
%
%coloredNoise2D(width, height, expt, clip) ~ generates pink noise, the
%exponent affects the 1/f^exp and the clip cuts extreme values. Default for
%this experiment is 1 and 5. 
% 
%Experiment(Images, map, ratios) ~ this runs a PyschToolbox implementation
% of the expeirment. It takes in an array of images, the map correlating one image in the array with its closest likelihod 
%in the other noise type, and hten the ratios themsleves. 
%
%histogram3 ~ a 3 dimensional histogram implementation for Matlab.
% 
%image_map(R, trials) takes in the ratios and computes a map for correlating log
% likelihoods between image indexes. 
% 
%image_sort( map, R)m ~ takes the map and sorts images from lowest to
% highest log likelhiood
% 
%image_generator(trials, size) ~ Used to generate images for a certain number of trials and of a
% certain size. Use in favor of imagereader
%
%image_reader(trials, imsize) ~ defunct. Used on personal implementation to
% read pre generated iamges into memory. 
% 
%Plots ~ defunct. Used on personal implementation to generate plots. 
%
%ratiocalc(im size, trials, Images, cov_mat) ~ takes in the size of the
% image, the trial numbers, the image array themsleves, and the covariance
% matrix to compute log likelihood ratios for images. 
%
%scaledcontrast(_image_template, noise type, snr_level, image size)~ takes in an image
%template, a noise type string (white or pink), a desired contrast level, and a size,
% and creates the noisy image. 
% 
%testingcov(image size, trials, noise type, contrast level, covariance)~ a
%verification for the covariance matrix
%
%analyze_ans(E) ~ Takes the output of Experiment() and does some basic analysis 
% 
% confusion(E) ~ Computes the confusion matrix of an Experiment output
%
%Data.mat ~ sample data generated via a 500 trial test. 
%
%SeedforExperiment.mat ~ Data for running an Experiment() call already saved. Just load it and call the variables from it

%TL; DR version
%
%Use TLDRwrapper() to generate images and their ratios, then 
% get the desired array, then you can run Experiment to collect data. 
%



%EXAMPLE WORK FLOW first setup
% I = image_generator(trials, size)(takes a few minutes. On a 2013 laptop, 100 by 100 pixel images with 1000 trials is about 5 minutes)
% A = analytical_gen(size)
% R = ratio_calc(size, trials, I, A) (takes a few minutes to a few hours. On a 2013 laptop, 100 by 100 images with 1000 trials is about 40 minutes) 
% map = image_map(R, trials)
% s_map = image_sort(map, R)
% save (DATAFILE) 
% Experiment(I, s_map, R)


%EXAMPLE SECONDARY FLOW for saved data. 
% load(DATAFILE) (THAT YOU SAVED)
% Experiment(I, s_map,R)

