clear all;
clc; %close all;

randn('state',1)

N=800;

M = 400;
K=20;

noise=10;

T=100; lambda=1; 


K=10:10:60

time_aver=zeros(length(noise),3); err_aver=zeros(length(noise),3); 
 
 time_cvx=zeros(T,1);time_sbl=zeros(T,1);
 time_asdbr=zeros(T,1);
 
  err_cvx=zeros(T,1);err_sbl=zeros(T,1);
 err_asdbr=zeros(T,1);
 
for i=1:length(K)
    A = randn(M,N); 
    x =Spike(N, K(i));
   y0 = A*x; 
   y = awgn(y0,noise);
   
 for t=1:T
     
   (i-1)*T+t
           
%%
t0=tic;
   cvx_begin quiet
    cvx_solver sedumi   %sdpt3
    variable Z(N) 
    minimize    (lambda*norm(Z,1)+ 0.5*(A*Z-y)'*(A*Z-y))
    %                 subject to
    %                           W.^2-ones(101,1)<=0;
    cvx_end
   x_rec0=Z;
   time_cvx(t,1)=toc(t0);  
    err_cvx(t,1)=norm(x_rec0-x,2)/norm(x);
 

%%                
 t0=tic;      
 x_rec1 = tac_reconstruction(y, A, lambda,5);
%  ASDBR(y,A,10);

 time_sbl(t,1)=toc(t0);  
 err_sbl(t,1)=norm(x_rec1(:,end)-x,2)/norm(x);
   
%%  
iter=10;

 t0=tic;      
 [x_rec2,err,ids] = ASDBR(y,A,lambda,iter);
  time_asdbr(t,1)=toc(t0);  
 err_asdbr(t,1)=norm(x_rec2-x,2)/norm(x);

 end

 time_aver(i,1)=mean(time_cvx);
  time_aver(i,2)=mean(time_sbl);
   time_aver(i,3)=mean(time_asdbr);
   
    err_aver(i,1)=mean(err_cvx);
  err_aver(i,2)=mean(err_sbl);
   err_aver(i,3)=mean(err_asdbr);
 
end

 subplot(2,1,1)
 semilogy(K,time_aver(:,1),'k',K,time_aver(:,2),'r',K,time_aver(:,3),'b')
 
 
subplot(2,1,2)
semilogy(K ,err_aver(:,1),'k',K,err_aver(:,2),'r',K ,err_aver(:,3),'b')



 



   