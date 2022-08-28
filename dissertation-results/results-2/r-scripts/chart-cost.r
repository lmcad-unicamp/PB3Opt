setwd('/home/pc-752828/Dev/results-search-master/outputs-ecp')

library(ggplot2)
library(dplyr)
library(extrafont)
library(dplyr)
library('EnvStats')
library("tikzDevice")
library(survJamda)

data_norm <- read.csv(file = 'output-ecp-norm-cost.csv', sep = ',', header = T)
data_new <- data
value <- function(x, name) {
  mym =  gm(x, na.rm = TRUE)
  #mym = mean(log(x))
  #mysd = geoSD(x, na.rm = FALSE, sqrt.unbiased = TRUE)
  mysd <- ci.gm(x)
  print(mysd)
  print(mym)
  return(c(mn = mym, sd = mysd, bo = name))
}

data_f<-data.frame(data_new[data_new['bo'] == 'bo1',])
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

df <- rbind(bo1)

#View(df)

df$x.sd2


df$x.mn = as.numeric(as.character(df$x.mn))
df$Group.1 = as.numeric(as.character(df$Group.1))
df$x.sd1 = as.numeric(as.character(df$x.sd1))
df$x.sd2 = as.numeric(as.character(df$x.sd2))
df_new <- df

ggplot(data=df_new, aes(x=Group.1, y=x.mn, group=x.bo)) +
  geom_errorbar(aes(ymin=x.sd1, ymax=x.sd2,color=x.bo), width=0.2, size=.3) +
  geom_line(aes(color=x.bo), size=1) +
  geom_vline(xintercept=6, linetype="dashed", size=1)+
  #coord_cartesian(ylim=c(1,2), xlim=c(1,30))+
  labs(color = element_blank(), x="Iteração", y="Custo Acumulado Normalizado")+
  theme(legend.justification=c(1, 1),legend.position=c(.4, .9),legend.title=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        #axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
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

tikz('fig2-cost.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Média do Melhor Custo Normalizado")
dev.off()







get_df <- function(seed) {
  my_ite <- 10
  bo1 <- list()
  bo2 <- list()
  bo3 <- list()
  bo4 <- list()
  rs <- list()
  app <- list()
  
  for(i in levels(factor(data$name))) {
    #r_my <- data[data['name'] == i & data['bo'] == 'bo4' & data['target'] == 2 & data['ite'] == my_ite,][seed,]
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
  }
  
  df<-cbind(bo1, bo2, bo3, bo4, rs, app)
  df <- data.frame(df)
  df$bo1 = as.numeric(as.character(df$bo1))
  df$bo2 = as.numeric(as.character(df$bo2))
  df$bo3 = as.numeric(as.character(df$bo3))
  df$bo4 = as.numeric(as.character(df$bo4))
  df$rs = as.numeric(as.character(df$rs))
  df$app = as.character(df$app)
  df$app <- factor(df$app)
  return(df)
}

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")

df_1 <- get_df(1)
df_2 <- get_df(2)
df_3 <- get_df(3)
df_4 <- get_df(4)
df_5 <- get_df(5)

write.csv(x=df_1,file="teste.csv", row.names = FALSE)

par(mfrow=c(2, 3))

df <- df_5

boxplot(df$bo1,df$bo2, df$bo3, df$bo4, df$rs, xlab = "Abordagem", ylab = "Custo Normalizado", outline = FALSE)
grid(nx=16, ny=16)
boxplot(df$bo1,df$bo2, df$bo3, df$bo4, df$rs, add = TRUE,
        xlab = "Abordagem", 
        ylab = "Custo Normalizado",
        names=c('A1', 'A2', 'A3', 'A4', 'A5'))
legend("topright", inset=c(-0.2,0),legend=c("A1 - BO-6rnd-EIdef",
                                            "A2 - BO-6rnd-EInova",
                                            "A3 - BO-6sel-EIdef",
                                            "A4 - BO3Opt",
                                            "A5 - Ranking Search"),
       fill=c("white","white","white","white","white"), bty = "n")


df$bo1















































data_norm <- read.csv(file = 'output-ecp-norm-cost.csv', sep = ',', header = T)

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



summary(df_1$bo4)
summary(df_1$rs)

df_norm <- rbind(df_1, df_2, df_3, df_4)
df_def <- rbind(df_1, df_2, df_3, df_4, df_5)

df <- df_norm
df <- df_1


cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df) <- cols
df$ID = as.character(df$ID)
df$ID <- factor(df$ID)
cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")
new_df <- melt(df, id = c("ID"), measured = cols)
glimpse(df)
friedman.test(value ~ variable | ID, data = new_df)
colnames(new_df) <- c("ID", "Abordagem", "Best")

df


new_df %>% group_by(Abordagem) %>%
  get_summary_stats(Best, type = "median_iqr")



frdAllPairsSiegelTest (new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsConoverTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsNemenyiTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")

p1<-ggplot(new_df, aes(x = value, y= variable,  add = "jitter"))+
  geom_boxplot(alpha=0.7, colour = "black", fill="gray")+
  stat_summary(fun=mean, geom="point", shape=20, size=2, color="red", fill="red") +
  theme(legend.position="none")+
  theme(panel.background = element_rect(fill = 'white', colour = 'gray'),
        panel.grid.major = element_line(color = 'light gray'),
        panel.grid.minor = element_line(color = 'light gray'),
        axis.title.y=element_blank(),
        axis.text.y = element_text(size=8))+
  ggtitle('a) Boxplot do Custo Acumulado')+
  labs(color = element_blank(), x="Custo Acumulado Normalizado", y="Frequência")
ylim1<- c(1, 3000)
p2<-p1 + coord_cartesian(xlim = ylim1) +
  ggtitle('b) Zoom da Figura a')

tikz('boxplot-cost.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Abordagem")
dev.off()

