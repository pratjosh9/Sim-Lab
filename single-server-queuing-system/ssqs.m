function ssqs(ia_times, service_times)
	
	tmp_event = struct ("time", ia_times(1), "event", 'A');
	event_list = [tmp_event];
	arrival_times = [ia_times(1)];

	for i = 2:length(ia_times)
		tmp_event = struct("time", event_list(i-1).time + ia_times(i), "event", 'A');
		event_list =  [event_list, tmp_event];
		arrival_times = [arrival_times, arrival_times(i-1) + ia_times(i)];
	endfor

	delay = 0;
	server_status = "idle";
	idle_time = 0;
	num_customers = length(arrival_times);

	customer_in_service = 0;
	
	clock = 0;
	delay_list = [];
	
	while (customer_in_service <= num_customers && length(event_list) > 0)
		curr_event = event_list(1);
		event_list(1) = [];

		if curr_event.event == 'A';
			if (server_status == "idle")
				server_status = "busy";
				idle_time += curr_event.time - clock;
				clock = curr_event.time;
				customer_in_service += 1;
				tmp_event = struct ("time", curr_event.time + service_times(customer_in_service), "event", 'D');
				event_list = [event_list,tmp_event ];
				
				delay_list = [delay_list, 0];

				temp_cells = struct2cell(event_list);
				sortvals = temp_cells(1, 1, :);
				mat = cell2mat(sortvals);
				mat = squeeze(mat);
				[sorted, ix] = sort(mat);
				event_list = event_list(ix);

			endif
		
		else
			clock = curr_event.time;

			if (customer_in_service+1 <= num_customers)
				if (clock >= arrival_times(customer_in_service+1))
					customer_in_service += 1;
					tmp_delay = clock - arrival_times(customer_in_service);
					delay += tmp_delay;
					delay_list = [delay_list, tmp_delay];
					
					tmp_event = struct ("time", curr_event.time + service_times(customer_in_service), "event", 'D');
					event_list = [event_list,tmp_event ];

					temp_cells = struct2cell(event_list);
					sortvals = temp_cells(1, 1, :);
					mat = cell2mat(sortvals);
					mat = squeeze(mat);
					[sorted, ix] = sort(mat);
					event_list = event_list(ix);
				else
					server_status = "idle";
				endif
			endif
		endif

	endwhile

	printf("Average delay %f.\n", delay / num_customers);
	printf("Server Utilization %f.\n", (clock-idle_time) / clock);
	printf("Delays\n");
	disp(delay_list);

endfunction
