%%histogram3: 3D Histogram plotter. A cna be any matrix of at least 2 dimensions. The output will be a histogram of the data in each row. 
function[out] = histogram3(A, V)

%Error handling 
A = squeeze(A);
if ~isrow(V),
	display('V must be a row vector containing a single number')
	return 
end
if size(V)<1 or size(V)>1,
	display('V must be a row vector of length one')
	return
end
if ~ismatrix(squeeze(A)),
	display('A must be a matrix of two dimensions')
	return
end


%Calculate spacing
max_val = max(A(:));
min_val = min(A(:));

n = linspace(min_val, max_val, V(1));
histo = zeros(length(n), size(A, 1));


%Count and bin data into histogram matrix
for i=1:size(A, 1),
	for j=1:size(A, 2),
		k=0;
		dist = Inf;
		while (((k) <= (length(n)-1)) && ((A(i, j)-n(k+1))^2)<dist),
			dist = (A(i,j)-n(k+1))^2;
			k=k+1;
		end
		histo(k, i) = histo(k,i) +1;
	end
end


out=histo;
bar3(n, histo);



