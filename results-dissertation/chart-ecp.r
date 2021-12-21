setwd('/home/pc-752828/Dev/results-search-master/outputs-ecp')

library(ggplot2)
library(dplyr)
library(extrafont)
library(dplyr)
library('EnvStats')
library("tikzDevice")
library(survJamda)

data <- read.csv(file = 'output-ecp-norm.csv', sep = ',', header = T)
data_new <- data
value <- function(x, name) {
  #mym = median(x)
  mysd = sd(x)
  mym = mean(x)
  
  #mysd = geoSD(x, na.rm = FALSE, sqrt.unbiased = TRUE)
  mysqrt = sqrt(length(x))
  #Q1 <- quantile(x, probs = 0.25)
  #Q2 <- quantile(x, probs = 0.50)
  #Q3 <- quantile(x, probs = 0.75)
  
  mym =  geoMean(x, na.rm = FALSE)
  #print(mym)
  #print(exp(mean(log(x))))
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

data_f<-data.frame(data_new[data_new['bo'] == 'bo4',])
bo4 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'PB3Opt')))
bo4 <- as.data.frame(as.list(bo4))

data_f<-data.frame(data_new[data_new['bo'] == 'bo3',])
bo5 <- aggregate(x = data_f$best,
                 by = list(data_f$ite),
                 FUN = function(x) return(value(x, 'BO-6sel-EIdef')))
bo5 <- as.data.frame(as.list(bo5))













df <- rbind(bo5, bo4, bo3)

df <- rbind(bo1, bo5, bo2, bo5, bo4, bo3)

df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd1 = as.numeric(as.character(df$x.sd1))
df$x.sd2 = as.numeric(as.character(df$x.sd2))
df$x.sd = as.numeric(as.character(df$x.sd))
df_new <- df
df_new <- df[df['Group.1'] >= 6,]

df_new

ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  #geom_errorbar(aes(ymin=x.sd1, ymax=x.sd2,color=x.bo), width=0.2, size=.3) +
  geom_errorbar(aes(ymin=x.mn-1.96*x.sd, ymax=x.mn+1.96*x.sd,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  #coord_cartesian(ylim=c(1,10), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.8, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 30, 1))

p2<-ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.sd1, ymax=x.sd2,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  coord_cartesian(ylim=c(1,10), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Média do Melhor Custo Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.9, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  scale_x_continuous(breaks = seq(1, 30, 1))+
  ggtitle('b) Zoom da Figura a')

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

tikz('fig5.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Média do Melhor Custo Normalizado")
dev.off()









cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df) <- cols
df$ID = as.character(df$ID)
df$ID <- factor(df$ID)
cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")
new_df <- melt(df, id = c("ID"), measured = cols)


ggplot(new_df, aes(x = value, y= variable,  add = "jitter"))+
  geom_boxplot(alpha=0.7, colour = "black", fill="gray")+
  stat_summary(fun=mean, geom="point", shape=20, size=2, color="red", fill="red") +
  theme(legend.position="none")+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  ggtitle('a) Boxplot do Melhor Custo Encontrado')+
  labs(color = element_blank(), x="Custo Normalizado", y="Frequência")




























setwd('/home/pc-752828/Dev/results-search-master/outputs-normal')


data <- read.csv(file = 'output-n-norm.csv', sep = ',', header = T)


data <- read.csv(file = 'output-ecp-norm.csv', sep = ',', header = T)
data_norm <- data

get_df <- function(seed, data) {
  my_ite <- 10
  bo1 <- list()
  bo2 <- list()
  bo3 <- list()
  bo4 <- list()
  rs <- list()
  app <- list()
  seed_l <- list()
  
  for(i in levels(factor(data$name))) {
    r_bo1 <- data[data['name'] == i & data['bo'] == 'bo1' & data['ite'] == my_ite,][seed,]
    r_bo4 <- data[data['name'] == i & data['bo'] == 'bo4' & data['ite'] == my_ite,][seed,]
    r_bo3 <- data[data['name'] == i & data['bo'] == 'bo3' & data['ite'] == my_ite,][seed,]
    r_bo2 <- data[data['name'] == i & data['bo'] == 'bo5' & data['ite'] == my_ite,][seed,]
    r_rs <- data[data['name'] == i & data['bo'] == 'rs' & data['ite'] == my_ite,][seed,]
    bo1 <- append(bo1, levels(factor(r_bo1$best)))
    bo2 <- append(bo2, levels(factor(r_bo2$best)))
    bo3 <- append(bo3, levels(factor(r_bo3$best)))
    bo4 <- append(bo4, levels(factor(r_bo4$best)))
    rs <- append(rs, levels(factor(r_rs$best)))
    app <- append(app, i)
    seed_l <- append(seed_l, seed)
  }
  
  df <- cbind(bo1, bo2, bo3, bo4, rs, app)
  df <- data.frame(df)
  df$bo1 = as.numeric(as.character(df$bo1))
  df$bo2 = as.numeric(as.character(df$bo2))
  df$bo3 = as.numeric(as.character(df$bo3))
  df$bo4 = as.numeric(as.character(df$bo4))
  df$rs = as.numeric(as.character(df$rs))
  
  return(df)
}

df_1 <- get_df(1, data_norm)
df_2 <- get_df(2, data_norm)
df_3 <- get_df(3, data_norm)
df_4 <- get_df(4, data_norm)
df_5 <- get_df(5, data_norm)


df_5

df_norm <- rbind(df_1, df_2, df_3, df_4, df_5)

df <- df_norm

df

summary(df$bo1)
summary(df$bo2)
summary(df$bo3)
summary(df$bo4)
summary(df$rs)

ks.test(df_2$bo1, "pnorm")
ks.test(df_2$bo2, "pnorm")
ks.test(df_2$bo3, "pnorm")
ks.test(df_2$bo4, "pnorm")
ks.test(df_2$rs, "pnorm")

df <- df_5

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df) <- cols
df$ID = as.character(df$ID)
df$ID <- factor(df$ID)
cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")
new_df <- melt(df, id = c("ID"), measured = cols)
glimpse(new_df)
friedman.test(value ~ variable | ID, data = new_df)
colnames(new_df) <- c("ID", "Abordagem", "Best")
frdAllPairsSiegelTest (new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsConoverTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsNemenyiTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", 
          "BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search",
          "BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search",
          "BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")

cols <- c("<= 1","<= 1","<= 1","<= 1","<= 1",
          "<= 1,2","<= 1,2","<= 1,2","<= 1,2","<= 1,2",
          "<= 1,5","<= 1,5","<= 1,5","<= 1,5","<= 1,5",
          "<= 2","<= 2","<= 2","<= 2","<= 2")


list_id <- cols
list_id2 <- cols
list_value <- list(
  length(which(df$`BO-6rnd-EIdef`==1))/length(df$PB3Opt)*100,
  length(which(df$`BO-6rnd-EInova`==1))/length(df$PB3Opt)*100,
  length(which(df$`BO-6sel-EIdef`==1))/length(df$PB3Opt)*100,
  length(which(df$PB3Opt==1))/length(df$PB3Opt)*100,
  length(which(df$`Ranking Search`==1))/length(df$PB3Opt)*100,
  length(which(df$`BO-6rnd-EIdef`<=1.2))/length(df$PB3Opt)*100,
  length(which(df$`BO-6rnd-EInova`<=1.2))/length(df$PB3Opt)*100,
  length(which(df$`BO-6sel-EIdef`<=1.2))/length(df$PB3Opt)*100,
  length(which(df$PB3Opt<=1.2))/length(df$PB3Opt)*100,
  length(which(df$`Ranking Search`<=1.2))/length(df$PB3Opt)*100,
  length(which(df$`BO-6rnd-EIdef`<=1.5))/length(df$PB3Opt)*100,
  length(which(df$`BO-6rnd-EInova`<=1.5))/length(df$PB3Opt)*100,
  length(which(df$`BO-6sel-EIdef`<=1.5))/length(df$PB3Opt)*100,
  length(which(df$PB3Opt<=1.5))/length(df$PB3Opt)*100,
  length(which(df$`Ranking Search`<=2))/length(df$PB3Opt)*100,
  length(which(df$`BO-6rnd-EIdef`<=2))/length(df$PB3Opt)*100,
  length(which(df$`BO-6rnd-EInova`<=2))/length(df$PB3Opt)*100,
  length(which(df$`BO-6sel-EIdef`<=2))/length(df$PB3Opt)*100,
  length(which(df$PB3Opt<=2))/length(df$PB3Opt)*100,
  length(which(df$`Ranking Search`<=2))/length(df$PB3Opt)*100
)

list_id

list_value

df

df <- cbind(list_id, list_value)
df <- data.frame(df)
df


df <- cbind(list_id2, df)
df <- data.frame(df)
df

df$list_id = as.character(df$list_id)
df$list_value = as.numeric(as.character(df$list_value))
df$list_id2 = as.character(df$list_id2)

glimpse(df)

tikz('bar0-sol.tex')

ggplot(df) +
  geom_bar( aes(x=list_id, y=list_value, fill = list_id2), stat="identity", alpha=0.7, position = "dodge")+
  labs(color = element_blank(), x="Abordagem", y="Frequência da Solução ()")+
  theme_bw()+
  theme(legend.justification=c(1, 1),legend.position=c(.15, .95))+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        #axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  guides(fill=guide_legend(title="Solução"))+
  scale_y_continuous(breaks=seq(0,100,10))

dev.off()

seq(0,100,5)


p1<-ggplot(new_df, aes(x = value, y= variable,  add = "jitter"))+
  geom_boxplot(alpha=0.7, colour = "black", fill="gray")+
  stat_summary(fun=mean, geom="point", shape=20, size=2, color="red", fill="red") +
  theme(legend.position="none")+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  ggtitle('a) Boxplot do Melhor Custo Encontrado')+
  labs(color = element_blank(), x="Custo Normalizado", y="Frequência")

ylim1<- c(1, 500000)
p2<-p1 + coord_cartesian(xlim = ylim1) +
  ggtitle('b) Zoom da Figura a')

tikz('boxplot-test-cost.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Abordagem")
dev.off()











