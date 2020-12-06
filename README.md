# QSS17: Data Visualization (R)
Data visualization projects I worked on as part of QSS 17: Data Visualization at Dartmouth.

## Project 1
Bar plot displaying the perceived level of democracy in the U.S. Political System by Democrats and Republicans of Different Age Groups. 
Data Source: YouGov General Public Survey (Sept. '17)

## Project 2
Map showing Top 10 states attended by Undergraduates students by race (White vs. African Americans).

## Project 3
Map showing Top 5 counties in Maryland for Drug and Alcohol Related Intoxication Deaths in 2007 and 2016.

## Project 4
Stacked bar plot showing homeless population in New York by regions, from 2009-2012.

## Project 5
Line graphs displaying an upward trend in the global mean percentage of Gross Domestic Product (GDP) on health expenditures for all income groups from 1996 to 2014, with the high-income group showing the highest %, followed by the middle and low-income groups.

### In Detail:
Health expenditures include both public and private health expenditures of all countries and income groups are divided by high, middle and low income countries.
The three positive upward slopes show that there is an increase in % of GDP on health expenditures from 1996 to 2014 for all income groups. While the middle and low-income groups have an overall steady increase over years, the high-income group only display a steady increase in percentage of GDP on health expenditures until 2008 when there is a sudden increase from 7.23% in 2008 to 7.9% in 2014, indicated by a comparably steeper slope. This suggests that the high-income group is placing more emphasis on health expenditures, both public and private, in recent years than they had been before.
Interestingly, the graph showing a wider gap between the high-income curve and middle-income curve, compared to that between the middle and low-income curves, suggests that the difference in % of GDP on health expenditures between the high and middle-income groups is greater than that between the middle and low-income groups. In other words, the high-income group globally has a more prominent share of their GDP on health expenditures than middle and low-income groups.

### Data Source Description:
My data source is World Health Organization (WHO) Global Health Expenditure database. The Global Health Expenditure database, which provides internationally comparable numbers on national health expenditures, has been annually updated by WHO from publicly available reports. The two data files (in csv format) I used from this data source are: ‘Metadata_Country_API_SH.XPD.TOTL.ZS_DS2_en_csv_v2.csv’, ‘API_SH.XPD.TOTL.ZS_DS2_en_csv_v2.csv’. 
The former dataset mainly includes ‘Country Code, Region, Income group’ variables and the latter mainly includes ‘Country Name, Country Code, % of GDP on health expenditures by year from 1995 to 2014’ variables. I combined the two datasets by ‘Country Code’ to produce my figure.
