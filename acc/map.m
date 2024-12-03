function acc = map(rec, ideal)
    [numUsers, ~] = size(rec); % no. of queries
    aps = zeros(numUsers, 1);  % store every AP

    for u = 1:numUsers
        queryRecs = rec(u, :);
        userTrueFeedback = ideal(u, :);
        
        hitCount = 0; 
        cumPrecision = 0;
        
        for k = 1:length(queryRecs)
            % if this recommendation is close to the ideal.
            if norm(userTrueFeedback(k)-queryRecs(k)) < 1e-6
                hitCount = hitCount + 1;
                cumPrecision = cumPrecision + hitCount / k;
            end
        end
        
        % calculate AP   
        if hitCount > 0
            aps(u) = cumPrecision / hitCount;
        else
            aps(u) = 0;
        end
    end

    % mean of all APs（MAP）
    acc = mean(aps);
end
