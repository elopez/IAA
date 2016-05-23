options(scipen = 999)
data = read.csv("out-ejd/decay.csv", header=F)
colnames(data) <- c("gamma", "mse_decay")
data$decay <- data$mse_decay * data$gamma
aggregate(.~gamma, data=data, median, na.rm=TRUE)
