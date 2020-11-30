## Data Visualization (GOVT16-QSS17) Fall 2017
## Project 4
##
## Name: Soomin Kim

# Initial Settings --------------------------------------------------------

rm(list = ls())
options(stringsAsFactors = FALSE)
library(tidyverse)
library(ggmap)
library(gridExtra)
library(ggrepel)
library(ggthemes)

# Figure 4 ----------------------------------------------------------------

rm(list = ls())

# Data Wrangling ----------------------------------------------------------

filename <- "data/Directory_Of_Homeless_Population_By_Year.csv"
df <- read_csv(filename) %>% 
  filter(!(Area %in% c("Surface Total", "Total Unsheltered Individuals", "Subways"))) %>% 
  mutate(Area = ifelse(Area == "Surface Area - Manhattan", "Manhattan", Area),
         Area = ifelse(Area == "Surface Area - Bronx", "Bronx", Area),
         Area = ifelse(Area == "Surface Area - Brooklyn", "Brooklyn", Area),
         Area = ifelse(Area == "Surface Area - Queens", "Queens", Area),
         Area = ifelse(Area == "Surface Area - Staten Island", "Staten Island", Area))

df$Area <- factor(df$Area,
                  levels = c("Manhattan", "Brooklyn", "Bronx", "Staten Island", "Queens"))

df$Manhattan <- round(df$`Homeless Estimates`, -2)
df$Manhattan[df$Area != "Manhattan"] <- NA

# Data Visualizing --------------------------------------------------------

ggplot(df,
       aes(x = Year, y = `Homeless Estimates`)) +
  geom_bar(stat = "identity",
           aes(fill = Area)) +
  geom_text(aes(label = Manhattan,
                y = `Homeless Estimates` + 250),
            size = 5,
            na.rm = TRUE) +
  labs(title = "Homeless Population by Regions in New York during 2009-2012") +
  theme_few()

ggsave("figure/Project4_figure.pdf", width = 10, height = 7.5)
