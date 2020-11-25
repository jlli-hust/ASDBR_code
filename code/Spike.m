function [xs] = Spike(N,K)
    xs = zeros(N,1);
    kind = randperm(N);
     kind = kind(1:K);
    xs(kind) = randsrc(K,1);
%  x0=sort(randn(N,1));
%  xs(kind)=x0(1:K,:);
%  
% xs = xs/norm(xs);
end