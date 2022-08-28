setwd('/home/pc-752828/Dev/results-search-master/outputs-normal')

library(ggplot2)
library(reshape2)
library(ggstatsplot)
library(tcltk)
library(rstatix)
library(PMCMRplus)
library(pgirmess)

data_norm <- read.csv(file = 'output-n-norm.csv', sep = ',', header = T)
data_def <- read.csv(file = 'output-n-price.csv', sep = ',', header = T)

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

df_1 <- get_df(1, data_def)
df_2 <- get_df(2, data_def)
df_3 <- get_df(3, data_def)
df_4 <- get_df(4, data_def)
df_5 <- get_df(5, data_def)

df_norm <- rbind(df_1, df_2, df_3, df_4, df_5)
df_def <- rbind(df_1, df_2, df_3, df_4, df_5)

df <- df_norm


summary(df$bo1)
summary(df$bo2)
summary(df$bo3)
summary(df$bo4)
summary(df$rs)

df_1

ks.test(df_5$bo1, "pnorm")
ks.test(df_5$bo2, "pnorm")
ks.test(df_5$bo3, "pnorm")
ks.test(df_5$bo4, "pnorm")
ks.test(df_5$rs, "pnorm")

df <- df_1

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df) <- cols
df$ID = as.character(df$ID)
df$ID <- factor(df$ID)
cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")
new_df <- melt(df, id = c("ID"), measured = cols)
glimpse(new_df)
friedman.test(value ~ variable | ID, data = new_df)

new_df %>% friedman_effsize(value ~ variable | ID)



colnames(new_df) <- c("ID", "Abordagem", "Best")
frdAllPairsSiegelTest (new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsConoverTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")
frdAllPairsNemenyiTest(new_df$Best, new_df$Abordagem, new_df$ID, p.adjust = "bonferroni")


new_df %>% group_by(Abordagem) %>%
  get_summary_stats(Best, type = "median_iqr")




list_id <- cols
list_value <- list(
length(which(df$`BO-6rnd-EIdef`==1))/length(df$PB3Opt),
length(which(df$`BO-6rnd-EInova`==1))/length(df$PB3Opt),
length(which(df$`BO-6sel-EIdef`==1))/length(df$PB3Opt),
length(which(df$PB3Opt==1))/length(df$PB3Opt),
length(which(df$`Ranking Search`==1))/length(df$PB3Opt)
)

df <- cbind(list_id, list_value)
df <- data.frame(df)
df

df$list_id = as.character(df$list_id)
df$list_value = as.numeric(as.character(df$list_value))

glimpse(df)

tikz('bar1.tex')

ggplot(df) +
  geom_bar( aes(x=list_id, y=list_value), stat="identity", alpha=0.7)+
  labs(color = element_blank(), x="Abordagem", y="Frequência da Melhor Solução ()")+
  theme_bw()

dev.off()

write.csv(x=df_1,file="teste-new.csv", row.names = FALSE)








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

ylim1<- c(1, 3)
p2<-p1 + coord_cartesian(xlim = ylim1) +
  ggtitle('b) Zoom da Figura a')


tikz('boxplot.tex')
grid.arrange(p1, p2, nrow = 2, ncol=1, top="", left="Abordagem")

dev.off()









par(mfrow=c(2, 3))

boxplot(df$bo1,df$bo2, df$bo3, df$bo4, df$rs, xlab = "Abordagem", ylab = "Custo Normalizado", outline = FALSE)
grid(nx=16, ny=16)
boxplot(df$bo1,df$bo2, df$bo3, df$bo4, df$rs, 
        xlab = "Abordagem", 
        ylab = "Custo Normalizado",
        names=c('A1', 'A2', 'A3', 'A4', 'A5'))
legend("topright", inset=c(-0.2,0),legend=c("A1 - BO-6rnd-EIdef",
                                            "A2 - BO-6rnd-EInova",
                                            "A3 - BO-6sel-EIdef",
                                            "A4 - BO3Opt",
                                            "A5 - Ranking Search"),
       fill=c("white","white","white","white","white"), bty = "n")