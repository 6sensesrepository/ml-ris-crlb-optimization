%% SIMULATION USING THE Y SIGNAL
clear all
addpath('/Users/carla.macias/Desktop/ROUTE56/EUSIPCO_github/ris-crlb-optimization/src/optimization_functions_1');
%addpath('/Users/carla.macias/Desktop/ROUTE56/EUSIPCO_github/ris-crlb-optimization/src/datasets');
warning('off','all')
tic
xBS=0; yBS=0; xRIS=5; yRIS=5; xM_real=9; yM_real=2.5;
Nr=51; Nt= 21; Nris=40;

% SNR definition
Bk=10e6; Tk=290; Boltzman=physconst('Boltzmann');
sigma2=Bk*Tk*Boltzman; M0=64;
SNR=20; SNRlineal=db2pow(SNR);
powerP=SNRlineal*(sigma2*M0);

load("Normalize_parameters.mat")

% Load network
preloaded_net=importNetworkFromPyTorch('mlp_model_40phases.pt');
param1 = [-1.7217, -1.6806]';
dlX1 = dlarray(param1,'CB');
net_original=initialize(preloaded_net, dlX1);

preloaded_net=importNetworkFromPyTorch('mlp_model_40phases_smoothed.pt');
dlX1 = dlarray(param1,'CB');
net_uniform=initialize(preloaded_net, dlX1);

preloaded_net=importNetworkFromPyTorch('mlp_model_40phases_smoothed_conditional.pt');
dlX1 = dlarray(param1,'CB');
net_conditioned=initialize(preloaded_net, dlX1);

%%

f = 28; j=sqrt(-1); Q=0.2;
c = physconst('LightSpeed'); lambda = c/(f*10^9);
Lbr=1; Lrm=1; delta=lambda/2; mu=3; B=(Nr-1)/2; M=(Nt-1)/2;
B_vect=-B:B; M_vect=-M:M; R=(Nris-1)/2;

% Iterations parameter
iterations=30;  itMC=2000;

%Results vectors definition
RMSEposc_vect_CRLB_MC_original=nan(itMC, iterations);
RMSEposc_vect_CRLB_MC_uniform=nan(itMC, iterations);
RMSEposc_vect_CRLB_MC_conditioned=nan(itMC, iterations);

% Distance between BS and scatters & between scatteres and RIS
r_br=sqrt((xRIS-xBS)^2+(yRIS-yBS)^2); d_br=r_br;
% Angle of departure between RIS and BS
AODbr_grad=acosd((xRIS-xBS)/r_br)+90; AODbr=AODbr_grad*(2*pi)/360;
% Angle of arrival between RIS and BS (deg)
AOAbr_grad=180+AODbr_grad;  AOAbr=AOAbr_grad*(2*pi)/360;

% Distance between RIS and scatters & scatteres an UE
r_rm=sqrt((xM_real-xRIS)^2+(yM_real-yRIS)^2); d_rm= r_rm;
% Angle of departure between UE and RIS (deg)
AODrm_grad=acosd((abs(yRIS-yM_real))/r_rm);  AODrm=AODrm_grad*(2*pi)/360;
% Angle of arrival between UE and RIS (deg)
AOArm_grad=180+AODrm_grad;  AOArm=AOArm_grad*(2*pi)/360;

%%
for MC=1:itMC
    % Random paramenters
    F=sqrt(Q/2)*(randn(1)+j*randn(1));
    %phasesRIS_0=2*pi*rand(1,Nris)-pi;
    phasesRIS_0=zeros(1,Nris);

    %% H channel
    % Channel matrix between RIS and BS
    Abr=nan(Nr,Lbr); ro_br=zeros(Lbr,Lbr);
    Abr_h=nan(Nris,Lbr); % future hermitian
    for ll = 1:Lbr
        ro_br(ll,ll)=F*(c/(4*pi*(r_br(ll)+d_br(ll))*(f*10^9)))^(mu/2);
        for b=-B:B
            t=B+b+1;
            Abr(t,ll) = exp(j*(b*omega(AODbr(ll),delta,lambda) + (b^2)*gamma1(AODbr(ll),r_br(ll),delta,lambda)));
        end
        for r=-R:R
            g=R+r+1;
            Abr_h(g,ll) = exp(j*(r*omega(AOAbr(ll),delta, lambda) + r^(2)*gamma1(AOAbr(ll),d_br(ll),delta,lambda)));
        end
    end

    Hbr = Abr*ro_br*Abr_h';

    % Channel matrix between US and RIS
    Arm=nan(Nris,Lrm); ro_rm=zeros(Lrm,Lrm);
    Arm_f=zeros(Nt,Lrm); % hermitian
    for ll = 1:Lrm
        ro_rm(ll,ll)=F*(c/(4*pi*(r_rm(ll)+d_rm(ll))*f))^(mu/2);
        for r=-R:R
            g=R+r+1;
            Arm(g,ll) = exp(j*(r*omega(AODrm(ll),delta,lambda) + r^(2)*gamma1(AODrm(ll),r_rm(ll),delta,lambda)));
        end
        for m=-M:M
            s=M+m+1;
            Arm_f(s,ll) = exp(j*(m*omega(AOArm(ll),delta,lambda) + m^(2)*gamma1(AOArm(ll),d_rm(ll),delta,lambda)));
        end
    end
    Hrm = Arm*ro_rm*Arm_f';


    % X signal
    x = generate_random_prs_matrix(Nt,M0,powerP);

    [RMSEposc_CRLB_vect_original]=CRLB_signalY_IT_startSNR(Hbr, Hrm, iterations,xRIS,yRIS,xM_real,yM_real,Nr, Nt, Nris, phasesRIS_0, SNR,x,M0,d_rm,r_rm,AODrm_grad,AOArm_grad, sigma2,  param1, dlX1, net_original, mean_x, std_x, mean_y, std_y);
    [RMSEposc_CRLB_vect_uniform]=CRLB_signalY_IT_startSNR(Hbr, Hrm, iterations,xRIS,yRIS,xM_real,yM_real,Nr, Nt, Nris, phasesRIS_0, SNR,x,M0,d_rm,r_rm,AODrm_grad,AOArm_grad, sigma2,  param1, dlX1, net_uniform, mean_x, std_x, mean_y, std_y);
    [RMSEposc_CRLB_vect_conditioned]=CRLB_signalY_IT_startSNR(Hbr, Hrm, iterations,xRIS,yRIS,xM_real,yM_real,Nr, Nt, Nris, phasesRIS_0, SNR,x,M0,d_rm,r_rm,AODrm_grad,AOArm_grad, sigma2,  param1, dlX1, net_conditioned, mean_x, std_x, mean_y, std_y);
   

    RMSEposc_vect_CRLB_MC_original(MC,:)= RMSEposc_CRLB_vect_original;
    RMSEposc_vect_CRLB_MC_uniform(MC,:)= RMSEposc_CRLB_vect_uniform;
    RMSEposc_vect_CRLB_MC_conditioned(MC,:)= RMSEposc_CRLB_vect_conditioned;
    disp(MC)
end

% MC


MC_RMSE_result_CRLB_original=mean(RMSEposc_vect_CRLB_MC_original);
MC_RMSE_result_CRLB_uniform=mean(RMSEposc_vect_CRLB_MC_uniform);
MC_RMSE_result_CRLB_conditioned=mean(RMSEposc_vect_CRLB_MC_conditioned);


fig1=figure(1);
semilogy(MC_RMSE_result_CRLB_original,'-om','LineWidth',1)
hold on
semilogy(MC_RMSE_result_CRLB_uniform,'-ob','LineWidth',1)
hold on
semilogy(MC_RMSE_result_CRLB_conditioned,'-o','LineWidth',1)
legend('MLP Original Phases','MLP Uniform Smoothing','MLP Conditional Smoothing','Location','southwest')
xlabel('Iterations')
ylabel('RMSE')
hold off

time=toc
save('MLP_all_methods_tenth')

