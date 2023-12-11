
function [data_out] = preprocessing(data,skew_mode)
    min_skew_angle = deg2rad(-7);
    max_skew_angle = deg2rad(7);
    
    if skew_mode == 1
        data_out=skew_data(data(:,1:size(data,2)-1),min_skew_angle,max_skew_angle);
        
    else
        
        data_out = data;
        data2d=data_out(:,1:2);
        
        % Best results achieved by using moving mean for each coordinate
        % set and then appliying lowpass filter over second dimension across coordinates
        % Apply lowpass
        b2 = 1;
        a2 = [1 -0.7];
        data2d = filter(b2,a2,data2d,[],1);
        b1 = [1 0.9];
        a1 = 1;
        data2d = filter(b1,a1,data2d,[],1);



        data_out(:,1:2) = data2d;

        data_out = normalize(data_out,1);
    end
end



function [data_out] = skew_data(data,min_thet,max_thet)
    vel_data = data(:,4:size(data,2));
    data = data(:,1:3);
    theta = min_thet+((max_thet-min_thet).*(rand));
    R = [cos(theta) -sin(theta) 0;
         sin(theta) cos(theta) 0;
         0  0 1];
    data_out = [data*R vel_data];
end

