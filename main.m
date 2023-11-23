% Pattern Recognition and Machine Learning
% Final Project
clc;
clear;
%load("digits_3d\training_data\stroke_0_0001.csv")

% Reading directory
files = fileDatastore('digits_3d\training_data\*.mat','ReadFcn',@importdata);
file_names = files.Files;
num_files = length(file_names);
full_data = {};
perc_skew = 0.8;
filenames_skew = file_names(randperm(numel(file_names)));

for i = 1:num_files
    sample = load(file_names{i});
    full_data{i} = preprocessing(sample.pos,0);   
end

for i = 1:perc_skew*num_files
    sample = load(filenames_skew{i});
    full_data{num_files+i} = preprocessing(sample.pos,1);
end
% Data preconditioning


%test = preprocessing(stroke_0_0001,0);
%test_skew = preprocessing(stroke_0_0001,1);