function [testclass] = classification(trainclass, traindata, testdata, k)
    % k nearest neighbour classification. Input: trainclass (m*1 matrix),
    % traindata (m*n matrix), testdata (m*n matrix), k (integer). Outputs m*1 vector of classification results

    testclass = zeros(size(testdata,1),1);
    for i = 1:size(testdata,1)
            %Initialization of variables
            dist = zeros(size(traindata,1),1);
            sample = testdata(i,:);
        %Calculation of distances based on euclidian norm
        for j = 1:size(traindata,1)
            data = traindata(j,:);
            dist(j)=norm(data-sample);
        end
        %adding classes and sorting by distance
        near_neigh = [dist,trainclass];
        near_neigh = sortrows(near_neigh);
        c= [0 0 0 0 0 0 0 0 0 0];
        
        %Classification based on cumulative vote
        for l = 1:k
            c(near_neigh(l,2)) = c(near_neigh(l,2))+1;
        end
    
        [~,testclass(i)] = max(c);
    end
end