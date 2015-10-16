%% image_sort: Sorts an array of images based on their log likelihood ratio.
%% Array should be pre matched before passing using image_map. 
%% Usage: image_sort(map, ratios)
function [outputs] = image_sort(map, R)

    %Original Insertion sort code. 
	%for i=1:10999
	%	j=i;
	%	while j>1 && (R(1, map(j-1, 1)) >  R(1, map(j, 1)))	
	%			t = map(j, :);
	%			map(j, :) = map(j-1, :);
	%			map(j-1, :) = t;
	%			j=j-1;
	%	end
	%end

    
    %Present structure. Typical merge sort. Not much
    %special other than that. 
	res = zeros(0, 2);
	if size(map(:,1))<2,
		outputs=map;
		return
	else
		half = uint32(length(squeeze(map(:,1)))/2);
		bottom_half = map((1:half), :);
		top_half = map((half+1):end, :);
		bottom = image_sort(bottom_half, R);
		top = image_sort(top_half, R);
		a= not(isempty(bottom));
		b= not(isempty(top));
		while (a || b)
			if(a && b),
				[res(end+1, :),bottom , top ] = my_min(bottom, top, R);
            end
			if a && (~(b)),
				res = cat(1, res, bottom);
				bottom(:,:)=[];
            end
            
            if b && (~(a)),
				res = cat(1, res, top);
				top(:,:)=[];
            end
            
				a=not(isempty(bottom));
				b=not(isempty(top));

		end
    end
    
	outputs = res;
end

function [o,a,b] = my_min(a,b, R)
a(1,:);
b(1,:);
if(R(1, a(1,1)) < R(1, b(1,1)))
	o=a(1,:);
	a= a(2:end, :);
	else
	o=b(1,:);
	b = b(2:end, :);
	
end
end

%A check function that can be used to verify the sorting. 
function [success] = verify(res, R)

t=true;

i=1;

while i<50,
    if (R(1, res(i,1)) > R(1, res(i+1,1)))
        t=false;
    end
    i=i+1;
end
success=t;

end
