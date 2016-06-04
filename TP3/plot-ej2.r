x = read.csv("dos_elipses.predict", header=F)
plot(x[,1], x[,2], col=x[,3]+2, main="Dos elipses - Naive Bayes con 500 puntos",
     xlab="X", ylab="Y")

x = read.csv("espirales.predict", header=F)
plot(x[,1], x[,2], col=x[,3]+2, main="Espirales anidadas - Naive Bayes",
     xlab="X", ylab="Y", xlim=c(-1,1), ylim=c(-1,1))

