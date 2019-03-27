function is(demands, demand_times, order_arrival_times)
	
	# Note: Time for the events is given in days. Days are given from a year.

	# Adding demand events to the event list.
	tmp_event = struct ("time", demand_times(1), "event", 'D', "deltainventory", demands(1));
	event_list = [tmp_event];

	for i = 2:length(demand_times)
		tmp_event = struct ("time", demand_times(i), "event", 'D', "deltainventory", demands(i));
		event_list =  [event_list, tmp_event];
	endfor

	# Order Evaluation Events. Scheduled at the start of each month.
	order_eval_days = [1, 32, 60, 91, 121, 152, 182, 213, 243, 273, 305, 335];
	for i = 1:length(order_eval_days)
		tmp_event = struct ("time", order_eval_days(i), "event", 'O', "deltainventory", 0);
		event_list =  [event_list, tmp_event];
	endfor

	# End simulation event.
	tmp_event = struct ("time", 365, "event", 'E', "deltainventory", 0);
	event_list =  [event_list, tmp_event];
	
	i_neg_bar = 0;
	i_pos_bar = 0;
	s = 30;
	S = 70;

	current_inventory = 50;

	# Cost Multiplier Constants
	holding_cost_multiplier = 10;
	shortage_cost_multiplier = 15;
	set_up_cost_for_order = 32;
	incremental_cost_per_item = 8;

	total_order_placing_cost = 0;

	sim_not_complete = true;

	# Sort Events
	temp_cells = struct2cell(event_list);
	sortvals = temp_cells(1, 1, :);
	mat = cell2mat(sortvals);
	mat = squeeze(mat);
	[sorted, ix] = sort(mat);
	event_list = event_list(ix);

	curr_day = 1;

	order_arrival_idx = 1;

	while (sim_not_complete)
		# Getting the first event in the event list.
		curr_event = event_list(1);
		event_list(1) = [];

		# Demand Event
		if curr_event.event == 'D'
			time = curr_event.time - curr_day;
			if current_inventory > 0
				if curr_event.deltainventory <= current_inventory
					i_pos_bar += time * curr_event.deltainventory;
				else
					i_pos_bar += time * current_inventory;
				endif
			else
				i_neg_bar += -current_inventory * time;
			endif

			# Updating inventory and time
			current_inventory -= curr_event.deltainventory;
			curr_day = curr_event.time;
				
		# Order Evaluation event
		elseif curr_event.event == 'O'
			curr_day = curr_event.time;
			if current_inventory < s
				num_items = S - curr_event.deltainventory;
				# Scheduling order arrival event
				tmp_event = struct ("time", curr_day + order_arrival_times(order_arrival_idx), "event", 'A', "deltainventory", num_items);
				order_arrival_idx += 1;
				event_list =  [event_list, tmp_event];
				# Updating Costs
				total_order_placing_cost += set_up_cost_for_order + incremental_cost_per_item * num_items;
			else
				num_items = 0;
			endif

		elseif curr_event.event == 'A'
			if current_inventory < 0
				time = curr_event.time - curr_day; 
				i_neg_bar += (-current_inventory) * time;
			endif
			current_inventory += curr_event.deltainventory;			
			
		else
			sim_not_complete = false;
		endif

		# Sort Event List after the event occurs
		temp_cells = struct2cell(event_list);
		sortvals = temp_cells(1, 1, :);
		mat = cell2mat(sortvals);
		mat = squeeze(mat);
		[sorted, ix] = sort(mat);
		event_list = event_list(ix);

	endwhile

	avg_holding_cost = i_pos_bar * holding_cost_multiplier / 365;
	avg_shortage_cost = i_neg_bar * shortage_cost_multiplier / 365;
	total_cost = total_order_placing_cost + avg_shortage_cost + avg_shortage_cost;

	printf("Average Holding Cost %f.\n", avg_holding_cost);
	printf("Average Shortage Cost %f.\n", avg_shortage_cost);
	printf("Total Order Placing Cost %f.\n", total_order_placing_cost);
	printf("Total Cost %f.\n", total_cost)
	
endfunction
 