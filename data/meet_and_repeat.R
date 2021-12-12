# Diana Hilleshein

# creating a path
meet_and_repeat.R <- c("C:/R scripts/IODS-project//data")
setwd(meet_and_repeat.R)

#loading data
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = "", header=TRUE)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "", header=TRUE)

names(bprs)
names(rats)

str(bprs) # 40 obs., 11 variables
str(rats) # 16 obs., 13 variables

summary(bprs)
summary(rats)

library(dplyr)
library(tidyr)
library(ggplot2)

#Categorical variables to factors:
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)

rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

#Converting to long form:
bprl_long <-  bprs %>% gather(key = weeks, value = bprs, -treatment, -subject)
rats_long <- rats %>% gather (key = WD, value = measurement, -ID, -Group)
#Making new column "week" and "Time"
bprl_long <-  bprl_long %>% mutate(week = as.integer(substr(weeks,5,5)))
rats_long <- rats_long %>% mutate (Time = as.integer(substr(WD,3,4)))
glimpse(bprl_long) #worked!
glimpse(rats_long) #worked, too!

#Taking a serious look
names(bprl_long) #"treatment" "subject"   "weeks"     "bprs"      "week"  
str(bprl_long) #treatmen/subject are factors; week is chr; bprs/week are integers
summary(bprl_long)

names(rats_long) #"ID"          "Group"       "WD"          "measurement" "Time"   
str(rats_long) # ID/Group are factors; WD is chr; measurment and Time are integers
summary(rats_long)

#Saving the data in its wrangled form:
write.table(bprl_long, file = "C:/R scripts/IODS-project/data/bprs_long.txt")
write.table(rats_long, file = "C:/R scripts/IODS-project/data/rats_long.txt")

#When there are multiple measurements of the same subject, across time or using 
#different tools, the data is often described as being in "wide" format if there
#is one observation row per subject with each measurement present as a different 
#variable and "long" format if there is one observation row per measurement 
#(thus, multiple rows per subject).