clear all;
clc; %close all;

randn('state',1)

N=800;

M = 400;
K=20;

 
T=100; lambda=1; 


noise=0:5:25

time_aver=zeros(length(noise),3); err_aver=zeros(length(noise),3); 
 
 time_cvx=zeros(T,1);time_sbl=zeros(T,1);
 time_asdbr=zeros(T,1);
 
  err_cvx=zeros(T,1);err_sbl=zeros(T,1);
 err_asdbr=zeros(T,1);
 
for i=1:length(noise)
    A = randn(M,N); 
    x =Spike(N, K);
   y0 = A*x; 
   y = awgn(y0,noise(i));
   
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
 semilogy(noise,time_aver(:,1),'k',noise,time_aver(:,2),'r',noise,time_aver(:,3),'b')
 
 
subplot(2,1,2)
semilogy(noise ,err_aver(:,1),'k',noise,err_aver(:,2),'r',noise ,err_aver(:,3),'b')

  



% subplot(2,1,1)
%  semilogy(noise(1:5),time_aver(1:5,1),'k',noise(1:5),time_aver(1:5,2),'r',noise(1:5),time_aver(1:5,3),'b')
%  
%  
% subplot(2,1,2)
% semilogy(noise(1:5) ,err_aver(1:5,1),'k',noise(1:5),err_aver(1:5,2),'r',noise(1:5) ,err_aver(1:5,3),'b')
% 
%   
