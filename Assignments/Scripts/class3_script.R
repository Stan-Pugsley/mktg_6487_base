########################################### 
### Class 3
########################################### 

# The primary goal of this script is to prepare you with code and
# concepts, using the Megatelco case as an example, for completing 
# the  project for this module (which is presented as a Canvas quiz).

# Plan to do your project coding using the provided RMarkdown template.

########################################### 
# Megatelco Data Dictionary
########################################### 

# DEMOGRAPHIC VARIABLES:
# College - has the customer attended some college (one, zero)
# Income - annual income of customer
# House - estimated price of the customer's home (if applicable)

# USAGE VARIABLES:
# Data Overage Mb - Average number of megabytes that the customer used in excess of the plan limit (over last 12 months)
# Data Leftover Mb - Average number of megabytes that the customer use was below the plan limit (over last 12 months)
# Data Mb Used - Average number of megabytes used per month (over last 12 months)
# Text Message Count - Average number of texts per month (over last 12 months)
# Over 15 Minute Calls Per Month - Average number of calls over 15 minutes in duration per month (over last 12 months)
# Average Call Duration- Average call duration (over last 12 months)

#PHONE VARIABLES:
# Operating System - Current operating system of phone
# Handset Price - Retail price of the phone used by the customer

#ATTITUDINAL VARIABLES:
# Reported Satisfaction - Survey response to "How satisfied are you with your current phone plan?" (high, med, low)
# Reported Usage Level - Survey response to "How much do your use your phone?" (high, med, low)
# Considering Change of Plan - Survey response to "Are you currently planning to change companies when your contract expires?" (high, med, low)

#OTHER VARIABLES
# Leave - Did this customer churn with the last contract expiration? (LEAVE, STAY)
# ID - Customer identifier

###########################################  
### Complete this module's RMarkdown assignment
########################################### 

# 1. Click document icon in upper left and select "R Markdown"
# 2. The file that comes up is a template that you can adapt for the assignment
# 3. Your (adapted) file should include:
#     - A title of your choosing.
#     - An author (your name).
#     - A main heading (created with 1 hashtag), a subheading (created with 2 hashtags), and some text.
#     - A plot with the code for the plot revealed (set "echo = TRUE" in the header of the code chunk).
#     - A table with the code for the table revealed (set "echo = TRUE" in the header of the code chunk).
# 4. Clear your environment in RStudio
# 5. Run each code chunk in sequence from the top to check for errors.
# 6. If there are no errors, then knit the document to HTML (or PDF or Word) using the "knit" button in the
#    upper left.
# 7. Submit the knitted document at Canvas (browse for the document in your working directory).


########################################### 
### Needed skills for the project 
########################################### 

# Here is what you need to be able to do for the AdviseInvest project:

# 1. Identify the target variable for an analysis based on the business problem.
# 2. Decide which non-binary variables should be recoded as factors, and recode
#    them.
# 3. Clean the dataset by removing NAs and mistaken values.
# 4. Compute the mean of a binary variable.
# 5. Use ggplot2 to plot a numeric (or count) variable against a categorical 
#    variable.
# 6. Calculate a count (and a proportion) for a categorical variable 
#    using dplyr and pipe the result into a plot.

########################################### 
### Load Packages
########################################### 

library(tidyverse) # Remember: must always load packages at the beginning of a session!

########################################### 
### Import data 
########################################### 

m <- read_csv(file = "https://raw.githubusercontent.com/Stan-Pugsley/mktg_6487_base/main/Assignments/DataSets/megatelco.csv")


########################################### 
### Inspect
########################################### 

glimpse(m) # Which should be factors?
summary(m)

# Issues: 

# 1. College has values of  `zero` and `one.`  We will change these to "no" and
#    "yes," since there are only two values, and spelling out the numbers is weird.
# 2. Turn college into a factor variable.
# 3. Remove negative values of `income` and `house`. 
# 4. Remove absurdly large value of `handset_price`.
# 5. Remove rows with missing values (`NA`) in `over_15mins_calls_per_month`.
#    Dealing with missing values is sometimes a complicated problem.  In this case,
#    because the number of missing values is small relative to the size of the
#    dataset, it is fine to solve the problem by removing rows.
# 6. If our objective was modeling we would want to remove ID because it is
#    obviously not a useful predictor of churn. For now we can leave ID in the data
#    set.

########################################### 
### Clean dataset
########################################### 

# Notes:
# 1. dplyr verbs: mutate(), filter(), and below we use summarize() also.
#    - mutate(): creates a new column.
#    - filter(): removes rows based on logical conditions.
#    - summarize():  creates a smaller summary table.
# 2. factor(). The default setting is to create alphabetic factor levels for character variables.
# 3. ifelse() is a handy function for recoding, identical to Excel's "if" function.

m_clean <- m |> # create a new named dataset for clarity
  mutate(leave = factor(leave), # let the levels be assigned alphabetically
         college = ifelse(college=="one", "yes", "no"),
         college = factor(college)) |> 
  filter(income > 0,
         house > 0,
         handset_price < 1500) |> 
  na.omit () # This is a quick way of removing all the NAs in a data set.

# Check whether the operation was successful
summary(m_clean)

########################################### 
### Identify target
########################################### 

# The target variable for a model of churn will be LEAVE.
# The target is the data representation of the phenomenon we are interested in 
# understanding/modeling.

########################################### 
### Compute the mean of a binary 0/1 variable
########################################### 

(example1 <- c(0,0,0,0,0,1,1,1,1,1))
mean(example1) # Here the mean is the proportion of 1s

# Example using ifelse() with a factor variable.
# Note: we will pick out columns using the "$" notation.

ifelse(m_clean$leave=="LEAVE", 1, 0) |> 
  mean()

#################################################
### Explore variable relationships: leave ~ house
#################################################

# Are wealthier customers more likely to churn?
# What is the relationship between leave and house price?
# Note: Leave is binary (which we recoded as a factor), house price is numeric, 
# so an appropriate plot is a boxplot.

ggplot(data = m_clean, aes(x = leave, y = house)) +
  geom_boxplot() +
  labs(title = "leave ~ house")

# Are there other possibilities?  Yes, but none as informative:
  
ggplot(m_clean, aes(leave, house)) +
  geom_point() + 
  labs(title = "leave ~ house")

m_clean |> 
  group_by(leave) |> 
  summarize(avg_house_price = mean(house)) |> # do some data manipulation and pipe to viz
  ggplot(aes(leave, avg_house_price)) +
  geom_col() +
  labs(title = "leave ~ house")

# Sidebar:  what is the frequency distribution of the house variable?

ggplot(m_clean, aes(x = house)) +
  geom_histogram() + 
  labs(title = "Distribution of house")

# What is the best measure of central tendency?  Mean or median?

mean(m_clean$house)
median(m_clean$house)

#################################################################
### Explore variable relationships: leave ~ college
#################################################################

# Both variables are categorical. 

# First, what does NOT work:
m_clean |> 
  ggplot(aes(x = leave, y = college)) +
  geom_boxplot() +
  labs(title = "leave ~ college")

# This does not work because boxplots are designed for categorical vs. continuous,
# not categorical vs. categorical.

# Instead, we will calculate the proportion of leavers at each level of college  
# This allows us to see whether customer departure depends on, or is related 
# to, college.

# 1. Create a summary table of counts:
m_clean |> 
  count(leave, college) 

# Notice that I'm not saving this table but  printing it to the console.

# count() automatically creates a new column, n, with the counts for 
# each unique combination of leave and college

# 2. Pipe new table into ggplot for viz
m_clean |> 
  count(leave, college) |> 
  ggplot(aes(x = college, y = n, fill = leave)) +
  geom_col() +
  labs(title = "counts of leave by college")

# Hard to interpret!  Why?

# Let's "dodge" the bars.

m_clean |> 
  count(leave, college) |> 
  ggplot(aes(x = college, y = n, fill = leave)) +
  geom_col(position = "dodge") +
  labs(title = "counts of leave by college")

########################################### 
### Optional!
########################################### 

# An even better (more informative) plot than the one above would calculate the 
# proportion of leave and stay at each level of college.

# Warning: this type of plot is quite a bit more complicated and involved. Only for
# the stout-hearted!

# Base table
m_clean |> 
  count(college, leave) 

# Add proportion to the table
m_clean |> 
  count(college, leave) |> 
  group_by(college) |> 
  mutate(proportion = n / sum(n))

# Pipe this table into ggplot using geom_col with dodged bars.
m_clean |> 
  count(college, leave) |> 
  group_by(college) |> 
  mutate(proportion = n / sum(n)) |> 
  ggplot(aes(college, proportion, fill = leave)) + 
  geom_col(position = "dodge") +
  labs(title = "Proportion of leave by college") 

# This is pretty close to the plot with counts, in this case.  When counts are really
# different between categories putting proportions on the y-axis tends to work better.

# What story does this plot tell?
