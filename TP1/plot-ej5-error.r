library("ggplot2")
x = read.csv(file, header=F)
a = aggregate(x[x[,1]=='a',3:4], list(x[x[,1]=='a',2]), mean)
b = aggregate(x[x[,1]=='b',3:4], list(x[x[,1]=='b',2]), mean)
atrain = aes(y = V3, colour = "A - Train")
atest = aes(y = V4, colour = "A - Test")
btrain = aes(y = V3, colour = "B - Train")
btest = aes(y = V4, colour = "B - Test")
ggplot(a, aes(Group.1)) +
  geom_point(atrain) +
  geom_point(atest) +
  geom_line(atrain) +
  geom_line(atest) +
  geom_point(data = b, btrain) +
  geom_point(data = b, btest) +
  geom_line(data = b, btrain) +
  geom_line(data = b, btest) +
  labs(y = "Error porcentual promedio") +
  labs(x = "Cantidad de puntos de entrenamiento") +
  labs(title = paste("Error porcentual",title)) +
  theme(legend.title=element_blank())
