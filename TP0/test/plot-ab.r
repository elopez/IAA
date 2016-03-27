data = read.csv(paste(name, "data", sep="."))
title = paste("Ejercicio", ex, "con parámetros", params)
plot(data[,1], data[,2], col=data[,3]+2, main=title,
     xlab="X", ylab="Y", xlim=c(-5,5), ylim=c(-5,5))
axis(side=1, at=-5:5)
axis(side=2, at=-5:5)
