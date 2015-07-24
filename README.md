# Getting-and-Cleaning-Data-Course-Project

Author:  Kasia Wilson     Date: 7/23/15

This project is designed to take the raw data from the "Human Activity Recognition Using Smartphones" study, available in the UCI Machine Learning Repository, cleaning and tidying it, and generating a second tidy dataset called tidydata.txt.  

The R script run_analysis.r downloads the data zip file from the repository into a temporary directory, and unzips it to temporary files.  The original raw data was separated into multiple files, with variable names, subject ID codes, activity codes and measurements all stored separately.  The script takes all of these separate files and re-combines them according to the principles of tidy data, so that:
      1.  Each variable measured forms one column
      2.  Each different observation of each variable forms a different row
      3.  There is a row of human-readable variable names at the top
      
The columns containing measurements of mean and standard deviation were identified and extracted from the raw data files, then combined for both the test and train groups into one dataframe, new columns were added to indicate the subject ID, group and activity code, then the mean of the measurements for each variable for each participant and activity were calculated and written to a new datafile, tidydata.txt.  The script includes remarks on each step to illustrate what is occurring.  I have chosen to retain the original variable names for the actual measurements, as I do not have the background to interpret and rename these measurements in a more reabable but still accurate way.
  
  The included codebook describes all variables used in tidydata.txt.
  
  Original datasource:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  packages required:  dplyr and reshape2
  
