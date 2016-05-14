plot_data <- function(file, size) {
    data = read.csv(file, sep="\t", header=F)
    title=paste("Predicciones basadas en entrenamiento con", size, "neuronas")
    plot(data[,1], data[,2], col=(data[,3]<=0.5)+2, main=title,
         xlab="X", ylab="Y", xlim=c(-1,1), ylim=c(-1,1))
}

plot_data("out-ejb/ejb-n2-2-4.predic", 2)
plot_data("out-ejb/ejb-n2-5-19.predic", 5)
plot_data("out-ejb/ejb-n2-10-16.predic", 10)
plot_data("out-ejb/ejb-n2-20-20.predic", 20)
plot_data("out-ejb/ejb-n2-40-19.predic", 40)
