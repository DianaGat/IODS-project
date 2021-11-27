# Diana Hilleshein
# 27.11.2021

# creating a path
create_human.R <- c("C:/R scripts/IODS-project")
setwd(create_human.R)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gi <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd) #196 observations and 8 variables
str(gi) #195 observations and 10 variables

summary(hd)
summary(gi)
#rename columns. I rename a majority of them since in RStudio they got dots instead of spaces and it looks ugly
names(hd)[3] <- "HDI"
names(hd)[4] <- "Life_expect(e0)"
names(hd)[5] <- "Expect_edu"
names(hd)[6] <- "Mean_edu"
names(hd)[7] <- "GNI_PC"
names(hd)[8] <- "GNI_PC-HDI_rank"

#Not sure how else it can be shorter, but understandable at the same time
names(gi)[3] <- "GII"
names(gi)[4] <- "MatrMortality_rt"
names(gi)[5] <- "AdoBirth_rt"
names(gi)[6] <- "ReprParl"
names(gi)[7] <- "Sec_edu.F"
names(gi)[8] <- "Sec_edu.M"
names(gi)[9] <- "LabForceRt.F"
names(gi)[10] <- "LabForceRt.M"

#get rid of chr
# access the stringr package
library(stringr)

# look at the structure of the GNI column
str(hd$GNI_PC)

# remove the commas from GNI and print out a numeric version of it
str_replace(hd$GNI_PC, pattern=",", replace ="") %>% as.numeric

#mutations
library(dplyr); library(ggplot2)
gi <- mutate(gi, Edu2.FM = (Sec_edu.F + Sec_edu.M)/2)
colnames(gi) #worked

gi <- mutate(gi, LabForce.FM = (LabForceRt.F + LabForceRt.M)/2)
colnames(gi) #worked

#get rid of NA
# columns to keep
#keep <- c("Country", "Edu2.FM", "LabForce.FM", "Life_expect(e0)", "Expect_edu", "GNI_PC", "MatrMortality_rt", "AdoBirth_rt", "ReprParl")

# select the 'keep' columns
#hd_sel <- select(hd, one_of(keep))

# print out a completeness indicator of the data
complete.cases(hd)

# print out the data along with a completeness indicator as the last column
data.frame(hd[-1], comp = complete.cases(hd))

# filter out all rows with NA values
clean.hd <- filter(hd, complete.cases(hd))

# print out a completeness indicator of the data
complete.cases(gi)

# print out the data along with a completeness indicator as the last column
data.frame(gi[-1], comp = complete.cases(gi))

# filter out all rows with NA values
clean.gi <- filter(gi, complete.cases(gi))

#joining
# common columns to use as identifiers
join_by <- "Country"
human <- inner_join(clean.data, gi, by = join_by, suffix = c(".hd", ".gi"))

str(human) #195 observations and 19 variables/work as intended
write.csv(human, file = "C:/R scripts/IODS-project/data/create_human.csv")