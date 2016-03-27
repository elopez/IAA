data = read.csv(paste(name, "data", sep="."))
title=paste("Ejercicio C con", params, "puntos")
plot(data[,1], data[,2], col=data[,3]+2, main=title,
     xlab="X", ylab="Y", xlim=c(-1,1), ylim=c(-1,1))
