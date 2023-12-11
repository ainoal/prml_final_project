
function C = digit_classify(testdata) 
    clc;
    clear;

    k = 9;

    %testdata = load("digits\training_data\stroke_8_0012.mat");
    %testdata = testdata.pos;

    testdata = preprocessing(testdata, 0);

    % The matrix with the least rows in the training data has 19 rows.
    % If the test data digit has less rows, then 19 will be replaced by the
    % amount of rows of the given digit.
    if size(testdata,1) < 19
        smallest_length = size(testdata,1);
    else
        smallest_length = 19;
    end

    training_data = file_processing(smallest_length);

    
    % Calculate acceleration in x and y dimensions for the test data
    testdata(:,end+1:end+1) = [diff(testdata(:,1:1)); 0];
    testdata(:,end+1:end+1) = [diff(testdata(:,2:2)); 0];
    %Padding testdata with fake class 0 to match dimensions in function 
    testdata = [testdata zeros(size(testdata,1),1)];
    test_data_cell = [];
    test_data_cell{1} = testdata;
   
    time_normalized_test = normalize_for_time(test_data_cell, smallest_length);
    flat_test = flatten_data(time_normalized_test);
    merged_test = merge_data(flat_test);

    test_X = merged_test(:,1:end-1);
    test_Y = merged_test(:,end:end);

    train_X = training_data(:,1:end-1);
    train_Y = training_data(:,end:end);
    class_res = classification(train_Y,train_X,test_X,k);
    C = class_res - 1
end

function merged_data = file_processing(smallest_length)
    % Reading directory
    files = fileDatastore('digits\training_data\*.mat','ReadFcn',@importdata);
    file_names = files.Files;
    num_files = length(file_names);
    full_data = {};
    
    for i = 1:num_files
        sample = load(file_names{i});
        sample.pos(:,end+1:end+1) = [diff(sample.pos(:,1:1)); 0];
        sample.pos(:,end+1:end+1) = [diff(sample.pos(:,2:2)); 0];
        sample = preprocessing(sample.pos,0);
    
        % Add class in the data
        full_data{i} = [sample, (ceil(i/100))*ones(size(sample,1),1)];   
    end
    training_data=full_data(randperm(numel(full_data)));
    for i = 1:length(training_data)
        sample = preprocessing(training_data{i},1);
        training_data{length(training_data)+1} = [sample, (ceil(i/100))*ones(size(sample,1),1)]; 
    end
    
    time_normalized_data = normalize_for_time(training_data, smallest_length);
    flat_data = flatten_data(time_normalized_data);
    merged_data = merge_data(flat_data);
end

% Make all the matrices the same length
function time_normalized_data = normalize_for_time(full_data, smallest_length)
    time_normalized_data = {};

    % Loop through all the digits
    for i = 1:length(full_data)
        disp(i)
        indices = floor(linspace(1, size(full_data{i},1), smallest_length));
        data_matrix = zeros(smallest_length,6);
        % Loop through all the rows in the digit matrix
        for j = 1:smallest_length
            %temp = full_data{i}(indices(j),:);
            %temp2 = data_matrix(j,:);
            data_matrix(j,:) = full_data{i}(indices(j),:);
            % use the previous result as the index
            time_normalized_data{i} = data_matrix;
        end
    end
end

%{
function time_normalized_test = normalize_test_data(test_data, smallest_length)
    indices = floor(linspace(1, size(test_data,1), smallest_length));
    time_normalized_test = zeros(smallest_length, 6);
    for j = 1:smallest_length
        time_normalized_test(j,:) = test_data(indices(j),:);
    end
end
%}

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
