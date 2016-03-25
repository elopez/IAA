data = read.csv(paste(name, "data", sep="."), header=F, col.names=c("a","b","c"))

sd(data[data$c==1,1])
sd(data[data$c==1,2])
sd(data[data$c==0,1])
sd(data[data$c==0,2])

mean(data[data$c==1,1])
mean(data[data$c==1,2])
mean(data[data$c==0,1])
mean(data[data$c==0,2])
