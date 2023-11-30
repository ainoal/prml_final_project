function [testclass] = classification(trainclass, traindata, testdata, k)
    testclass = zeros(size(testdata,1),1);
    for i = 1:size(testdata,1)
            dist = zeros(size(traindata,1),1);
            sample = testdata(i,:);
        
        for j = 1:size(traindata,1)
            data = traindata(j,:);
            dist(j)=norm(data-sample);
        end
        near_neigh = [dist,trainclass];
        near_neigh = sortrows(near_neigh);
        c= [0;0;0;0;0];
        
        for l = 1:k
            c(near_neigh(l,2)) = c(near_neigh(l,2))+1;
        end
    
        [~,testclass(i)] = max(c);
    end
end