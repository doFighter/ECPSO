%% =====================================================================%%
%% Elite Collaborative Particle Swarm Optimization Based on Adaptive Particle Swarm Migration
% Author：Xiaobin Chen
% Encoding format：utf-8
% N: Population size
% dim:Dimensions of solving problems
% x_max:Solution space upper bound
% x_min:Lower bound of solution space
% iterate_max:Maximum number of iterations
% fitness:evaluation function
%% --------------------------------------------------------------------%%
function[rest]=ECPSO(N,dim,x_max,x_min,iterate_max,fitness)
    % Initialize the algorithm parameters.
    is_migrate = 0;
    migrate_rate = 0.1;
    stagnate = 7;
    flag = 0;
    init_density = (x_max-x_min)/N;
    population_density = init_density;
    elite_num = N;
    c = 2*ones(1,2);
    v_min = x_min*0.2;
    v_max = x_max*0.2;
    x = x_min + (x_max-x_min)*rand(N,dim); % Initialize population position
    v = v_min + (v_max-v_min)*rand(N,dim); % Initializing population velocity
    pBest = x;  
    gBest = x(1,:);
    for i = 2:N
       if fitness(gBest) > fitness(x(i,:))
          gBest = x(i,:); 
       end
    end
    old_gBest = gBest;
    iterate = 1;
    res = inf*ones(N,1);
    while iterate <= iterate_max
        % Execute speed update operation according to different stage rule.
        omega = 0.9 - 0.5*((iterate-1)/iterate_max);
        if is_migrate == 0
            v = omega*v + c(1)*rand(N,dim).*(pBest-x) + c(2)*rand(N,dim).*(gBest-x);
        else
            migrate_omega = 0.9 - 0.5*((iterate-iterate_migrate)/(iterate_max-iterate_migrate));
            for i=migrate_index
                v(i,:) = migrate_omega*v(i,:) + c(1)*rand(1,dim).*(pBest(i,:)-x(i,:)) + c(2)*rand(1,dim).*(gBest-x(i,:));
            end
            for i=erp_index
                v(i,:) = omega*v(i,:) + c(1)*rand(1,dim).*(pBest(i,:)-x(i,:)) + c(2)*rand(1,dim).*(gBest-x(i,:));
            end
        end
        % Update the location.
        v(v>v_max) = v_max;
        v(v<v_min) = v_min;
        x = x + v;
        x(x>x_max) = x_max;
        x(x<x_min) = x_min;
        % Update pbest
        for i = 1:N                     
            if fitness(x(i,:)) < fitness(pBest(i,:))   
                pBest(i,:) = x(i,:);
            end
            res(i) = fitness(pBest(i,:));
        end
        % Update gbest
        if min(res) < fitness(gBest)        
            position = find(res == min(res));
            gBest = pBest(position(1),:);
        end
        %% Execute elite collaboration strategy.
        % Get elite set
        [~, pBest_index] = sort(pBest);
        elite_index = pBest_index(1:elite_num);
        % Random select elite particles for elite learning.
        ep = randperm(elite_num-1, 1)+1;
        elite_particle = pBest(elite_index(ep), :);
        temp_pre = gBest;
        temp_next = temp_pre;
        for j=1:dim
            temp_next(j) = elite_particle(j);
            if fitness(temp_pre) > fitness(temp_next)
               temp_pre = temp_next;
            else
               temp_next = temp_pre;
            end
        end
         % Update the global optimum again
        if fitness(gBest) > fitness(temp_pre)
            gBest = temp_pre;
        end
        % Judging whether the global optimum is updated.
        if isequal(old_gBest, gBest)
            flag = flag + 1;
        else
            flag = 0;
            is_migrate = 0;
        end
       %% Execute particle swarm migration.
        % Calculate population density
        density = sum(sqrt((sum((pBest - gBest))).^2)) / (N*dim);
        if density <= population_density || flag > stagnate
           % When the particle swarm does not stagnate, only a few migrating particles remain.
            if is_migrate == 0 || flag<=stagnate
               migrate_rate = 0.1;
               if density <= population_density
                    population_density = population_density/N;
               end
            else
                % The number of migrating particles increases when it is less than 0.9.
               if (0.9 - migrate_rate)>eps
                   migrate_rate = migrate_rate + 0.1;
               end
               if population_density<init_density
                   population_density = population_density * N;
               end
            end
            is_migrate = 1;
            migrate_num = round(migrate_rate * N);
            % Exploration particle index
            migrate_index = pBest_index(N- migrate_num+1:N);
            % Exploitation particle index
            erp_index = pBest_index(1:N- migrate_num);
            % Resetting exploration particles
            iterate_migrate = iterate+1;
            flag = 0;
            for i=migrate_index
                pBest(i, :) = x_min + (x_max-x_min)*rand(1,dim);
                x(i, :) = x_min + (x_max-x_min)*rand(1,dim);
                v(i, :) = v_min + (v_max-v_min)*rand(1,dim);
            end
        end
        old_gBest = gBest;
        iterate = iterate + 1;
    end
    rest = fitness(gBest);
end