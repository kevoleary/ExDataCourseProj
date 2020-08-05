# Download data from internet, unzip it, and read it into R
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              destfile = "projDataZip", method = "curl")
unzip("projDataZip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load necessary packages for analysis
library(dplyr)

# Filter the data to just Baltimore county, aggregate data by year, sum 
# emissions for each year, and then graph the points and connect them by line 
# segment and save them to a PNG file
yearlyBalTotal <- NEI %>% filter(fips == 24510) %>%
    group_by(year) %>%
    summarize(balEmissions = sum(Emissions))
png(filename = "plot2.png")
with(yearlyBalTotal,plot(year,balEmissions,pch=19, 
                         main = "Yearly Emissions in Baltimore Country",
                         xlab = "Year",
                         ylab = "PM2.5 Emissions in Baltimore County (tons)"))
with(yearlyBalTotal, segments(year[1],balEmissions[1],year[2],balEmissions[2]))
with(yearlyBalTotal, segments(year[2],balEmissions[2],year[3],balEmissions[3]))
with(yearlyBalTotal, segments(year[3],balEmissions[3],year[4],balEmissions[4]))
dev.off()