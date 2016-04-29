data = read.csv("xor.data", header=F)
title="Features de dataset XOR"
plot(data[,-7], col=data[,7]+2, main=title)
