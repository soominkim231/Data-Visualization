## Data Visualization (GOVT16-QSS17) Fall 2017
## Data Visualization with ggplot2, Part 3
## Project 4, Key
##
## Name: Soomin Kim


# Initial Settings --------------------------------------------------------

# install.packages("readxl")
# install.packages("ggthemes")

rm(list = ls())
library(tidyverse)
library(readxl)
library(ggthemes)

# Figure 1 ----------------------------------------------------------------

df1 <- read_xls("des_data.xls", sheet = 1)

vars <- c("R/E", "year", "pct")
obs <- !is.na(df1$'R/E') & (df1$'R/E' != "Two or more races")
df1 <- df1[obs, vars]

# alternative: df1 <- df1[!is.na(df1$`R/E`) & !is.na(df1$pct),] # remove NAs in variables
print(df1)
df1$pct_white <- paste0(round(df1$pct, 1), "%")
df1$pct_white[df1$`R/E` != "White"] <- NA

df1$year <- as.character(df1$year)

df1$`R/E` <- factor(df1$`R/E`, 
                    levels = c("White",
                               "Black",
                               "Hispanic",
                               "Asian/Pacific Islander",
                               "American Indian/Alaska Native"))

df1$pct <- as.numeric(df1$pct)

ggplot(df1, aes(x = year,
                y = pct,
                fill = `R/E`)) +
  geom_bar(stat = "identity",
           color = "white") +
  geom_text(aes(x = year,
            label = pct_white),
            y = 60,
            size = 3,
            na.rm = TRUE) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(ncol = 3, byrow = TRUE)) +
  scale_fill_brewer(palette = "Pastel1") +
  labs(title = "Demographic Composition of University Faculty Over Time, by Race/Ethnicity",
       subtitle = "Sources: Tabs (2002, Table 5A), The Digest of Education Statistics (2016, Table 315.20)",
       y = "%",
       x = "Year",
       fill = "Race/Ethnicity")

ggsave("figure/Project4_figure1.pdf", scale = 0.8, width = 10, height = 7.5)


# Figure 2 ----------------------------------------------------------------

df2 <- read_xls("data/des_data.xls", sheet = 2)

ggplot(df2, aes(x = year,
                y = pct)) +
  geom_bar(stat = "identity",
           fill = "gray80") +
  geom_text(aes(x = year, 
                y = pct + 3,
                label = paste0(pct, "%"))) +
  facet_wrap(~ type) +
  theme_few() +
  scale_y_continuous(limits = c(0, 100), breaks = c(0, 25, 50, 75, 100)) +
  geom_hline(yintercept = 50, lty = 2) +
  guides(fill = FALSE) +
  labs(title = "Percentage of University Faculty who are Women",
       subtitle = "Source: TIAA (2013, Table 2, Table 3)",
       y = "%",
       x = "Year",
       fill = "none")

ggsave("figure/Project4_figure2.pdf", scale = 0.8, width = 10, height = 7.5)
