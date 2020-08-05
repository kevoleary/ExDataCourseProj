# Download data from internet, unzip it, and read it into R
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              destfile = "projDataZip", method = "curl")
unzip("projDataZip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load necessary packages for analysis
library(dplyr)
library(ggplot2)

# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

# Explore the data to figure out how best to subset for "motor vehicles"
onroad <- filter(SCC, Data.Category == "Onroad")
nrow(onroad) # 1137 rows
vehicle <- SCC[grep("Vehicle",SCC$EI.Sector),]
nrow(vehicle) # 1138 rows
SCC[SCC$SCC == setdiff(vehicle$SCC,onroad$SCC),] # find entry in SCC where sets diverge
filter(NEI, SCC == setdiff(vehicle$SCC,onroad$SCC)) # Does this entry appear in NEI
# Doesn't appear, so either dataset appears to be valid for this purpose.
# I opted for vehicle, but either would yield the same results

# Subset the data to only motor-vehicle related activities, filter for only
# results from Baltimore County, sum  emissions for each year, and then graph 
# the points and connect them by line segment and save them to a PNG file
yearlyVehTotal <- NEI %>% 
    filter(SCC %in% vehicle$SCC) %>%
    filter(fips == 24510) %>%
    group_by(year) %>%
    summarize(vehEmissions = sum(Emissions))
png(filename = "plot5.png")
ggplot(yearlyVehTotal,aes(x = year, y = vehEmissions)) + geom_line() + 
    labs(y = "PM2.5 Emissions (tons)", x = "Year",
         title = "Yearly Emissions from Motor Vehicles in Baltimore")
dev.off()
