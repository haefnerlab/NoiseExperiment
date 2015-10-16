function[out] = Plots(R, steps)

%Scatter Plot
ave_ratios = mean(R(:,:,:), 3);

scatter( ((0:steps)/20) ,ave_ratios(1, :), 'filled')
hold on 
scatter(((0:steps)/20), ave_ratios(2, :),'filled')
title('Log-Likelihood vs Image Contrast')
xlabel('Image Contrast')
ylabel('Log Likelihood' )
legend('Pink', 'White')
%3 Dimensional Histogram 
figure
histogram3(R(1,:,:), [25]);
title('Histogram of Pink Ratios as a functon of Contrast')
xlabel('Contrast')
ylabel('Value')
set(gca, 'XTickLabel',(0:10)/20);
figure
histogram3(R(2,:,:),[25]);
title('Histogram of White Ratios as a functon of Contrast')
xlabel('Contrast')
ylabel('Value')
set(gca, 'XTickLabel',(0:10)/20);

%2D KS densities
figure
hold on;
for i=1:11;
[f, xi] = ksdensity(squeeze(R(1,i,:)));
plot(xi, f);
end
title('Histogram of Pink Ratios vs. Probability Densities')
xlabel('Ratio')
ylabel('Probability Density')
legend('Contrast 0.0', 'Contrast 0.05','Contrast 0.1','Contrast 0.15','Contrast 0.2','Contrast 0.25','Contrast 0.3','Contrast 0.35','Contrast 0.4','Contrast 0.45','Contrast 0.5' )
figure 
hold on;
for i=1:11;
[f, xi] = ksdensity(squeeze(R(2,i,:)));
plot(xi, f);
end
title('Histogram of White Ratios vs. Probability Densities')
xlabel('Ratio')
ylabel('Probability Density')
legend('Contrast 0.0', 'Contrast 0.05','Contrast 0.1','Contrast 0.15','Contrast 0.2','Contrast 0.25','Contrast 0.3','Contrast 0.35','Contrast 0.4','Contrast 0.45','Contrast 0.5' )
figure 
hold on;
[f, xi] = ksdensity(squeeze((R(1,:))));
plot(xi, f);
[f, xi] = ksdensity(squeeze((R(2,:))));
plot(xi, f);

title('Histogram of Ratios vs. Probability Densities')
xlabel('Ratio')
ylabel('Probability Density')
legend('Pink', 'White')