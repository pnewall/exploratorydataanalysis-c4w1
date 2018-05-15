#
# start by ensuring necessary packages available\
#

if (!"dplyr" %in% installed.packages()) {
    install.packages("dplyr")
}
library(dplyr)

if (!"lubridate" %in% installed.packages()) {
  install.packages("lubridate")
}
library(lubridate)

#
# get local copy of dataset, read it & filter on the two days in February 2007
#

print("downloading input file ...")
fileName <- "./household_power_consumption.zip"
fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists(fileName)) {
    download.file(fileUrl, "./household_power_consumption.zip", method = "curl")
}

#
# read file into a table but replace ? with more conventional NA value
#

print("reading, filtering & mutating input file ...")
df_hpc <- read.table(unz("./household_power_consumption.zip", "household_power_consumption.txt"), header = TRUE, sep = ";", na.strings = "?")
df_filhpc <- filter(df_hpc, Date == "1/2/2007" | Date == "2/2/2007")
df_filhpc <- mutate(df_filhpc, ddate = as.POSIXct(paste(as.Date(Date, format = "%d/%m/%Y"), Time)))

#
# set the plot up
#

print("plotting now ...")
png("plot3.png", width = 480, height = 480)
par(mar = c(5, 5, 4, 2), mfrow = c(1, 1))
with(df_filhpc, plot(Sub_metering_1 ~ ddate, type = "l", lty = 1, xlab = "", ylab = "Energy sub metering"))
with(df_filhpc,lines(Sub_metering_2 ~ ddate, type = "l", lty = 1, xlab = "", col = "red"))
with(df_filhpc, lines(Sub_metering_3 ~ ddate, type = "l", lty = 1, xlab = "", col = "blue"))
with(df_filhpc, legend("topright", 
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    col = c("black", "blue", "red"), 
    cex = 0.8, 
    inset = c(0.001, 0.001),
    lty = c(1, 1, 1)
    ))
dev.off()
