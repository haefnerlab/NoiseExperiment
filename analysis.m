function [out]  = analysis(E)

%Analyze each kind of noise
%First array is pink or white
%Second array is white only
% Third is pink only
%4th is forced choice

for i=1:4,
    L = E(i, :);
    
    for j= 1:length(L),
        
        res = analyze_type(L(j));
        
    end
    
end

end

function [res] = analyze_type(L)

if strcmp(L.Noise_Response, 'machine_selected'),
    
    disp('Forced Choice');
    res =4;
return
elseif strcmp(L.Experiment_Type, 'both'),
    disp('Both');
    
    res =1;

        elseif strcmp(L.Experiment_Type, 'white-2AFC')
    disp('white-2AFC');
    res=2;

return 
        elseif strcmp(L.Experiment_Type, 'pink-2AFC')
    disp('pink-2AFC');
    res=3;
    
    return 
end
        
        
res=10;
        end
        

        
        