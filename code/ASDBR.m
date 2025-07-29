function [x,err,ids] = ASDBR(y, Phi, lambda,iters)
threshold1 = 1e-2;
[M,N] = size(Phi) ;
x = zeros(N,1) ;
% Gamma = 1e-2*eye(N) ;
% Hygamma = diag(Gamma);
reserved_ids = (1:N)';

W=eye(N); % initialized the reweighted matitx 

ids=[];err=[];

for iter = 1:iters
 
   N_0=size(Phi,2);
   xhat =ISTA(y,Phi,lambda,1000,diag(W));
    
   % [xhat,~]=AMP(y,Phi,lambda,200,diag(W));
     
%     cvx_begin quiet
%     cvx_solver sedumi   %sdpt3
%     variable Z(N) 
%     minimize    (lambda*norm(W*Z,1)+ 0.5*(Phi*Z-y)'*(Phi*Z-y))
%                     subject to
%                               W.^2-ones(101,1)<=0;
%     cvx_end
%     
%     xhat=Z;
     
     
    % prune redundant basis functions
    delete_ids = find(abs(xhat)<threshold1*max(abs(xhat)));%norm(abs(xhat)))
    reserved_ids(delete_ids) = [] ;
    Phi(:,delete_ids) =[] ;
%     Hygamma(delete_ids) = [];
%     lambdas(iter,1) = lambda ; 
    
        
 % update the weighted matrix
    w_past=diag(W);
    w_past(delete_ids) = [];
    xhat(delete_ids)=[];
    Hygamma=abs(xhat)./w_past;
    Gamma = diag(Hygamma);
   
     N = size(Phi,2); %if Phi is over-determined using Woodbury identity to calculate Sigma
    if M < N
        W0=lambda*eye(M)+ Phi*Gamma* Phi';
        w0=diag(Phi'*(W0\Phi));
        w=sqrt(w0);
        W=diag(w);
      % Sigma = inv( diag(1./Hygamma)+Phi'*Phi/lambda);
    else   
        r=1/lambda;T=r*(Phi'*Phi);
        S=diag(1./Hygamma)+T;
        W0 =T-T*(S\T);
        w=sqrt(diag(W0));
        W=diag(w); 
    end 
   
  ids=[ids,N];  
  err0=norm(y-Phi*xhat);
  err=[err,err0];
  
  
    if N_0-N==0
        break;
    end
 
         
end
x(reserved_ids) = xhat;
% if normolized ==1
%     x = x * y_max ./Phi_norm' ;
% end
% x(abs(x)./norm(x)<threshold1) = 0;

end


