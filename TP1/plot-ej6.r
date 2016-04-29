bayes_error_pct <- function(file, ex) {
  d = read.csv(file, header=F)
  if (ex == 'a') {
    func = function(x) {
      dista = (x[1]-1)^2 + (x[2]-1)^2 + (x[3]-1)^2 + (x[4]-1)^2 + (x[5]-1)^2
      distb = (x[1]+1)^2 + (x[2]+1)^2 + (x[3]+1)^2 + (x[4]+1)^2 + (x[5]+1)^2
      return (0+(dista > distb))
    }
  } else {
    func = function(x) (0+(x[1] < 0))
  }

  truth <- d[,6]
  pred <- apply(d[,-6], 1, func)
  count <- 0
  total <- length(truth)

  for (i in 1:total) {
      if (truth[i] != pred[i])
          count <- count + 1
  }

  return(count/total*100);
}

bayes_error_ex <- function(ex) {
  p = matrix(NA, 5, 2)
  for (i in 1:5) {
    file = paste("test-", ex, "-", formatC(i*0.5, digits=1, format="f"),".data", sep="")
    p[i,] = c(i*0.5, bayes_error_pct(file, ex))
  }
  return(data.frame(p))
}


library("ggplot2")
x = read.csv(file, header=F)
a = aggregate(x[x[,1]=='a',4], list(x[x[,1]=='a',2]), mean)
b = aggregate(x[x[,1]=='b',4], list(x[x[,1]=='b',2]), mean)
abay = bayes_error_ex('a')
bbay = bayes_error_ex('b')
atest = aes(y = x, colour = "A - Test")
abayes = aes(X1, y = X2, colour = "A - Bayes")
btest = aes(y = x, colour = "B - Test")
bbayes = aes(X1, y = X2, colour = "B - Bayes")
ggplot(a, aes(Group.1)) +
  # A
  geom_point(atest) +
  geom_line(atest) +
  # B
  geom_point(data = b, btest) +
  geom_line(data = b, btest) +
  # Bayes
  geom_point(data = abay, abayes) +
  geom_point(data = bbay, bbayes) +
  geom_line(data = abay, abayes) +
  geom_line(data = bbay, bbayes) +
  labs(y = "Error porcentual promedio") +
  labs(x = "Valor de C (overlapping)") +
  labs(title = paste("Error porcentual",title)) +
  theme(legend.title=element_blank())
