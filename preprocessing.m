
function [data_out] = preprocessing(data,skew_mode)
    min_skew_angle = deg2rad(-5);
    max_skew_angle = deg2rad(5);
    
    if skew_mode == 1
        data_out=skew_data(data(:,1:size(data,2)-1),min_skew_angle,max_skew_angle);
        
    else
        %data_out=pcdenoise(pointCloud(data));
        data_out = data;
        % Window size of 5 and 7 deliver the best results
        window = 5;
        b =(1/window)*ones(1,window);
        a=1;
        data_out(:,1:1)=filter(b,a,data_out(:,1:1));
        data_out(:,2:2)=filter(b,a,data_out(:,2:2));
        data_out(:,3:3)=filter(b,a,data_out(:,3:3));
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

