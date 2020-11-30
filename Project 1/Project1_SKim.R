## Data Visualization (GOVT16-QSS17) Fall 2017
## Work-On-Your-Own Data Visualization, Project 1
## Lab. Session 1
##
## Name: Soomin Kim
## Date: October 18, 2017

# Initial Settings --------------------------------------------------------

rm(list = ls())
library(tidyverse)
library(ggthemes)

# Read and Wrangle Data ---------------------------------------------------

data1 <- "data/BLW_wave3_public.csv"

df <- read.csv(data1) %>% 
 rename(Rating = rating, 
        Party_Identification = pid3, 
        Age = age9) %>%
  filter(Party_Identification %in% c("Democrat", "Republican")) %>%
  filter(Rating & Age != "NA") %>% 
  select(Party_Identification, Rating, Age)

df1 <- df %>% 
  group_by(Party_Identification, Age) %>% 
  summarize(Rating = mean(Rating)) %>% 
  ungroup()

df1$Rating_Num <- paste0(round(df1$Rating, 0), "%")

# Plot the Figure ---------------------------------------------------------

ggplot(df1,
       aes(x = Age,
           y = Rating)) +
  geom_bar(stat = "identity",
           fill = "gray80") +
  geom_text(aes(x = Age,
                y = Rating + 2,
                label = Rating_Num),
            size = 3.6) +
  facet_wrap(~Party_Identification) +
  theme_few() +
  scale_y_continuous(limits = c(0, 100), breaks = c(0, 20, 40, 60, 80, 100)) +
  geom_hline(yintercept = 50, lty = 2) +
  guides(fill = FALSE) +
  labs(title = "Perceived Level of Democracy in the U.S. Political System by Democrats and Republicans of Different Age Groups",
       subtitle = "YouGov General Public Survey (Sept. 2017)",
       x = "Age Groups",
       y = "Scale (%)")

ggsave("figure/figure1.pdf", width = 13, height = 8)



  
  