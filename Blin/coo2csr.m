function [xadj, adjncy] = coo2csr(w)
    %nedges = nnz(w);
    %nvtxs = size(w,1);

    spa = sparse(w);
    
    [adjncy,~] = find(spa);
    cnt = sum(w~=0,1);
    xadj= cumsum([1 cnt]);

    % for index = 1:size(adjncy,1)
    %     if adjncy[i] ==     
    %     xadj = [xadj xadj(i)+]
    % end 
    
end