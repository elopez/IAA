library("ggplot2")
x = read.csv(file, header=F)
a=aggregate(x[x[,1]==set,3], list(x[x[,1]==set,2]), mean)
ggplot(a, aes(Group.1, y=x)) +
  geom_point() +
  geom_line() +
  labs(y = "Tamaño del árbol promedio") +
  labs(x = "Cantidad de puntos de entrenamiento") +
  labs(title = paste("Tamaño del árbol",title)) +
  theme(legend.title=element_blank())
