# Download data from internet, unzip it, and read it into R
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              destfile = "projDataZip", method = "curl")
unzip("projDataZip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load necessary packages for analysis
library(dplyr)
library(ggplot2)

# Filter the data to just Baltimore county, aggregate data by year, sum 
# emissions for each year, and then graph the points and connect them by line 
# segment and save them to a PNG file using separate lines for each type
yearlyBalTotal <- NEI %>% filter(fips == 24510) %>%
    group_by(year,type) %>%
    summarize(balEmissions = sum(Emissions))
png(filename = "plot3.png")
ggplot(yearlyBalTotal,aes(x = year, y = balEmissions)) +
    geom_line(aes(color = type)) + geom_point(aes(color = type)) + 
    labs(y = "Yearly PM2.5 Emissions (tons)", x = "Year",
         title = "Baltimore County Emissions by Type")
dev.off()