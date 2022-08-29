data <- read.csv("data/GlobalLandTemperaturesByCountry.csv")
data = na.omit(data)

countries = unique(data[,4])
countries = countries[2:length(countries)]

data[,1] = as.POSIXct(data[,1], format="%Y-%m-%d", tz="UTC")

print('Data Loaded...')