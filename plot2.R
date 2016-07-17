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
my_data$Global_active_power <- as.numeric(as.character(my_data$Global_active_power))


##Plot a scatterplot and save as plot2.png
par(mfrow = c(1,1))
datetime <- as.POSIXct(paste(my_data$Date, my_data$Time, sep=" "))
if(!file.exists("plot2.png")){
  png("plot2.png")
  plot(datetime, my_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
  dev.off()
}

