library("tikzDevice")

tikz('teste.tex')
u=seq(-3,3,by=.01)
plot(u,dnorm(u),type="l",axes=FALSE,xlab="z-score",ylab="Densidade de Probabilidade",col="white")
axis(1)
axis(2)
I=which((u<=1))
#polygon(c(u[I],rev(u[I])),c(dnorm(u)[I],rep(0,length(I))),col="gray",border=NA)
lines(u,dnorm(u),lwd=2,col="black")
text(.01, dnorm(20)+.25, "teste", cex = 1.5)
dev.off()
