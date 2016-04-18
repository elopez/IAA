library("ggplot2")
x = read.csv(file, header=F)
a = aggregate(x[x[,1]=='a',3], list(x[x[,1]=='a',2]), mean)
b = aggregate(x[x[,1]=='b',3], list(x[x[,1]=='b',2]), mean)

acol = aes(colour = "A")
bcol = aes(colour = "B")

ggplot(a, aes(Group.1, y=x)) +
  geom_point(acol) +
  geom_line(acol) +
  geom_point(data=b, bcol) +
  geom_line(data=b, bcol) +
  labs(y = "Tamaño del árbol promedio") +
  labs(x = "Cantidad de puntos de entrenamiento") +
  labs(title = paste("Tamaño del árbol",title)) +
  theme(legend.title=element_blank())
