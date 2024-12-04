function [subsets, len_subsets] = getAllSubsets(set)
    % Calculate the number of elements and subsets
    n = numel(set);
    numSubsets = 2^n-1;

    % Preallocate a cell array to store the subsets
    subsets = cell(1, numSubsets);
    len_subsets = cell(1, numSubsets);
    % Iterate over all possible combinations
    for i = 1:numSubsets
        % Initialize an empty vector to store the current subset
        currentSubset = [];

        % Check each element to see if it should be included
        for j = 1:n
            % Use bitwise AND to determine if the j-th element is included
            if bitand(i, 2^(j-1))
                currentSubset = [currentSubset, set(j)];
            end
        end

        % Store the current subset
        subsets{i} = currentSubset;
        len_subsets{i} = numel(currentSubset);
    end
   % subsets{end} =[];
end
