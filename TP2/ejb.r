options(scipen = 999)
data = read.csv("ejb/discrete-error.csv", header=F)
colnames(data) <- c("n2", "error")
aggregate(.~n2, data=data, median, na.rm=TRUE)
