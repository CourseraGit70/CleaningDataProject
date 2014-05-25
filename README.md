##To succesfully reproduce the tidy data set ensure the following:

* View the instructions in raw form on github
* R version 3.1.0 on Ubuntu 13.10 with Rstudio should be used. This is the only set up with repeat verification.
* The reshape2 package is installed and loaded.
* The data.frame package is installed and loaded.
* Obtain the UCI har dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* The data file is unzipped.
* The file structure is ordered alphabetically
* run_analysis.R is saved in the UCI har directory
* The working directory is set to the UCI har directory
* The system has read, write, and execute permissions in the directory.

##run_analysis.R summary

  The file run_analysis.R contains a single function, start_analysis. It takes no parameters, but requires the above set up to run correctly. Upon execution, it will create lists of the files in the main directory, and in the test and train directories. It will select the appropriate files from these lists, and combine them. First it will combine the subject files from test and train, then the x_ files from test and train, then the y_ files from test and train. Next it will combine the 3 new datasets into a single dataset for processing.
  The first processing is to determine the subset of variables pertaining to the mean and standard deviation. It searches for any variable labelled with "mean" or "std", and subsets the index where they are found. Next, it cleans the selected variables' names. It removes all non English characters, whitespace, and sets everything to lowercase, as indicated in the lecture. Next it takes these new tidy names and inserts them into the data frame as appropriate. 
  After this the data is reshaped. First it is melted by subjectnumber and activity number, to create a long dataset where each unique activity done by each subject has their data from each variable. Next the values are converted to a numeric type, and it is casted. The cast is done in such a way as to retain the above sorting, while moving the variables into a much more friendly wide format. During the cast the mean of each group of variables is taken.
  Finally, a row is inserted and filled with English descriptions of the activities, to supplement their numeric indicators. This is done last to avoid subsetting the data or applying the mean function to non numeric values.
