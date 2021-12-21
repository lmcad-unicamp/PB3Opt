setwd('/home/pc-752828/Dev/results-search-master/outputs-pi')
library(ggplot2)
library(dplyr)
library(extrafont)
library(dplyr)
library('EnvStats')
library("tikzDevice")

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

data_f<-data.frame(data_new[data_new['bo'] == 'bo1',])
bo1 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EIdef')))
bo1 <- as.data.frame(as.list(bo1))

data_f<-data.frame(data_new[data_new['bo'] == 'bo5',])
bo2 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6rnd-EInova')))
bo2 <- as.data.frame(as.list(bo2))

data_f<-data.frame(data_new[data_new['bo'] == 'rs',])
bo3 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'Ranking Search')))
bo3 <- as.data.frame(as.list(bo3))



data <- read.csv(file = 'output-n-pi.csv', sep = ',', header = T)
data <- read.csv(file = 'output-n-pi-cost.csv', sep = ',', header = T)




data <- read.csv(file = 'output-ecp-pi.csv', sep = ',', header = T)
data <- read.csv(file = 'output-ecp-pi-cost.csv', sep = ',', header = T)

data_new <- data

data_f<-data.frame(data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 0,]))
bo1 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt - PI')))
bo1 <- as.data.frame(as.list(bo1))

data_f<-data.frame(data_f<-data.frame(data_new[data_new['bo'] == 'bo4' & data_new['target'] == 1,]))
bo2 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt - Real')))
bo2 <- as.data.frame(as.list(bo2))





df <- rbind(bo2, bo1)

df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd1 = as.numeric(as.character(df$x.sd1))
df$x.sd2 = as.numeric(as.character(df$x.sd2))
df_new <- df
df_new <- df[df['Group.1'] >= 6,]

p1<-ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.sd1, ymax=x.sd2,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  coord_cartesian(ylim=c(1,1.25), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.8, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        #axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 30, 1))+
  ggtitle('a) Melhor Custo Encontrado')

p2<-ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  #geom_errorbar(aes(ymin=x.mn-x.sd, ymax=x.mn+x.sd,color=x.bo), width=0.2, size=.3) +
  geom_errorbar(aes(ymin=x.sd1, ymax=x.sd2,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  #coord_cartesian(ylim=c(1,4), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Custo Normalizado Acumulado")+
  theme(legend.justification=c(1, 1),legend.position=c(.6, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        #axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 30, 1))+
  ggtitle('b) Custo Acumulado')


tikz('fig2-pi.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="")
dev.off()
