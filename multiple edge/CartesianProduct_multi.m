function T = CartesianProduct_multi(s)
%%%
    %%s是cell; s每行代表一个集合 []
%%%
    nset = size(s,2);
    T = s{1};
    
    for i = 2:nset
        T = cartprod_multi(T, s{i});

    end
end