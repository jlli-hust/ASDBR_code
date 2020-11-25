clear all;clc;%close all;


N = 800;
M =400;

A = randn(M,N);
% A = orth(A')'; 


 x =Spike(N, 10);
% x=SparseVector(N, 10);
 
 
  y0 = A*x;
           
  % --Gaussian noise-----------------------------
%   SNR = 1e-3; %dB
%   noise = randn(M,1);
%   noise = noise/std(noise) *10^(-SNR/20)*std(y0);  

  y = awgn(y0,30);      
%   y = y0 + noise;
        
%  lamdas = logspace(log10(1e-5),log10(10),30);
       
 lambda=0.01;iter=20;
        

    
 tic      
 [x_rec1,err,ids] = ASDBR(y,A,10);
 toc
 
  norm(x_rec1-x,2)/norm(x) 
  
 figure(1)      
 plot(1:N,x,'r-',1:N,x_rec1,'b-')   
 
 figure(2)
  plot(x_rec1-x) 