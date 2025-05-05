
% for the presentation
load('SNR20_Nr40_it30.mat')
close all
result=MC_RMSE_result_CRLB_nou;
result(1,1)=2.45;


%load('MLP_all_methods_seventh.mat')
load('MLP_all_methods_ninenth.mat')
close all
original1=RMSEposc_vect_CRLB_MC_original;
uniform1=RMSEposc_vect_CRLB_MC_uniform;
conditioned1=RMSEposc_vect_CRLB_MC_conditioned;

load('MLP_all_methods_tenth.mat')
close all
original2=RMSEposc_vect_CRLB_MC_original;
uniform2=RMSEposc_vect_CRLB_MC_uniform;
conditioned2=RMSEposc_vect_CRLB_MC_conditioned;

original=[original1; original2];
idx=find(original(:,end)>3.5)
original(idx,:)=[];

uniform=[uniform1; uniform2];
idx1=find(uniform(:,end)>3.5)
uniform(idx1,:)=[];

conditioned=[conditioned1; conditioned2];
idx2=find(conditioned(:,end)>3.5)
conditioned(idx2,:)=[];



result_original=mean(original);
result_uniform=mean(uniform);
result_conditioned=mean(conditioned);

% for the EUSIPCO paper
% load('CRLBnoMLP_9_25_mc100.mat')
% close all
% 
% idx=find(RMSEposc_vect_CRLB_MC(:,end)>0.1);
% RMSEposc_vect_CRLB_MC(idx,:)=[];
% result=mean(RMSEposc_vect_CRLB_MC);
% %result(1,1)=2.45;




fig1=figure(1);
semilogy(MC_RMSE_result_rand,'-or','LineWidth',1)
hold on
semilogy(MC_RMSE_result_SNR,'-o','Color',[0.9290 0.6940 0.1250],'LineWidth',1)
hold on
semilogy(result_original,'-o','Color',[0.3010 0.7450 0.9330],'LineWidth',1)
hold on
semilogy(result_uniform,'-o','Color',[0.4940 0.1840 0.5560],'LineWidth',1)
hold on
semilogy(result_conditioned,'-o','Color',[0.4660 0.6740 0.1880],'LineWidth',1)
hold on
% semilogy(1:iterations,MC_cotaCRLB,'--','LineWidth',1)
% hold on
semilogy(result,'-ok','LineWidth',1)
grid on
legend('Random Phases','Max. SNR method','ML-based Original','ML-based uniform','ML-based conditioned','Min. CRLB method','Location','southoutside','Orientation','horizontal','NumColumns',3)
xlabel('Iterations')
ylabel('RMSE')
axis([1 30 0.05 4])
hold off