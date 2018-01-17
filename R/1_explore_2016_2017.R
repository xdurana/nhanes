library(dplyr)
library(data.table)
library(SASxport)

demographics <- read.xport('input/2015-2016/DEMO_I.XPT')
medical_conditions <- read.xport('input/2015-2016/MCQ_I.XPT')
diabetes <- read.xport('input/2015-2016/DIQ_I.XPT')
