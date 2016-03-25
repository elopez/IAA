data = read.csv(paste(name, "data", sep="."))
title=paste("Ejercicio C con", params, "puntos")
plot(data[,1], data[,2], xlab="X", ylab="Y", main=title, col=data[,3]+2)
