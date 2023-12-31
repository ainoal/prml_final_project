% Pattern Recognition and Machine Learning
% Final Project

% DEMO FOR VALIDATION OF THE MODEL. THIS FILE HAS BEEN USED FOR TRAINING
% AND VALIDATION, BUT IS NOT USED WHEN THE FUNCTION digit_classify(testdata) 
% IS CALLED.

clc;
clear;
rng("default");
%load("digits_3d\training_data\stroke_0_0001.csv")

% Reading directory
files = fileDatastore('digits\training_data\*.mat','ReadFcn',@importdata);
file_names = files.Files;
num_files = length(file_names);
full_data = {};

k = 9;

for i = 1:num_files
    sample = load(file_names{i});
    sample.pos(:,end+1:end+1) = [diff(sample.pos(:,1:1)); 0];
    sample.pos(:,end+1:end+1) = [diff(sample.pos(:,2:2)); 0];
    sample = preprocessing(sample.pos,0);

    % Add class in the data
    full_data{i} = [sample, (ceil(i/100))*ones(size(sample,1),1)];   
end
shuff_data=full_data(randperm(numel(full_data)));
training_data = shuff_data(1:0.8*length(full_data));
test_data = shuff_data(length(training_data)+1:end);
for i = 1:length(training_data)
    sample = preprocessing(training_data{i},1);
    training_data{length(training_data)+1} = [sample, (ceil(i/100))*ones(size(sample,1),1)]; 
end

time_normalized_data = normalize_for_time(training_data);
flat_data = flatten_data(time_normalized_data);
merged_data = merge_data(flat_data);

time_normalized_test = normalize_for_time(test_data);
flat_test = flatten_data(time_normalized_test);
merged_test = merge_data(flat_test);
test_X = merged_test(:,1:end-1);
test_Y = merged_test(:,end:end);
%shuff_data = merged_data(randperm(numel(merged_data)));
%[test_X,test_Y,train_X,train_Y] = split_data(merged_data(:,1:end-1),merged_data(:,end:end),0.8);
train_X = merged_data(:,1:end-1);
train_Y = merged_data(:,end:end);
class_res = classification(train_Y,train_X,test_X,k);
acc = calc_err(class_res,test_Y);


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

% Make all the matrices the same length
function time_normalized_data = normalize_for_time(full_data)
    time_normalized_data = {};
    smallest_length = 19;
    % Loop through all the digits
    for i = 1:length(full_data)
        disp(i)
        indices = floor(linspace(1, size(full_data{i},1), smallest_length));
        data_matrix = zeros(smallest_length,6);
        % Loop through all the rows in the digit matrix
        for j = 1:smallest_length
            temp1 = indices(j);
            data_matrix(j,:) = full_data{i}(indices(j),:);
            % use the previous result as the index
            time_normalized_data{i} = data_matrix;
        end
    end
end

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
