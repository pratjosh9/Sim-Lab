job_queue = [1,2,-1;  5,5,-1; 6,4,-1; 6,5,-1; 6,15,-1;  6,4,-1; 7,3,-1; 8,6,-1; 8,3,-1];

q1 = [];
q2 = [];
q3 = [];

curr_time = 0;
num_total_jobs = length(job_queue);

num_completed_jobs = 1;
num_current_jobs = 1;
n_que = [];

while(num_completed_jobs <= num_total_jobs)
    while num_current_jobs <= num_total_jobs && job_queue(num_current_jobs,1)<= curr_time

        if length(q1) <= length(q2) && length(q1) <= length(q3)
            q1(length(q1) + 1) = num_current_jobs;
            num_current_jobs = num_current_jobs + 1;
        elseif length(q2) < length(q1) && length(q2) <= length(q3)
            q2(length(q2) + 1) = num_current_jobs;
            num_current_jobs = num_current_jobs + 1;
        else
            q3(length(q3) + 1) = num_current_jobs;
            num_current_jobs = num_current_jobs + 1;
        end
    end
        n_que(length(n_que) + 1) = length(q1) + length(q2) + length(q3);
        curr_time = curr_time + 1;
        if length(q1) > 0
            job_queue(q1(1),2) = job_queue(q1(1),2)-1;
            if job_queue(q1(1),2) == 0
                job_queue(q1(1),3) = curr_time;
                q1(1) = [];
                num_completed_jobs = num_completed_jobs + 1;
            end
        end
        if length(q2) > 0
            job_queue(q2(1),2) = job_queue(q2(1),2)-1;
            if job_queue(q2(1),2) == 0
                job_queue(q2(1),3) = curr_time;
                q2(1) = [];
                num_completed_jobs = num_completed_jobs + 1;
            end
        end
        if length(q3) > 0
            job_queue(q3(1),2) = job_queue(q3(1),2)-1;
            if job_queue(q3(1),2) == 0
                job_queue(q3(1),3) = curr_time;
                q3(1) = [];
                num_completed_jobs = num_completed_jobs + 1;
            end
        end

        % Jockeying Customer

        if length(q1) > length(q2) + 1
            q2(length(q2) + 1) = q1(length(q1));
            q1(length(q1)) = [];
        
        elseif length(q1) > length(q3) + 1
            q3(length(q3) + 1) = q1(length(q1));
            q1(length(q1)) = [];
        
        elseif length(q2) > length(q1) + 1
            q1(length(q1) + 1) = q2(length(q2));
            q2(length(q2)) = [];
        
        elseif length(q2) > length(q3) + 1
            q3(length(q3) + 1) = q2(length(q2));
            q2(length(q2)) = [];
        
        elseif length(q3) > length(q2)+1
            q2(length(q2) + 1) = q3(length(q3));
            q3(length(q3)) = [];
        
        elseif length(q3) > length(q1) + 1
            q1(length(q1) + 1) = q3(length(q3));
            q3(length(q3)) = [];
        end
end

average_number_of_customer_in_queue = sum(n_que) / curr_time
delay=[];
job_queue
for i=1:num_total_jobs
    delay(length(delay) + 1) = job_queue(i,3) - job_queue(i,1);
end

average_delay = sum(delay) / num_total_jobs