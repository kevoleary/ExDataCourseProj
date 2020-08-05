# Download data from internet, unzip it, and read it into R
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              destfile = "projDataZip", method = "curl")
unzip("projDataZip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load necessary packages for analysis
library(dplyr)

# Aggregate data by year, sum emissions for each year, and then graph the points
# and connect them by line segment and save them to a PNG file
yearlyTotal <- NEI %>% group_by(year) %>%
    summarize(totalEmissions = sum(Emissions))
png(filename = "plot1.png")
plot(yearlyTotal$year,yearlyTotal$totalEmissions,pch=19, main = "US Total Emissions",
     xlab = "Year", ylab = "Total Emissions of PM2.5 (tons)")
with(yearlyTotal, segments(year[1],totalEmissions[1],year[2],totalEmissions[2]))
with(yearlyTotal, segments(year[2],totalEmissions[2],year[3],totalEmissions[3]))
with(yearlyTotal, segments(year[3],totalEmissions[3],year[4],totalEmissions[4]))
dev.off()