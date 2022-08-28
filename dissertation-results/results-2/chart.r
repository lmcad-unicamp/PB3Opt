setwd('/home/pc-752828/Dev/results-search-master/outputs-normal')

library(ggplot2)
library(dplyr)
library(extrafont)
library(dplyr)
library('EnvStats')
library("tikzDevice")
library(survJamda)

data <- read.csv(file = 'output-n-norm.csv', sep = ',', header = T)
data_new <- data
value <- function(x, name) {
  mym = median(x)
  mysd = sd(x)
  #mysd = mean(x)
  
  #mysd = geoSD(x, na.rm = FALSE, sqrt.unbiased = TRUE)
  mysqrt = sqrt(length(x))
  Q1 <- quantile(x, probs = 0.25)
  Q2 <- quantile(x, probs = 0.50)
  Q3 <- quantile(x, probs = 0.75)
  
  mym =  geoMean(x, na.rm = FALSE)
  print(mym)
  print(exp(mean(log(x))))
  #mym = mean(log(x))
  #mysd = geoSD(x, na.rm = FALSE, sqrt.unbiased = TRUE)
  mysd <- ci.gm(x)
  return(c(mn = mym, sd = mysd, bo = name))
}

data_f<-data.frame(data_new[data_new['bo'] == 'bo1' & data_new['target'] == 0,])
bo1 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EIdef')))
bo1 <- as.data.frame(as.list(bo1))

data_f<-data.frame(data_new[data_new['bo'] == 'bo3',])
bo3 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6sel-EIdef')))
bo3 <- as.data.frame(as.list(bo3))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4',])
bo4 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt')))
bo4 <- as.data.frame(as.list(bo4))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 3,])
bo5 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'Abordagem Proposta - Ótimo')))
bo5 <- as.data.frame(as.list(bo5))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 4,])
bo6 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'Abordagem Proposta - Pior')))
bo6 <- as.data.frame(as.list(bo6))

data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 5,])
bo7 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'Abordagem Proposta - Aleatório')))
bo7 <- as.data.frame(as.list(bo7))

data_f<-data.frame(data_new[data_new['bo'] == 'rs',])
bo7 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'Ranking Search')))
bo7 <- as.data.frame(as.list(bo7))

data_f<-data.frame(data_new[data_new['bo'] == 'bo5',])
bo8 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EInova')))
bo8 <- as.data.frame(as.list(bo8))

df <- rbind(bo1, bo3, bo8, bo4, bo7)

df <- rbind(bo1, bo3, bo8)

View(data)


df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd1 = as.numeric(as.character(df$x.sd1))
df$x.sd2 = as.numeric(as.character(df$x.sd2))
df_new <- df

p2<-ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.sd1, ymax=x.sd2,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  coord_cartesian(ylim=c(1,2), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.9, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  ggtitle('b) Zoom da Figura a')+
  scale_x_continuous(breaks = seq(1, 30, 1))

p1<-ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.sd1, ymax=x.sd2,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.9, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8),
        legend.background = element_rect(fill=alpha('white', 0.6)))+
  ggtitle('a) Melhor Custo Encontrado')+
  scale_x_continuous(breaks = seq(1, 30, 1))

tikz('fig1.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Média do Melhor Custo Normalizado")
dev.off()
