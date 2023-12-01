
function [data_out] = preprocessing(data,skew_mode)
    min_skew_angle = -35;
    max_skew_angle = 35;
    
    if skew_mode == 1
        data_out=skew_data(data(:,1:size(data,2)-1),min_skew_angle,max_skew_angle);
        
    else
        data_out = normalize(data,1);
    end
end



function [data_out] = skew_data(data,min_thet,max_thet)
    theta = min_thet+((max_thet-min_thet).*(rand));
    R = [cos(theta) -sin(theta) 0;
         sin(theta) cos(theta) 0;
         0  0 1];
    data_out = data*R;
end

