function[para] = Experiment_Parameter_Set_Up(exp_type)

    load('ROUNDIMAGEDATA.mat');
    para.Images = Images;
    para.Ratios = R;
    para.Map = s_map;
if strcmp(exp_type, 'normal'),

    para.ordering = 'random'
    
    
elseif strcmp(exp_type, 'blocked'), 
    
    para.ordering = 'blocked'
    
end
