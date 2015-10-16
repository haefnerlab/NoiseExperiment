%%analyze_ans: A simplistic analysis of the Data from an Experiment() output. Plots the walk of contrast levels and the percent correct as functions of trials
%% Also computes the confusion matrix of the subject
function[out] =analyze_ans(E, trials)
L = confusion(E);
E = L.E;
l=1:trials;
k=1:trials;

l(1) = E(1).Orientation_Correct;

for i=2:trials
    l(i) = E(i).Orientation_Correct+l(i-1);
   

    k(i) = l(i)/i;
end

pink_E=zeros(0);
white_E=zeros(0);
for i=1:trials
	if strcmp(E(i).Noise_Response,'pink')
		pink_E(end+1) = E(i).Orientation_Correct;
		
	else
		white_E(end+1) = E(i).Orientation_Correct;
	end

end

pink_c = sum(pink_E(:))/trials
pink_w = sum(~pink_E(:))/trials
white_c = sum(white_E(:))/trials
white_w = sum(~(white_E(:)))/trials
L.white_confusion_matrix
L.pink_confusion_matrix
for i=1:(length(pink_E)-1)
	pink_E(i+1) = pink_E(i+1)+pink_E(i);
end

for i=1:(length(pink_E))
	pink_E(i) = pink_E(i)/i;
end
for i=1:(length(white_E)-1)
	white_E(i+1) = white_E(i+1)+white_E(i);
end

for i=1:(length(white_E))
	white_E(i) = white_E(i)/i;
end
plot(1:length(pink_E), pink_E);
hold on
plot(1:length(white_E), white_E);

plot(1:trials, k);
title('Percent Correct')
xlabel('Trials')
ylabel('Percentage')
legend('Pink', 'White', 'Total')
figure


b=1:trials;
a=1:trials;

for j=1:trials
	b(j)= E(j).First_Likelihood+0;
	a(j)= E(j).Second_Likelihood+0;
end

plot(1:trials, a(:));
hold on 
plot(1:trials, b(:));

title('Log-Likelihood Levels');
legend('Pink', 'White');
xlabel('Trials');
ylabel('Log-Likelihood Ratio');


end
