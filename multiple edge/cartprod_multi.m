function T = cartprod_multi(A, B)
    
    T = {};
    t = 1;
    if size(A{1},2)>1
        for i = 1:size(A,2)
            for j = 1:size(B,2)
                tmp = A{i};
                
                tmp{end+1} =  [];
              
                tmp{end} = B{j};
               
               T{t} = tmp;
               t = t+1;
            end
        end
    else
        for i = 1:size(A,2)
            for j = 1:size(B,2)

                 T{t} = [A(i), B(j)];
                 t = t+1;
                 
            end
        end
    end
end 


% tmp = A{i};
%            tmp = [A(i), B(j)];
%            T{t} = tmp;
% 
%            t = t+1;
% 
% 
% T(:,1)=[];