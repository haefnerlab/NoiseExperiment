%%scaled_contrast: Generates the images. 
%% Usage: scaled_contrast(Template, Noise type string, contrast, size of image)
function[O] = scaled_contrast(image, noise_type, contrast_level, image_size);
%Scale Image 
image = double(image);
image = (image - min(image(:)))/(max(image(:))-min(image(:)));
image = imresize(image, [image_size,image_size]);

%Generate noise pattern 
if strcmp(noise_type, 'pink'),
	noise = coloredNoise2D(image_size,image_size, 1, 5);
end
if strcmp(noise_type, 'white'),

	noise = randn(image_size,image_size); 
end
noise = double(noise);


%Compute powers
powerimage = sum(sum(abs(image).^2));
powernoise = sum(sum((abs(noise)).^2));
ratio = powernoise/powerimage;


%Scale the noise by the ratio and the SNR
image = sqrt(ratio) * ((image)); %*10^(contrast_level/10)
image = contrast_level * image;

%Generate and display the noisy_image
noisy_image =noise + image;

%Return
O.noise =noise;
O.noisy_image = noisy_image;
O.noisy_image = (O.noisy_image - min(O.noisy_image(:))) / (max(O.noisy_image(:)) - min(O.noisy_image(:)));

