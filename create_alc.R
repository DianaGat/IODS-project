# Diana Hilleshein
# 17.11.2021
# I will perform and interpret logistic regression analysis
# Data siurse: UCI: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# creating a path
create_alc.R <- c("C:/R scripts/IODS-project/week 3/data")
setwd(create_alc.R)


# reading two datasets from the folder
math <- read.table("student-mat.csv", header =  T, sep = ";")
por <- read.table("student-por.csv", header =  T, sep = ";")

colnames(math)
str(math) 
dim(math) # math table has 33 variables and 395 observations

colnames(por)
str(por) 
dim(por) # por table has 33 variables and 649 observations

# Define own id for both datasets
library(dplyr)
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

# columns that are not used in joining
pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
pormath <- por_id %>% 
  bind_rows(math_id) %>%
str(pormath) # checking if there are 370 students as was required. Looks good
dim(pormath) # 370 obseravtions and 51 variable

  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
    
  # Remove lines that do not have exactly one obs from both datasets
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  

# define a new column alc_use by combining weekday and weekend alcohol use
pormath <- mutate(alc, alc_use = (Dalc + Walc) / 2)
# define a new logical column 'high_use'
pormath <- mutate(alc, high_use = alc_use > 2)
glimpse(pormath) # alc_use and high_use are added
str(pormath) # 370 obseravtions and 51 variable

# Save created data to folder 'data' as an Excel worksheet
write.csv(pormath,file="C:/R scripts/IODS-project/week 3/data/pormath.csv")


#
#

#
#
#
#
