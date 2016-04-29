library("ggplot2")
x = read.csv(file, header=F)
a = aggregate(x[x[,1]=='a',4], list(x[x[,1]=='a',2]), mean)
b = aggregate(x[x[,1]=='b',4], list(x[x[,1]=='b',2]), mean)
atest = aes(y = x, colour = "A - Test")
btest = aes(y = x, colour = "B - Test")
ggplot(a, aes(Group.1)) +
  # A
  geom_point(atest) +
  geom_line(atest) +
  # B
  geom_point(data = b, btest) +
  geom_line(data = b, btest) +
  labs(y = "Error porcentual promedio") +
  labs(x = "Valor de d") +
  labs(title = paste("Error porcentual",title)) +
  theme(legend.title=element_blank())
