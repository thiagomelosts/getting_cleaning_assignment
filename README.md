# Getting and Cleaning Data Course Project
This repository contains the files for the Getting and Cleaning Data Course assignment.
Author: Thiago Melo

## Files
This repository has 3 files:
- README.md: description of the repo and the scrip on the run_analysis.R file
- run_analysis.R: a R script file used for getting and cleaning a data set from UCI Machine Learning Repository
- codebook.pdf: a pdf file describing the variables on the tidy data set

## Initial assumptions
In order for the script to work, it is assumed that all the necessary text files are directly on R current working directory. Those files are:
- X_test.txt
- Y_test.txt
- subject_test.txt
- X_train.txt
- Y_train.txt
- subject_train.txt
- features.txt
- activity_labels.txt

## The script file
The assignment has 5 itens or steps to be completed, that will produce one tidy data set. In order to achieve this goal, assumptions and choices had to be made and they are presented as follows:
### Item 1: merging the data sets
After reading all the tables from the txt files and the descriptions provided with the files, one can see that "test_x" and "train_x" have the 561 features measured in vectors represented by each row. The name of each feature can be found on the second column of the "features" object, therefore they can be assigned as the column names for both objects.
The "test_y" and "train_y" have the activity performed by the subject for each measurement (or row), so we can bind them as columns to "test_x" and "train_x" as a new "activity" column. The same thing can be done for the "test_subject" and "train_subject" objects, binding a new "subject" column to the data sets.
Finally, we can bind "test_x" and "train_x" as one "data" object.
### Item 2: extract means and standard deviations
Some of the 561 features represent means and standard deviations of measurements from the real experiment. In order to select those, one string search was performed using regular expressions and looking for any instances with the characters "mean" and "std" followed by visual inspection of the result. By choosing to look for lower case only, the search will include "mean()" and "meanFreq()", but exclude cases of "angle()" such as "angle(tBodyAccMean,gravity)". The "features_info.txt" file describes both "mean()" and "meanFreq()" as average values. On the other hand, "angle" receives "Additional vectors obtained by averaging the signals in a signal window sample", but is not an average value itself.
### Item 3: replace activity labels
The "activity_labels" has string labels that can replace the numeric ones used for describing the activity performed on each measurement. Many methods could have been used to replace the numeric labels, such as using the "merge" function. I choose a for loop that reads each row on the "activity" column, finds the corresponding character label and does the replacement. This choice was done ir order to preserve the observations assortment; something that the "merge" function would not do.
### Item 4: descriptive variable names
All the columns in the "data" object already have descriptive names, which were assigned on lines 17, 18, 25, 26, 33 and 34 of the script.
### Item 5: new data set with means of each variable for each subject and activity
In order to calculate the average value of each variable for each subject and activity, one can use a combination of the "split", "lapply" and "colMeans" functions:
- "split" will split de data set into a list of tables for each observed combination of subject and activity
- "lapply" will apply the "colMeans" function on each table on the list created by "split"
- the resulting list can be converted into a data frame and the columns "activity" and "subject" created from the row names in the data frame.
Finally, we can create a "means.txt" file to be submited. It can be read with the following line of code:
means <- read.table("means.txt", header = TRUE)

## Is the final table a tidy data set?
According to the Tidy Data article from Hadley Wickham, "In tidy data:
1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table."
One could think of two choises here for a tidy data set:
- A wide table with 88 columns: "subject", "activity" and all the other measured variables, such as "tBodyAcc-mean()-X"
- A narrow table with 4 columns: "subject", "activity", "variable" and "mean"
One could argue that the "mean" is a variable, not an observation and should therefore be store on a column, not a row, as in the second option. The problem is that this would lead to all the other variables being stored on a single column, violating the second principle of a tidy data set. If we use the first approach, we could think of the mean as a type of observational unit, so it should be stored in a table, not a column.
In conclusion, the "means.txt" has a tidy data set because each variable forms a column, each observation (or combination of subject and activity) forms a row and the only type of observational unit (the mean) forms a table.

## Sources:
Special thanks for David Hood and his toughtful article about this particular assignment:
https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
Also, Hadley Wickham and his article entitled Tidy Data:
https://www.jstatsoft.org/article/view/v059i10/v59i10.pdf
