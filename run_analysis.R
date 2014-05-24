start_analysis <- function(){
  test_file_list <- list.files("test", full.names = TRUE)                                 #gets the list of test files to merge
  train_file_list <- list.files("train", full.names = TRUE)                               #list of train filles to merge
  main_file_list <- list.files(full.names= TRUE)                                          #list of non data files to merge
  features <- read.table(main_file_list[3])                                               #loads the variable names
  subjectmerge <- rbind(read.table(test_file_list[2]), read.table(train_file_list[2]))    #combines subject numbers                                                   #initializes
  xmerge <- rbind(read.table(test_file_list[3]), read.table(train_file_list[3]))          #combines the dara files
  ymerge <- rbind(read.table(test_file_list[4]), read.table(train_file_list[4]))          #combines the activity numbers
  dataset <- cbind(xmerge,subjectmerge,ymerge)                                            #merges everything into 1 data frame
  featureindex <- grep("std|mean",features[,2],)                                          #searches for all measures of mean and std
  tidy <- dataset[,c(featureindex,562,563)]                                               #subsets the data to just those values

  colheaders <- features[featureindex,2]                #subsets the variable names file to just the subsetted columns
  colheaders <- tolower(colheaders)                     #standardizes the names in lowercase
  colheaders <- gsub("\\(","",colheaders)               #removes all (
  colheaders <- gsub("\\)","",colheaders)               #removes all )
  colheaders <- gsub("-","",colheaders)                 #removes all -
  
  for( j in 1:79){                                      #inserts the variable names into the data frame
    colnames(tidy)[j] <- colheaders[j] 
  }
  colnames(tidy)[80] <- "subjectnumber"                 #adds in the additional merged column headers
  colnames(tidy)[81] <- "activitynumber"
  
  meltedtidy <- melt(tidy, id.vars = c("subjectnumber", "activitynumber"))   #melts the data
  meltedtidy[,4] <- as.numeric(meltedtidy[,4])                               #convets factor to numeric
  castedtidy <- dcast(meltedtidy, subjectnumber + activitynumber ~ variable, fun.aggregate = mean, value.var = "value")  #casts the data by activity and subject, averages the results with mean
  
  #here I decided to keep the column number as well as the english name, the numbers seemed easier to work with
  tidyrows <- nrow(castedtidy)                                                      #gets number of rows
  rowlabel <- data.frame(activityname = tidyrows)                                   #creates a column for inserting
  castedtidy <- cbind(castedtidy[,1], rowlabel, castedtidy[,2:ncol(castedtidy)])    #inserts the column
  colnames(castedtidy)[1] <- "subjectnumber"                                        #labels the column
  #moved step 2 here so that dcast could run without generating NAs or being subsetted
  for(i in 1:tidyrows) {                                                #replace default column value with english names
    current <- castedtidy[i,3]
    if(current == 1) castedtidy[i,2] <- "walking"
    else if (current == 2) castedtidy[i,2] <- "walkingupstairs"
    else if(current == 3) castedtidy[i,2] <- "walkingdownstairs"
    else if(current == 4) castedtidy[i,2] <- "sitting"
    else if(current == 5) castedtidy[i,2] <- "standing"
    else if(current == 6) castedtidy[i,2] <- "laying"
  }
  

}