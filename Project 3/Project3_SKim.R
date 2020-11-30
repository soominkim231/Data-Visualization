## Data Visualization (GOVT16-QSS17) Fall 2017
## Project 3
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

# Figure 3 ----------------------------------------------------------------

# Data Wrangling ----------------------------------------------------------

filename <- "data/Number_of_Drug_and_Alcohol-Related_Intoxication_Deaths_by_Place_of_Occurrence__2007-2016_1__2_.csv"

drug <- read.csv(filename) %>% 
  filter(!(County %in% c("MARYLAND", "BALTIMORE COUNTY"))) %>%
  filter(!grepl("AREA", County)) %>% 
  rename("2007" = "X2007",
         "2016" = "X2016") %>% 
  select(County, "2007", "2016") %>% 
  gather(Year, Deaths, "2007":"2016") %>% 
  filter(!is.na(Deaths)) %>% 
  mutate(County = tolower(County))

statescounty <- map_data("county") %>% 
  rename(County = subregion)

anti_join(drug, statescounty, by = "County")

statescounty %>% filter(grepl("prince george", County))
statescounty %>% filter(grepl("st mary", County))
statescounty %>% filter(grepl("queen anne", County))

drug <- drug %>% 
  mutate(County = ifelse(County == "prince george's", "prince georges", County),
         County = ifelse(County == "st. mary's", "st marys", County),
         County = ifelse(County == "queen anne's", "queen annes", County))

deaths.2007 <- drug %>% 
  filter(Year == "2007") %>% 
  group_by(County) %>% 
  summarise(Deaths = mean(Deaths)) %>% 
  ungroup()

deaths.2016 <- drug %>% 
  filter(Year == "2016") %>% 
  group_by(County) %>% 
  summarise(Deaths = mean(Deaths)) %>% 
  ungroup()

countymap.2007 <- full_join(deaths.2007, statescounty, by = "County")
countymap.2007 <- countymap.2007 %>% 
  filter(region == "maryland")

countymap.2016 <- full_join(deaths.2016, statescounty, by = "County")
countymap.2016 <- countymap.2016 %>% 
  filter(region == "maryland")

# Text Labels Data Wrangling-------------------------------------------------------------

top5.2007 <- deaths.2007 %>% 
  top_n(5, Deaths) %>% 
  arrange(desc(Deaths))

labelcountymap.2007 <- countymap.2007 %>% 
  filter(County %in% c("baltimore city", "anne arundel", "montgomery", "prince georges", "harford")) %>% 
  group_by(County, Deaths) %>% 
  summarise(long = mean(long),
            lat = mean(lat)) %>% 
  ungroup() %>% 
  arrange(desc(Deaths)) %>% 
  mutate(County = ifelse(County == "baltimore city", "1.Baltimore City", County),
         County = ifelse(County == "anne arundel", "2.Anne Arundel", County),
         County = ifelse(County == "montgomery", "3.Montgomery", County),
         County = ifelse(County == "prince georges", "4.Prince Georges", County),
         County = ifelse(County == "harford", "5.Harford", County))

top5.2016 <- deaths.2016 %>% 
  top_n(5, Deaths) %>% 
  arrange(desc(Deaths))

labelcountymap.2016 <- countymap.2016 %>% 
  filter(County %in% c("baltimore city", "anne arundel", "prince georges", "montgomery", "frederick")) %>% 
  group_by(County, Deaths) %>% 
  summarise(long = mean(long),
            lat = mean(lat)) %>% 
  ungroup() %>% 
  arrange(desc(Deaths)) %>% 
  mutate(County = ifelse(County == "baltimore city", "1.Baltimore City", County),
         County = ifelse(County == "anne arundel", "2.Anne Arundel", County),
         County = ifelse(County == "prince georges", "3.Prince Georges", County),
         County = ifelse(County == "montgomery", "4.Montgomery", County),
         County = ifelse(County == "frederick", "5.Frederick", County))


# Data Visualizing using Functions -------------------------------------------

make_countymap <- function(data, label, date, color_low, color_high) {
  
  ggplot() +
    geom_polygon(data = data,
                 aes_string(x = "long", y = "lat", group = "group", fill = "Deaths"),
                 color = "grey80") +
    geom_label_repel(data = label,
                     aes(x = long, y = lat, label = County),
                     size = 4) +
    labs(title = paste("Drug and Alcohol Related Intoxication Deaths in Maryland,", date),
         subtitle = "Labeled: Top 5 Counties of Maryland",
         x = "",
         y = "",
         fill = "Total Deaths") +
    scale_fill_gradient(limits = c(0, 300),
                        low = color_low,
                        high = color_high,
                        na.value = "grey90") +
    coord_equal() +
    theme_minimal()
}

functionmap.2007 <- make_countymap(data = countymap.2007,
                                   label = labelcountymap.2007,
                                   date = "2007",
                                   color_low = "light blue",
                                   color_high = "blue")

functionmap.2016 <- make_countymap(data = countymap.2016,
                                   label = labelcountymap.2016,
                                   date = "2016",
                                   color_low = "pink",
                                   color_high = "red")

grid.arrange(functionmap.2007, functionmap.2016)
g <- arrangeGrob(functionmap.2007, functionmap.2016)
ggsave(filename = "figure/Project4_figure.pdf",
       plot = g, width = 10, height = 7.5)
