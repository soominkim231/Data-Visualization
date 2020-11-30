## Data Visualization (GOVT16-QSS17) Fall 2017
## Work-On-Your-Own Data Visualization, Project 3
##
## Name: Soomin Kim
## Date: November 1, 2017


# Initial Settings --------------------------------------------------------

rm(list = ls())
library(ggplot2)
library(tidyverse)
library(ggrepel)
library(stringr)
options(stringsAsFactors = FALSE)

# Clean Data --------------------------------------------------------------

data1 <- "data/API_SH.XPD.TOTL.ZS_DS2_en_csv_v2.csv"
healthexp <- read.csv(data1, skip = 4) %>% 
  rename(Country = Country.Name,
         Code = Country.Code) %>% 
  select(Country, Code, X2014, X2008, X2002, X1996) %>% 
  na.omit()

data2 <- "data/Metadata_Country_API_SH.XPD.TOTL.ZS_DS2_en_csv_v2.csv"
incomegrp <- read.csv(data2) %>% 
  rename(Code = Country.Code,
         `Income Group` = IncomeGroup) %>% 
  filter(grepl("income", `Income Group`)) %>% 
  select(Code, `Income Group`) %>% 
  mutate(`Income Group` = str_replace_all(`Income Group`, "Upper middle income", "Middle income"),
         `Income Group` = str_replace_all(`Income Group`, "Lower middle income", "Middle income"))

healthincome <- inner_join(healthexp, incomegrp, by = "Code")

healthincome2 <- healthincome %>%
  rename("2014" = "X2014",
         "2008" = "X2008",
         "2002" = "X2002",
         "1996" = "X1996") %>% 
  gather("Year", "HealthTotal(%GDP)", 3:6) %>% 
  mutate(Year = as.numeric(Year)) %>% 
  select(Country, `Income Group`, Year, `HealthTotal(%GDP)`) 

healthincome3 <- healthincome2 %>% 
  group_by(`Income Group`, Year) %>%
  summarise(`HealthTotal(%GDP)` = mean(`HealthTotal(%GDP)`)) %>% 
  ungroup() %>% 
  mutate(`HealthTotal(%GDP)` = round(`HealthTotal(%GDP)`, digit = 2))

healthincome3$`Income Group` <- factor(healthincome3$`Income Group`, levels = c("High income", "Middle income", "Low income"))

# Graphing Data -----------------------------------------------------------

ggplot(healthincome3) +
  geom_line(aes(x = Year,
                y = `HealthTotal(%GDP)`,
                color = `Income Group`),
            show.legend = FALSE) + # I intend to label each points with a white-colored bolded percentage with a rectangle box around it.
  geom_point(aes(x = Year,
                 y = `HealthTotal(%GDP)`,
                 shape = `Income Group`, # I intend to assign shapes to each Income Group.
                color = `Income Group`),
             #color = "grey",
             size = 3) +
  geom_label_repel(aes(x = Year, 
                       y = `HealthTotal(%GDP)`,
                       label = paste0(`HealthTotal(%GDP)`, "%"),
                       fill = `Income Group`),
                   fontface = 'bold', color = 'white',
                   show.legend = FALSE) +
  labs(title = "World's GDP(%) on Total Health Expenditure by Income Groups over Time",
       x = "Year",
       y = "% of GDP on Health Expenditure"
       # color = "Income Group")
       ) +
  scale_x_continuous(breaks = c(1996, 2002, 2008, 2014), limits = c(1994, 2016)) +
  scale_y_continuous(limits = c(4.6, 8.2)) +
  theme_classic() # A classic-looking theme, with x and y axis lines and no gridlines.
