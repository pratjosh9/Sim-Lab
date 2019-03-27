% Time Shared Queue System

% Variable Definitions
job_queue = [1,7,-1;  4,9,-1; 6,5,-1;  8,5,-1;  12,6,-1;  19,3,-1];
num_jobs = 6;                           % number of jobs
num_jobs_completed = 0;                 % no. of jobs completed
curr_time = 0;                          % time
idle = 0;                               % idle time
quantum = 3;                            % quantum time
queue = [];                             % queue for server
idle = job_queue(1,1) - curr_time;      % server id idle until first job arrives
curr_time = job_queue(1,1);
queue(length(queue) + 1) = 1;
next_job = 2;                           % number of first job that is not arrived
wait_time = ones(1, num_jobs) * -1;     % array to store time when job served for 1st time
num_jobs_rr = 0;                        % store number of jobs in round robin queue 

while num_jobs_completed<num_jobs
    
    if length(queue)>0
        
        j = queue(1);   % job number of front job
        queue(1) = [];
        
        if wait_time(j) == -1
            wait_time(j) = curr_time - job_queue(j,1);
        end
        
        if job_queue(j,2) <= quantum
            % job processed for the time smaller than quantum
            curr_time = curr_time + job_queue(j,2);
            %  setting the departure time
            job_queue(j,3) = curr_time;  
            % job_queue(j,2) is the time of execution
            num_jobs_rr  = num_jobs_rr  + ((length(queue) + 1) * job_queue(j,2)); 
            % setting remaining time=0
            job_queue(j,2) = 0;  
            num_jobs_completed = num_jobs_completed + 1;
            
        else
            curr_time = curr_time + quantum;
            job_queue(j,2) = job_queue(j,2) - quantum;
            num_jobs_rr  = num_jobs_rr  + ((length(queue) + 1) * quantum);
        end

    else
       curr_time = curr_time + 1;
       idle = idle + 1;
    end

    while next_job <= num_jobs && job_queue(next_job,1) <= curr_time
        % for time t -job_queue(next_job,1) next_job is also in queue
        queue(length(queue) + 1) = next_job;
        num_jobs_rr = num_jobs_rr + curr_time - job_queue(next_job,1);  
        next_job = next_job + 1;
    end
    
    if job_queue(j,3) == -1   
        % if comletion time ==-1, it means job is not completed
        % add it again to the queue    
        queue(length(queue)+1) = j;
    end

end


% Report Generation Module 

job_queue
average_utilization = 100 * (curr_time - idle) / curr_time
wait_time
average_response_time = 100 * sum(rt) / num_jobs
average_number_of_customer = num_jobs_rr / curr_time
