function [xs] = SparseVector(N,K)
    xs = zeros(N,1);
    kind = randperm(N);
     kind = kind(1:K);
    xs(kind) = randn(K,1);
    
    
%     for i=1:K
%             if abs(xs(kind(i)))<0.01*max(abs(xs(kind)))
%                 xs(kind(i))=0.01*max(abs(xs(kind)));
%             end
%     end
                
%  x_ran=randn(2*K,1);
%  [~,I]=sort(abs(x_ran),'descend');
%  I=I(1:K,1);
%  xs(kind)=x_ran(I);

% xs = xs/norm(xs);
end