library(RSQLite)
library(lubridate)
filename <- "data_electricpowerconsumption.zip"

##Download and unzip the file
if(!file.exists(filename)){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                filename, method = "curl")
}
if(!file.exists("household_power_consumption.txt")){unzip(filename)}

##Store the data in a sql table(on disk)
##Create/connect to a database named "data_db.sqlite

con <- dbConnect(RSQLite::SQLite(), dbname = "data_db.sqlite")

#Write txt file into the database
dbWriteTable(con, name = "data_table", value = "household_power_consumption.txt", row.names = FALSE, header = TRUE, sep = ";")

##Read the text file and subset into selected_data
my_data <- dbGetQuery(con, "SELECT * FROM data_table WHERE Date in ('1/2/2007', '2/2/2007')")
my_data$Date <- dmy(as.character(my_data$Date))
sub_metering_1 <- as.numeric(as.character(my_data$Sub_metering_1))
sub_metering_2 <- as.numeric(as.character(my_data$Sub_metering_2))
sub_metering_3 <- as.numeric(as.character(my_data$Sub_metering_3))
datetime <- as.POSIXct(paste(my_data$Date, my_data$Time, sep = " "))
global_active_power <- as.numeric(as.character(my_data$Global_active_power))
global_reactive_power <- as.numeric(as.character(my_data$Global_reactive_power))
voltage <- as.numeric(as.character(my_data$Voltage))

##Plot the chart and save as plot4.png
if(!file.exists("plot4.png")){
  png("plot4.png", width = 480, height = 480, res = 72)
  par(mfrow = c(2,2), mar = c(1,0.5,1,0.5), pin = c(2,1.5), cex = 0.6)
  plot(datetime, global_active_power, type = "l", xlab= "", ylab = "Global Active Power")
  
  plot(datetime, voltage, type = "l", ylab = "Voltage")
  
  plot(datetime, sub_metering_1, col = "grey", type = 'l', ylim = range(c(sub_metering_1, sub_metering_2, sub_metering_3)), xlab = "", ylab="Energy Sub metering")
  par(new=T)
  plot(datetime, sub_metering_2, col = "red", type = 'l', ylim = range(c(sub_metering_1, sub_metering_2, sub_metering_3)), axes = FALSE, xlab="", ylab="")
  par(new=T)
  plot(datetime, sub_metering_3, col = "blue", type = 'l', ylim = range(c(sub_metering_1, sub_metering_2, sub_metering_3)), axes = F, xlab = "", ylab = "")
  legend("topright", col = c("grey", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = c(1,1,1), cex = 0.75)
  
  plot(datetime, global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
  
  dev.off()
}





