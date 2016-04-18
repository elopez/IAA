library("ggplot2")
x = read.csv(file, header=F)
a=aggregate(x[x[,1]==set,3:4], list(x[x[,1]==set,2]), mean)
train = aes(y = V3, colour = "Train")
test = aes(y = V4, colour = "Test")
ggplot(a, aes(Group.1)) +
  geom_point(train) +
  geom_point(test) +
  geom_line(train) +
  geom_line(test) +
  labs(y = "Error porcentual promedio") +
  labs(x = "Cantidad de puntos de entrenamiento") +
  labs(title = paste("Error porcentual",title)) +
  theme(legend.title=element_blank())
