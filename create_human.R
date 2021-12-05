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
names(hd)[1] <- "hdirank"
names(hd)[3] <- "hdi"
names(hd)[4] <- "lifeexp"
names(hd)[5] <- "expeedu"
names(hd)[6] <- "meanedu"
names(hd)[7] <- "gni"
names(hd)[8] <- "gni.hdi"

#Not sure how else it can be shorter, but understandable at the same time
names(gi)[1] <- "giirank"
names(gi)[3] <- "gii"
names(gi)[4] <- "matmor"
names(gi)[5] <- "adobirth"
names(gi)[6] <- "repparl"
names(gi)[7] <- "edu2F"
names(gi)[8] <- "edu2M"
names(gi)[9] <- "labfF"
names(gi)[10] <- "labfM"

#get rid of chr
# access the stringr package
library(stringr)

# look at the structure of the GNI column
str(hd$gni)

# remove the commas from GNI and print out a numeric version of it
str_replace(hd$gni, pattern=",", replace ="") %>% as.numeric

#mutations
library(dplyr); library(ggplot2)
gi <- mutate(gi, edu2FM = (edu2F + edu2M)/2)
colnames(gi) #worked

gi <- mutate(gi, labfFM = (labfF + labfM)/2)
colnames(gi) #worked


#joining
# common columns to use as identifiers
join_by <- "Country"
human <- inner_join(hd, gi, by = join_by, suffix = c(".hd", ".gi"))

str(human) #195 observations and 19 variables/work as intended
write.csv(human, file = "C:/R scripts/IODS-project/data/create_human.csv")

#-----------------------
#week 5 wrangling

# Source of the data: http://hdr.undp.org/en/content/human-development-index-hdi
# The dataset originates from the United Nations Development Programme. 
# The data has the following variables:

# 1) hdirank = HDI ranking for countries
# 2) Country = Country name
# 3) hdi = Human Development Index (HDI)
# 4) lifeexp = Life expectancy at birth
# 5) expedu = Expected years of schooling 
# 6) meanedu = Mean years of schooling
# 7) gni  = Gross National Income (GNI) per capita
# 8) gni-hdi = GNI per capita rank minus HDI rank
# 9) giirank = GII ranking for countries
# 10) gii = Gender Inequality Index (GII)
# 11) matmor = Maternal mortality ratio
# 12) adobirth = Adolescent birth rate
# 13) repparl = Percetange of female representatives in parliament
# 14) edu2F = Proportion of females with at least secondary education
# 15) edu2M = Proportion of males with at least secondary education
# 16) labfF = Proportion of females in the labour force
# 17) labfM = Proportion of males in the labour force
# 18) edu2FM - the ratio of Female and Male populations with secondary education in each country (2eduF / 2eduM)
# 19) labfFM = the ratio of labour force participation of females and males in each country (labfF / labfM)

dim(human) #195 observations and 19 variables/work as intended
str(human)


# numercal gni
human$gni <- str_replace(human$gni, pattern = ",", replace = "") %>% as.numeric()
human$gni


# exclude unneeded variables (names are the ones tht I used in the previous ex)
keep <- c("Country", "edu2FM", "labfFM", "lifeexp", "expeedu", "gni", "matmor", "adobirth", "repparl")

# Remove all rows with missing values
# select the 'keep' columns
human <- select(human, one_of(keep))

# print out a completeness indicator of the data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(hd[-1], comp = complete.cases(hd))

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human <- filter(human, complete.cases(human))

# Remove the observations which relate to regions instead of countries
# defining last index to keep
last <- nrow(human) - 7 
# choose everything until the last 7 observations 
human <- human[c(1:last), ]

#Define the row names of the data by the country names and remove the country name column from the data. 
# add countries as rownames
rownames(human) <- human$Country

# remove the Country variable
human <- select(human, -Country)

str(human) # 155 observations and 8 variables. 

#Save the modified human data in your data folder
write.table(human, file = "C:/R scripts/IODS-project/data/human.csv")