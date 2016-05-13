#file = "ejb/ejb-n2-10-19.predic"
#size = "10"
file = "ejb/ejb-n2-40-4.predic"
size = "40"
data = read.csv(file, sep="\t", header=F)
title=paste("Predicciones basadas en entrenamiento con", 10, "neuronas")
plot(data[,1], data[,2], col=(data[,3]<=0.5)+2, main=title,
     xlab="X", ylab="Y", xlim=c(-1,1), ylim=c(-1,1))
