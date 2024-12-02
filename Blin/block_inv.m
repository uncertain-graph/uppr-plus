function [Q_inv,q_inv] = block_inv(x, c, npart)
    %I = eye(size(w));
    q_inv = cell(1, npart);
    q_inv{1,npart} = [];

    % Assign memory of cell head 
    for i = 1:npart
        I = speye(size(x{i}));
        q_inv{i} = inv(I - c*x{i});
        %q_inv{i} = x{i};
    end
    
    Q_inv = blkdiag(q_inv{:});
end