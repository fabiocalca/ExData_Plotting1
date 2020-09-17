# Load the necessary libraries
library(readr)
library(dplyr)
library(lubridate)
dataDir <- "./data"
zipFile <- "./data/household_power_consumption.zip"
dataFile <- "./data/household_power_consumption.txt"
# Create a directory named 'data' if not already present.
# Download and extract the .zip file,
# before reading the file into a data table
if(!file.exists(dataDir)) {
  dir.create(dataDir)
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url = fileUrl, destfile = zipFile)
  unzip(zipFile, exdir = dataDir)
}
# Save the variable names to index it later since we are going to skip rows
savedNames <- c("Date","Time","Global_active_power","Global_reactive_power",
                "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

# Read the file
firstWanted <- 66638 # Line of date 2007-02-01 at 00:00
number_of_lines <- 60*24*2 # 60 minutes times 24 hours times 2 days
data <- read_delim(dataFile,delim=';',col_names=savedNames,
                   skip = firstWanted-1,n_max=number_of_lines,na='?')

# Fix dates with lubridate and create a new variable with date and time together
data <- data %>%
  mutate(Date=dmy(data$Date))
data <- data %>%
  mutate(datetime=as.POSIXct(paste(data$Date,data$Time)))

# Open a png device
png(filename='plot2.png')
with(data,plot(datetime,Global_active_power,type='l',xlab='',ylab='Global Active Power (kilowatts)'))
dev.off()

