#set locale to default
Sys.setlocale(category = "LC_ALL", "C")
#download data if not already present
if (!file.exists("household_power_consumption.txt")) {
      download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                    destfile="household_power_consumption.zip")
      unzip("household_power_consumption.zip")
}
#read data with data.table (much faster)
library(data.table)
power.dat<-fread("household_power_consumption.txt",colClasses = "character",na.strings="?",data.table=FALSE)
#convert Date to class Date
power.dat$Date<- as.Date(power.dat$Date,format="%d/%m/%Y")
#select the data for the two specified days
reduced.power.dat<-power.dat[power.dat$Date==as.Date("2007-02-01") | power.dat$Date==as.Date("2007-02-02"),]
#remove the data to save memory
rm(power.dat)

#convert Date and Time to a common POSIXlt object
reduced.power.dat$Time<- strptime(paste(reduced.power.dat$Date,reduced.power.dat$Time),format="%Y-%m-%d %H:%M:%S")

#covnvert variable to numeric
reduced.power.dat$Sub_metering_1<-as.numeric(reduced.power.dat$Sub_metering_1)
reduced.power.dat$Sub_metering_2<-as.numeric(reduced.power.dat$Sub_metering_2)
reduced.power.dat$Sub_metering_3<-as.numeric(reduced.power.dat$Sub_metering_3)

png("plot3.png")
plot(reduced.power.dat$Time,reduced.power.dat$Sub_metering_1,type="l",col="black",xlab="",ylab="Energy sub metering")
points(reduced.power.dat$Time,reduced.power.dat$Sub_metering_2,type="l",col="red")
points(reduced.power.dat$Time,reduced.power.dat$Sub_metering_3,type="l",col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1)
dev.off()