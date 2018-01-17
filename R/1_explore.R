library(dplyr)
library(data.table)
library(corrplot)
library(SASxport)

medications <- fread('input/2013-2014/medications.csv')
medications_information <- read.xport('input/2013-2014/RXQ_DRUG.xpt')

demographic <- fread('input/2013-2014/demographic.csv')
labs <- fread('input/2013-2014/labs.csv')

demographic <- demographic %>%
  select(
    SEQN,
    RIAGENDR, #gender
    RIDAGEYR, #age
    RIDEXPRG, #pregnancy status
    DMDMARTL  #marital status
  )

diabetes <- medications %>%
  mutate(
    is_diabetic = ifelse(RXDRSC1 == 'E11', 1, 0)
  ) %>%
  select(
    SEQN,
    is_diabetic
  ) %>%
  unique() %>%
  left_join(labs)

library(randomForest)

medications <- medications %>%
  filter(
    RXDDRGID != ''
  )

augmented.medications <- medications %>%
  left_join(demographic) %>%
  left_join(labs)

augmented.medications %>%
  filter(
    RIAGENDR == 2
  ) %>%
  group_by(
    RXDDRUG,
    RXDRSD1
  ) %>%
  summarize(count = n()) %>%
  arrange(desc(count))
