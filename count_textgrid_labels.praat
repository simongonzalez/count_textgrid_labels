# This script calculates the number of labels in a TextGrid or multiple TextGrids
# If multiple TextGrid selection is speficied, the textgrids MUST be in contiguous numbers...
# in the object window
# Besides counting labels, the scrip also gives temporal information:
# frequency, duration, average duration and start and end time for intervals
# User selects either counting all labels in the TextGrid...
# or specific labels
#
# This script is distributed under the GNU General Public License.
# Copyright 15.06.2016 Simon Gonzalez
# email: s.gonzalez@griffith.edu.au

#beginning of form----------------------------------------
form Change Labels
	# Object number of the first TextGrid
		positive Initial_TextGrid_number 1
	# Object number of the last TextGrid
		positive Final_TextGrid_number 1
	# -----NOTE: If only one TextGrid is specified for label change,...
	# -----		 the number of the initial TextGrid Must be the same as the final TextGrid.

	# specifies the number of tier in which labels must be changed
		positive Tier_number 1

	# selects the group of labels to be counted
	# the option ALL selects all labels in the TextGrid
	# the option Specify selects only the labels entered
		optionmenu Labels 1
			option ALL
			option Specify

		comment If Labels = ALL, the labels entered in Exclude/Specify will be excluded
		comment If Labels = Specify, only the labels entered will be included

		sentence exclude_OR_specify

	# By default, the table created will show the average values per label
	# the information will include:
	#		The count of labels
	#		The frequency count of each label in relation to all labels selected in the TextGrid
	#		The average duration per label
	#		The average duration proportion of each label in relation to all labels selected in the TextGrid
	#------------
	# if single_counts is selected, the table created will show information for each label token individually
	# the information will include:
	#		initial location: the time information of the location of the onset boundary
	#		final location: the time information of the location of the offset boundary
	#		duration: label duration
	#		preceding label: label in the preceding interval
	#		following label: label in the followinginterval
		boolean Single_counts 1

	#user can choose saving table as a .txt file or a .csv file
		choice Format: 1
       		button txt
       		button csv

    # if multiple textgrids are selected, all tables will be collapsed in one single file
		boolean Collapse 1
endform
#end of form----------------------------------------------

#creates a folder to store the tables. The folder is created in the same location of the script
system_nocheck mkdir table_counts					

# initiates the value for storing values in the collapsed file
collapse_files = 0

# captures all requested labels and stores them in a single array************************************
#****************************************************************************************************
#****************************************************************************************************
for i from initial_TextGrid_number to final_TextGrid_number
	#selects the iterated textgrid
	selectObject: i
	#get number of intervals
	number_of_intervals = Get number of intervals... tier_number

	# name of textgrid selected
	textGrid_name$ = selected$ ("TextGrid")

	# initiates a string variable for storing labels in the loop
	exist_label$ = ""
	# counter for the labels
	label_store_cntr = 1

		#checks labels in all intervals
	for j from 1 to number_of_intervals
		#get label of interval
		temporal_interval$ = Get label of interval... tier_number j

		# continues if the interval is different from an empty interval
		if temporal_interval$ != ""

			# if ALL labels in the textGrid are selected
			if labels = 1
				# index will be positive if the temporal label matches one in the excluded label string
				exclude_index = index(exclude_OR_specify$, temporal_interval$)

				# continues if the label is not in the excluded label string
				if exclude_index = 0
					# gives information whether the label has already been stored or not
					exist_label = index(exist_label$, temporal_interval$)

					# if the label has been stored, the index is larger than 0
					if exist_label = 0
						# if it is a new label, it is added to the string
						exist_label$ = exist_label$ + " " + temporal_interval$

						# stores the label in the label array
						label_store$[label_store_cntr] = temporal_interval$
						# stores the number of tokens for this label
						label_store[label_store_cntr] = Count labels: tier_number, temporal_interval$
						label_store_cntr = label_store_cntr + 1
					endif

				endif
			else
				# if the user Specifies the labels
				# checks if the temporal label matches one in the specify list
				specify_index = index(exclude_OR_specify$, temporal_interval$)

					# if the temporal label matches the specify labels
					if specify_index != 0
						# if it is a new label, it is added to the string
						exist_label = index(exist_label$, temporal_interval$)

						# if the label has been stored, the index is larger than 0
						if exist_label = 0
							# if it is a new label, it is added to the string
							exist_label$ = exist_label$ + " " + temporal_interval$

							# stores the label in the label array
							label_store$[label_store_cntr] = temporal_interval$
							# stores the number of tokens for this label
							label_store[label_store_cntr] = Count labels: tier_number, temporal_interval$
							label_store_cntr = label_store_cntr + 1
						endif

					endif
			endif

		endif

	endfor

#****************************************************************************************************
#****************************************************************************************************
	# stores the number of unique labels in the TextGrid
	number_of_unique_labels = label_store_cntr - 1

	# if there are labels matching the labels requested
	if number_of_unique_labels > 0
		# saves indididual labels
		if single_counts = 1

			# counter for the number of tokens to be added to the table
			label_store_cntr_save = 1

			for j from 1 to number_of_intervals
					#get label of interval
					temporal_interval$ = Get label of interval... tier_number j

					# continues if the interval is different from an empty interval
					if temporal_interval$ != ""
						# gives information whether the label has already been stored or not
						exist_label = index(exist_label$, temporal_interval$)

						# if the label has been stored, the index is larger than 0
						if exist_label != 0
							# if it is the first time a label is to be stored
							if label_store_cntr_save = 1
								# creates the table based on the format requested
								if format = 1
									full_name_table_single$ = "table_counts/" + textGrid_name$ + "_single.txt"
								else
									full_name_table_single$ = "table_counts/" + textGrid_name$ + "_single.csv"
								endif

								# if all tables are to be saved in one single table
								if collapse = 1
									if i = initial_TextGrid_number
										if format = 1
											full_name_table_single_collapse$ = "table_counts/all_tables_single.txt"
										else
											full_name_table_single_collapse$ = "table_counts/all_tables_single.csv"
										endif

										collapse_files = 1

										# header line for the collapse table
										writeFileLine: full_name_table_single_collapse$, "textGrid" + tab$ + "label" + tab$ + "start" + tab$ + "end" + tab$ + "duration" + tab$ + "preceding" + tab$ + "following"
											
									endif
								endif

								# header line for single tables
								writeFileLine: full_name_table_single$, "textGrid" + tab$ + "label" + tab$ + "start" + tab$ + "end" + tab$ + "duration" + tab$ + "preceding" + tab$ + "following"
							endif

							# gets the start time, end time and duration of single labels
							start_time = Get start point... tier_number j
							end_time = Get end point... tier_number j
							label_duration = end_time - start_time

							if j > 1
								preceding_label$ = Get label of interval... tier_number j-1
							else
								preceding_label$ = ""
							endif

							if j < number_of_intervals
								following_label$ = Get label of interval... tier_number j+1
							else
								following_label$ = ""
							endif

							# appends line to single table
							appendFileLine: full_name_table_single$, textGrid_name$ + tab$ + temporal_interval$ + tab$ + string$(start_time) + tab$ + string$(end_time) + tab$ + fixed$(label_duration*1000,2) + tab$ + preceding_label$ + tab$ + following_label$

							if collapse_files = 1
								# appends line to collapse table
								appendFileLine: full_name_table_single_collapse$, textGrid_name$ + tab$ + temporal_interval$ + tab$ + string$(start_time) + tab$ + string$(end_time) + tab$ + fixed$(label_duration*1000,2) + tab$ + preceding_label$ + tab$ + following_label$
							endif

							label_store_cntr_save = label_store_cntr_save + 1
											
						endif
					endif
			endfor
		endif
	endif

#****************************************************************************************************
#****************************************************************************************************
# exports values as total counts per label
# if there are labels matching the labels requested
	if number_of_unique_labels > 0
		#total number of unique labels
		total_number_of_labels = 0
		for j from 1 to number_of_unique_labels
			total_number_of_labels = total_number_of_labels + label_store[j]
		endfor

		#frequency count per label
		for j from 1 to number_of_unique_labels
			average_count[j] = ( label_store[j] * 100 ) / total_number_of_labels
		endfor

		#duration
		#average duration per unique label
		# temporal sum
		total_duration_sum = 0
		for j from 1 to number_of_unique_labels
			durations_cntr = 1
			duration_sum = 0
			for k from 1 to number_of_intervals
				temporal_interval$ = Get label of interval... tier_number k
				if temporal_interval$ = label_store$[j]
					# initial time of interval
					initial_time = Get start point... tier_number k
					#end time of interval
					final_time = Get end point... tier_number k
					# label duration
					duration = final_time - initial_time
					# sum of durations
					duration_sum = duration_sum + duration
					# stores the counter for calculating average durations
					durations_cntr = durations_cntr + 1
				endif
			endfor

			# stores the total duration for all labels
			total_duration_sum = total_duration_sum + duration_sum
			# stores the total duration per unique labels
			duration_sum_labels[j] = duration_sum
			# average duration per label
			average_duration[j] = duration_sum/(durations_cntr-1)

		endfor

		#proportional duration
		for j from 1 to number_of_unique_labels
			proportional_duration[j] = (duration_sum_labels[j] * 100) / total_duration_sum
		endfor

		#exports the information into a table
			if format = 1
				full_name_table_total$ = "table_counts/" + textGrid_name$ + "_total.txt"
			else
				full_name_table_total$ = "table_counts/" + textGrid_name$ + "_total.csv"
			endif

			# exports tables to a single file
			if collapse = 1 and i = initial_TextGrid_number

				if format = 1
					full_name_table_total_collapse$ = "table_counts/all_tables_total.txt"
				else
					full_name_table_total_collapse$ = "table_counts/all_tables_total.csv"
				endif

				writeFileLine: full_name_table_total_collapse$, "textGrid" + tab$ + "label" + tab$ + "count" + tab$ + "frequency(%)" + tab$ + "average_duration(ms)" + tab$ + "proportional_duration(%)"
			endif

			writeFileLine: full_name_table_total$, "textGrid" + tab$ + "label" + tab$ + "count" + tab$ + "frequency(%)" + tab$ + "average_duration(ms)" + tab$ + "proportional_duration(%)"

			for j from 1 to number_of_unique_labels
				appendFileLine: full_name_table_total$, textGrid_name$ + tab$ + label_store$[j] + tab$ + string$(label_store[j]) + tab$ + fixed$(average_count[j], 2) + tab$ + fixed$(average_duration[j]*1000,2) + tab$ + fixed$(proportional_duration[j],2)
			
				if collapse = 1
				  appendFileLine: full_name_table_total_collapse$, textGrid_name$ + tab$ + label_store$[j] + tab$ + string$(label_store[j]) + tab$ + fixed$(average_count[j], 2) + tab$ + fixed$(average_duration[j]*1000,2) + tab$ + fixed$(proportional_duration[j],2)
				endif
			endfor
	endif
endfor