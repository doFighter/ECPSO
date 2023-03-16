clear;
close;
addpath("test_algorithm\");
addpath("functions\unimodal\");
addpath("functions\multimodal\");


iterate_max = 5000;
N = 30;
dim = [30,30,30,30,30,30,30,10,30,30,30,30];
x_max = [10,5.12,10,10,100,10,32.768,pi,500,10,600,5.12];
x_min = [-10,-5.12,-10,-5,-100,-10,-32.768,0,-500,-10,-600,-5.12];

func = {@quadric,@spheref,@schwef_p2_22,@rosen,@step,@sumsqu,@ackley,@michal,@schwef,@dixonpr,@griewank,@rastr};

max_runs = 100;
funcNum = 12;

outcome_ECPSO=zeros(max_runs,1);          %% to save the solutions of each run of ECPSO
Final_results_ECPSO=zeros(funcNum,5);    %% to save the final results of ECPSO


%% run on more than one processor
myCluster = parcluster('local');
myCluster.NumWorkers = 1;  % define how many processors to use

%% ========================= main loop ====================================
for I_fno= 1:funcNum
    dim_I = dim(I_fno);
    x_max_I = x_max(I_fno);
    x_min_I = x_min(I_fno);
    func_I = func{1,I_fno};
    parfor run=1:max_runs
        outcome_ECPSO(run) = ECPSO(N, dim_I, x_max_I, x_min_I, iterate_max, func_I);
    end
    Final_results_ECPSO(I_fno,:)= [min(outcome_ECPSO),max(outcome_ECPSO),median(outcome_ECPSO), mean(outcome_ECPSO),std(outcome_ECPSO)];
     % save the results in a text
    save('./results/results-ECPSO.txt', 'Final_results_ECPSO', '-ascii');
end