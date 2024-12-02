                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    function [w1,x] = blockDiagGraph(w, par, ix, nparts)
    v0 = find(diff([-1 par]));
    v1 = find(diff([par nparts+1]));    

    w = w(ix, ix);
    nparts = numel(v0);
    % Assign memory of cell head 
    x = cell(1,nparts);
    x{1, nparts} = [];
    
    for i = 1 : nparts
        x{i} = w(v0(i):v1(i),v0(i):v1(i));
    end    
    w1 = blkdiag(x{:});
end