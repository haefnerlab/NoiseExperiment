%%check_snr: Deprecated. Used to be used to analyze SNR levels
function[res] = check_snr(noisy_image, template, image)
image = double(image);
image = (image - min(image(:)))/(max(image(:))-min(image(:)));
template = double(template);
template = (template- min(template(:)))/(max(template(:))-min(template(:)));
noisy_image = (noisy_image - min(noisy_image(:)))/(max(noisy_image(:))-min(noisy_image(:)));
imagev = reshape(image, 250000, 1);
templatev = reshape(template, 1,  250000);
dif = dot(double(templatev), double(imagev));
dif = dif - dot(double(templatev), double(reshape(imrotate(image, 90), 250000, 1)));
res =abs((dif/std(dot(double(template), double(noisy_image)))));