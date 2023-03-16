clc;
clear;
format SHORTENG;
addpath("test_algorithm\");
delete(gcp('nocreate'));

%% introductory Definitions
num_prbs = 30;                      %% number of test problems
max_runs=50;                        %% number of runs
ECPSO_outcome=zeros(max_runs,1);          %% to save the solutions of each run
Final_results_of_ECPSO=zeros(num_prbs,5);    %% to save the final results

% % run on more than one processor
myCluster = parcluster('local');
myCluster.NumWorkers = 10;  % define how many processors to use

%% ========================= main loop ====================================
for I_fno= 1:num_prbs
    parfor run=1:max_runs
        % Execute ECPSO
        ECPSO_outcome(run) = ECPSO(I_fno);
    end
    Final_results_of_ECPSO(I_fno,:)= [min(ECPSO_outcome),max(ECPSO_outcome),median(ECPSO_outcome), mean(ECPSO_outcome),std(ECPSO_outcome)];
    % save the results in a text
    save('./results/ECPSO.txt', 'Final_results_of_ECPSO', '-ascii');
end


