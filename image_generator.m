%% image_generator: Generates iamges given a size and number of trials per contrast level. 
function [outputs] = image_generator(trials, im_size)
    %11 steps used going from 0 to .5
	images = zeros(2,11, trials, im_size, im_size);

	noise = 'pink'
    template = imread('pioverfour.png');
    rounded = 'TRUE';
    circle_template = ones(im_size, im_size);
    for x=1:im_size
    	for y=1:im_size
    		if ((x-im_size/2)^2 +(y-im_size/2)^2) >= (im_size/2)^2
    			circle_template(x,y) =0;
    		end
    	end
    end
   % imshow(circle_template);
	for i=1:2,
		for j=1:11,
			l=double((j-1)/20.0);
			for k=1:trials,
                image = scaled_contrast(template,noise, l, im_size);
                image = image.noisy_image;
                if strcmp(rounded, 'TRUE')
                	image = image .* circle_template;
                	
                end

                image = (image-min(image(:)))/(max(image(:))-min(image(:)));
                images(i,j,k,:,:) =image;
			end
		end
		noise = 'white'
	end
	outputs = reshape(images, [2,trials * 11 , im_size,im_size]);