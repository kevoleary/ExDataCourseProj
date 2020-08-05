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

# Find indices in SCC with coal AND combustion-related activities, 
levelThree <- intersect(grep("Coal",SCC$SCC.Level.Three),
                        grep("Combustion", SCC$SCC.Level.One))
levelFour <- intersect(grep("Coal",SCC$SCC.Level.Four),
                       grep("Combustion", SCC$SCC.Level.One))
coal <- unique(c(levelThree,levelFour))
coalSCC <- as.numeric(as.character(SCC$SCC[coal]))
# Filter the data to only coal-combustion related activities, sum  emissions for 
# each year, and then graph the points and connect them by line segment and save
# them to a PNG file
yearlyCoalTotal <- NEI %>% 
    mutate(sccCode = as.numeric(SCC)) %>%
    filter(sccCode %in% coalSCC) %>%
    group_by(year) %>%
    summarize(coalEmissions = sum(Emissions))
png(filename = "plot4.png")
ggplot(yearlyCoalTotal,aes(x = year, y = coalEmissions)) + geom_line() + 
    labs(y = "Yearly PM2.5 Emissions (tons)", x = "Year",
         title = "Yearly Coal Combustion Emissions")
dev.off()