## Data Visualization (GOVT16-QSS17) Fall 2017
## Work-On-Your-Own Data Visualization, Project 2
## Lab. Session 2
##
## Name: Soomin Kim
## Date: October 24, 2017


# Initial Settings --------------------------------------------------------

rm(list = ls())
options(stringsAsFactors = FALSE)
library(tidyverse)
library(gridExtra)
library(ggmap)


# Analysis ----------------------------------------------------------------

data1 <- "data/MERGED2015_16_PP.csv"
ugds1 <- read.csv(data1, na.strings = "NULL") %>% 
  rename(States = STABBR,
         White = UGDS_WHITE,
         Black = UGDS_BLACK) %>% 
  filter(States != "DC" & States != "VI") %>% 
  select(States, White, Black) %>% 
  na.omit()

ugds2 <- ugds1 %>% 
  group_by(States) %>% 
  summarise(White_Avg = mean(White),
            Black_Avg = mean(Black)) %>% 
  ungroup() %>%
  mutate(White_Avg = round(White_Avg * 100),
         Black_Avg = round(Black_Avg * 100)) %>%
  arrange(desc(White_Avg, Black_Avg))

top10w <- ugds2 %>% 
  top_n(10, White_Avg) %>%
  select(States, White_Avg) %>% 
  arrange(desc(White_Avg))

top10b <- ugds2 %>% 
  top_n(10, Black_Avg) %>% 
  select(States, Black_Avg) %>% 
  arrange(desc(Black_Avg))

data2 <- "data/uscitiesv1.3.csv"
usstatemap <- read_csv(data2) %>% 
  rename(States = state_id) %>% 
  select(States, state_name)

usstatemap_top10w <- inner_join(usstatemap, top10w, by = "States") %>% 
  distinct()
usstatemap_top10b <- inner_join(usstatemap, top10b, by = "States") %>% 
  distinct()

usstatemap_top10w <- usstatemap_top10w %>% 
  mutate(state_name = ifelse(state_name == "West Virginia", "west virginia", state_name),
         state_name = ifelse(state_name == "Maine", "maine", state_name),
         state_name = ifelse(state_name == "New Hampshire", "new hampshire", state_name),
         state_name = ifelse(state_name == "Wyoming", "wyoming", state_name),
         state_name = ifelse(state_name == "Idaho", "idaho", state_name),
         state_name = ifelse(state_name == "Iowa", "iowa", state_name),
         state_name = ifelse(state_name == "Utah", "utah", state_name),
         state_name = ifelse(state_name == "Vermont", "vermont", state_name),
         state_name = ifelse(state_name == "Nebraska", "nebraska", state_name),
         state_name = ifelse(state_name == "Kentucky", "kentucky", state_name))


usstatemap_top10b <- usstatemap_top10b %>% 
  mutate(state_name = ifelse(state_name == "Mississippi", "mississippi", state_name),
         state_name = ifelse(state_name == "Georgia", "georgia", state_name),
         state_name = ifelse(state_name == "Louisiana", "louisiana", state_name),
         state_name = ifelse(state_name == "Alabama", "alabama", state_name),
         state_name = ifelse(state_name == "South Carolina", "south carolina", state_name),
         state_name = ifelse(state_name == "Maryland", "maryland", state_name),
         state_name = ifelse(state_name == "North Carolina", "north carolina", state_name),
         state_name = ifelse(state_name == "Virginia", "virginia", state_name),
         state_name = ifelse(state_name == "Delaware", "delaware", state_name),
         state_name = ifelse(state_name == "Arkansas", "arkansas", state_name))

statesmap <- map_data("state") %>% 
  rename(state_name = region)

statesmap_top10w <- full_join(statesmap, usstatemap_top10w, by = "state_name")
statesmap_top10b <- full_join(statesmap, usstatemap_top10b, by = "state_name")

labelstates_top10w <- statesmap_top10w %>% 
  filter(!is.na(White_Avg)) %>% 
  group_by(States, White_Avg) %>% 
  summarise(long = mean(long),
            lat = mean(lat))

labelstates_top10b <- statesmap_top10b %>% 
  filter(!is.na(Black_Avg)) %>% 
  group_by(States, Black_Avg) %>% 
  summarise(long = mean(long),
            lat = mean(lat))


# ggplot ------------------------------------------------------------------

plot10w <- ggplot() +
  geom_polygon(data = statesmap_top10w,
               aes(x = long, y = lat, group = group, fill = White_Avg),
               color = "grey80") +
  labs(title = paste("Top 10 States attended by Undergraduate Students who are White"),
       x = "", y = "",
       fill = "Percentage") +
  scale_fill_gradient(limits = c(0, 100),
                      low = "light blue",
                      high = "blue",
                      na.value = "grey90") +
  geom_text(data = labelstates_top10w,
            aes(x = long, y = lat, label = States),
            size = 3,
            color = "white",
            na.rm = TRUE) +
  coord_equal() +
  theme_minimal()

plot10b <- ggplot() +
  geom_polygon(data = statesmap_top10b,
               aes(x = long, y = lat, group = group, fill = Black_Avg),
               color = "grey80") +
  labs(title = paste("Top 10 States attended by Undergraduate Students who are African Americans"),
       x = "", y = "",
       fill = "Percentage") +
  scale_fill_gradient(limits = c(0, 100),
                      low = "pink",
                      high = "red",
                      na.value = "grey90") +
  geom_text(data = labelstates_top10b,
            aes(x = long, y = lat, label = States),
            size = 3,
            color = "white",
            na.rm = TRUE) +
  coord_equal() +
  theme_minimal()

grid.arrange(plot10w, plot10b)

p <- arrangeGrob(plot10w, plot10b)
ggsave(filename = "figure/Project2figure.pdf",
       plot = p, width = 10, height = 7.5)
