# General Information
This script is distributed under the GNU General Public License.

Copyright 15.06.2016 Simon Gonzalez

email: s.gonzalez@griffith.edu.au

# count_textgrid_labels
Count TextGrid labels in Praat

This script calculates the number of labels in a TextGrid or multiple TextGrids.
If multiple TextGrid selection is speficied, the textgrids MUST be in contiguous numbers in the object window.
Besides counting labels, the scrip also gives temporal information:
frequency, duration, average duration and start and end time for intervals.
User selects either counting all labels in the TextGrid or specific labels.

The script works for single and multiple TextGrid selection.
If multiple TextGrid selection is speficied, the textgrids MUST be in contiguous numbers in the object window.

# Example
## Count all labels in a TextGrid selection or single TextGrid

As a user, I want to count all available labels in tier 3 for a selection of TextGrids in Praat Object Window.

The tier number with the labels to be counted MUST be the same number location for all TextGrids. 
In this case, the script will count labels only on the tier 3 across all TextGrids.

## Count specific labels in a TextGrid selection or single TextGrid

As a user, I want to count only an array of labels in tier 3 for a selection of TextGrids in Praat Object Window.
Labels not included in the array will not ne counted.

# Parameters

The parameters provided in the UI window are as follows:

1 Initial TextGrid number: the number of the first TextGrid in the object window.

2 Final TextGrid number: the number of the last TextGrid in the object window.

3 Tier number: the number of the tier in which labels will be counted.

4 Labels:

ALL: Selects all labels in the specified tier

Specify: User specifies ONLY the labels to be counted

5 exclude OR specify
If the user selects ALL labels, the labels entered in this field will be excluded in the counting.

If the user selects Specify, ONLY the labels entered in this field will be counted.

6 Single counts (Boolean): by default, the script exports the average values per label. These values are:

	Count: number of tokens per label
	Frequency: the frequency for each label
	Average duration: the average duration per label
	Duration proportion: the average duration proportion of each label in relation to all labels selected in the TextGrid.

7 Format:
.txt: Table exported as a text file.
.csv: Table exported as a csv file.

8 Collapse (Boolean): by default, the script exports individual tables for each TextGrid selected.
If multiple textgrids are selected, all tables will be collapsed in one single file.


