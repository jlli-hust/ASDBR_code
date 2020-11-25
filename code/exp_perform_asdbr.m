clear 
close all;
randn('state',98)
%rng('default');
N = 1600;
M =800;

A = randn(M,N);
% A = orth(A')'; 


 x =Spike(N, 20);
% x=SparseVector(N, 10);
 

  y0 = A*x;
%    subplot(2,2,1) 
%    plot(1:M,y0)
  % --Gaussian noise-----------------------------
%   SNR = 1e-3; %dB
%   noise = randn(M,1);
%   noise = noise/std(noise) *10^(-SNR/20)*std(y0);  

  y = awgn(y0,15);      
%   y = y0 + noise;
%  subplot(2,2,2) 
%   plot(1:M,y)
        
%  lamdas = logspace(log10(1e-5),log10(10),30);
       
 iter=10;lambda=1;
        

    
 tic      
 [x_rec1,err,ids] = ASDBR(y,A,lambda, 10);
 toc
 
 norm(x_rec1-x,2)/norm(x) 
  
 figure(1)      
 plot(1:N,x,'r-',1:N,x_rec1,'b-')   
 
 figure(2)
 plot(x_rec1-x) 
 
 figure(3)
 plot(1:size(ids,2),ids,'b')
 xlabel('k')
 ylabel('Cardinality of support set')
 
  
  
  
  
  
  
  
  