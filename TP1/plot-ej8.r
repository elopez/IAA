data = read.csv("xor.data", header=F)
colnames(data) <- c("x", "y", "noise1", "noise2", "noise3", "noise4", "class")
title="Features de dataset XOR"
plot(data[,-7], col=data[,7]+2, main=title)
