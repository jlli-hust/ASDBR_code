clear all
clc
%rand('state',99)

randn('state', 1);

% rng(99)
%rng('default');
N = 800;
M =400;


A = randn(M,N);
% A = orth(A')'; 


% x =Spike(N, 20);
 x=SparseVector(N, 20);
 

  y0 = A*x;
    subplot(2,2,1) 
    plot(1:length(x),x)
    xlabel('(a) Spikes');
    ylim([-1.1,1.1])

  % --Gaussian noise-----------------------------
%   SNR = 1e-3; %dB
%   noise = randn(M,1);
%   noise = noise/std(noise) *10^(-SNR/20)*std(y0);  



  y = awgn(y0,5);   
  
  save('data_gaussian','A','y','x')   
%   y = y0 + noise;
%  subplot(2,2,2) 
%   plot(1:M,y)
        
%  lamdas = logspace(log10(1e-5),log10(10),30);
       
 iter=10;lambda=1;
        
%% lasso    
t0 = tic;    
 cvx_begin quiet
    cvx_solver sedumi   %sdpt3
    variable Z(N) 
    minimize    (lambda*norm(Z,1)+ 0.5*(A*Z-y)'*(A*Z-y))
    %                 subject to
    %                           W.^2-ones(101,1)<=0;
    cvx_end
   x_lasso=Z;
   %time_cvx=toc(t0);  
   err_lasso=norm(x_lasso-x,2)/norm(x);
   
figure(1);subplot(2,2,2);plot(1:length(x_lasso),x_lasso);
xlabel(sprintf('(b) Lasso,  RNMSE=%.3f, T=%.2fs',err_lasso,toc(t0)));xlim([0,800])
ylim([-1.1,1.1])

%% SBL    
t0 = tic;    
 x_sbl = tac_reconstruction(y, A, lambda,5);
%  ASDBR(y,A,10);
 x_sbl =x_sbl(:,end);
 err_sbl=norm(x_sbl-x,2)/norm(x);

figure(1);subplot(2,2,3);plot(1:length(x_sbl),x_sbl);
xlabel(sprintf('(b) SBL, RNMSE=%.3f, T=%.2fs',err_sbl,toc(t0)));xlim([0,800])
 ylim([-1.1,1.1])

%% asdbr    
t0 = tic;    
[x_asdbr,err,ids] = ASDBR(y,A,lambda, 10);
err_asdbr= norm(x_asdbr-x,2)/norm(x);

figure(1);subplot(2,2,4);plot(1:length(x_asdbr),x_asdbr);
xlabel(sprintf('(d) ASDBR, RNMSE=%.3f, T=%.2fs',err_asdbr,toc(t0)));xlim([0,800])
  ylim([-1.1,1.1])
 
