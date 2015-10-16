%% ImageReader: reads in the images in the correct format. Used for personal implementation.
function [outputs] = image_reader(trials, im_size)

	images = zeros(2,10, 1000, im_size, im_size);

	noise = 'pink'

	for i=1:2,
		for j=1:11,
			l=double((j-1)/20.0);
			for k=1:trials,
                image = double(imread(strcat('ImageLibrary/', noise, '/Contrast',num2str(l), '/Image',num2str(double(k)), '.png')));
                image = (image-min(image(:)))/(max(image(:))-min(image(:)));
                images(i,j,k,:,:) =image;
			end
		end
		noise = 'white'
	end
	outputs = images;