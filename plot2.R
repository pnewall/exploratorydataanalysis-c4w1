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
png("plot2.png", width = 480, height = 480)
par(mar = c(5, 5, 4, 2), mfrow=c(1, 1))
with(df_filhpc, plot(Global_active_power~ddate, type = "l", lty = 1, xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()
