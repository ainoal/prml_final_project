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
    sample = preprocessing(sample.pos,0);
    %ceil(i/100)-1 -> add class - name corresponds to written number
    full_data{i} = [sample, (ceil(i/100)-1)*ones(size(sample,1),1)];   
end

for i = 1:num_files
    sample = preprocessing(full_data{i},1);
    full_data{num_files+i} = [sample, (ceil(i/100)-1)*ones(size(sample,1),1)]; 
end

shuff_data = full_data(randperm(numel(full_data)));
data = shuff_data{1};
[test_X,test_Y,train_X,train_Y] = split_data(data(:,1:3),data(:,4:4),0.8);
class_res = classification(train_Y,train_X,test_X,3);

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

%test = preprocessing(stroke_0_0001,0);
%test_skew = preprocessing(stroke_0_0001,1);