% Pattern Recognition and Machine Learning
% Final Project
clc;
clear;
rng("default");
%load("digits_3d\training_data\stroke_0_0001.csv")

% Reading directory
files = fileDatastore('digits\training_data\*.mat','ReadFcn',@importdata);
file_names = files.Files;
num_files = length(file_names);
full_data = {};

k = 3;

for i = 1:num_files
    sample = load(file_names{i});
    % Y and Z are switched to what would be intuitive!
    % Therefore they are switched right away to make the code more
    % understandable
    %temp_sample = sample.pos;
    %sample.pos(:,2:2) = temp_sample(:,3:3);
    %sample.pos(:,3:3) = temp_sample(:,2:2);
    sample.pos(:,end+1:end+1) = [diff(sample.pos(:,1:1)); 0];
    sample.pos(:,end+1:end+1) = [diff(sample.pos(:,2:2)); 0];
    %sample.pos(:,end+1:end+1) = [0;diff(diff(sample.pos(:,1:1))); 0];
    %sample.pos(:,end+1:end+1) = [0;diff(diff(sample.pos(:,2:2))); 0];
    sample = preprocessing(sample.pos,0);
    %ceil(i/100)-1 -> add class - name corresponds to written number
    full_data{i} = [sample, (ceil(i/100))*ones(size(sample,1),1)];   
end

for i = 1:num_files
    sample = preprocessing(full_data{i},1);
    full_data{num_files+i} = [sample, (ceil(i/100))*ones(size(sample,1),1)]; 
end



%full_data = normalize_for_time(full_data);
time_normalized_data = normalize_for_time(full_data);
flat_data = flatten_data(time_normalized_data);
merged_data = merge_data(flat_data);
shuff_data = merged_data(randperm(numel(merged_data)));
[test_X,test_Y,train_X,train_Y] = split_data(merged_data(:,1:end-1),merged_data(:,end:end),0.8);
class_res = classification(train_Y,train_X,test_X,k);
acc = calc_err(class_res,test_Y);
%class_res = classification()


function [acc] = calc_err(testclass,control)
    true = 0;
    false = 0;
    for i = 1:size(testclass,1)
        if testclass(i) == control(i)
            true = true+1;
        else
            false = false+1;
        end
    end
    acc = true/(false+true);
    %disp("Accuracy in perc")
    %disp(acc*100);
end

function[test_X,test_y,train_X,train_y] = split_data(features,class_labels,perc)

    train_end = round(perc*size(features,1));
    test_start = train_end+1;
    test_end = size(features,1);
    
    train_X = features(1:train_end,:);
    train_y = class_labels(1:train_end,:);
    test_X  = features(test_start:test_end,:);
    test_y  = class_labels(test_start:test_end,:);

end

function time_normalized_data = normalize_for_time(full_data)
    time_normalized_data = {};
    smallest_length = 19;   % TODO: CHANGE TO BE DYNAMIC
    % Loop through all the digits
    for i = 1:length(full_data)
        %% Normalize for time
        disp(i)
        % floor(linespace from 1 to size(full_data{i} with 21 steps) + 1
        indices = floor(linspace(1, size(full_data{i},1), smallest_length)) + 1;
        %f = (size(full_data{i},1));
        %min_size = min(f(1,:))
        data_matrix = zeros(smallest_length,6);
        % Loop through all the rows in the digit matrix
        for j = 1:smallest_length
            debug = full_data{i}(j,:);
            temp1 = data_matrix(j,:);
            temp2 = full_data{i}(j,:);
            data_matrix(j,:) = full_data{i}(j,:);
            % use the result from the previous line as the index
            time_normalized_data{i} = data_matrix;
        end
        % set time_normalized_data{i}
    end
end
%Make flat data dynamic!
function [flat_data] =  flatten_data(data_cell_array)
    flat_data = [];
    for i = 1:length(data_cell_array)
        data = data_cell_array{i};
        data = data(:,1:5);
        data(:,3:3) = [];
        label = data_cell_array{i}(1,6);
        flat_data{i} = reshape(data',1,[]);
        flat_data{i}(1,end+1) = label;
    end    
end

function[merged_data] = merge_data(flat_data)
    merged_data=[];
    for i = 1:length(flat_data)
        merged_data(i,:) = flat_data{i};
    end
end

%test = preprocessing(stroke_0_0001,0);
%test_skew = preprocessing(stroke_0_0001,1);