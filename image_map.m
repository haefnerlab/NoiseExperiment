%% image_match: Matches log likelihood ratios for different types of noise in image map. 
%% Use as a prep for running in image sort. 
%% Usage: image_map(ratios, trials per level);
function [outputs] = image_map(R, trials)
%Times 11 different levels generated for different contrast levels
tot=trials*11;
map = zeros(trials, 2);

%Matching images 
	for i=1:tot
		dist= Inf;
		trial_match = 1;
		for j=1:tot
			l = (R(1,i) - R(2,j))^2;
			if(l<dist)
				dist=l;
				trial_match=j;
			end
		end
		map(i,1)=i; 
		map(i,2)=trial_match;
    end
    
    %Return a map
outputs=map;
end


	
