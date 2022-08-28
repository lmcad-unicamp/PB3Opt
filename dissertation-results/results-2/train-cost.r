setwd('/home/pc-752828/Dev/results-search-master/outputs-normal')

data_norm <- read.csv(file = 'output-n-price.csv', sep = ',', header = T)

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

summary(df_norm$bo4)
summary(df_norm$rs)

df_norm <- rbind(df_1, df_2, df_3, df_4, df_5)
df <- df_norm
df <- df_5

cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search", "ID")
colnames(df) <- cols
df$ID = as.character(df$ID)
df$ID <- factor(df$ID)
cols <- c("BO-6rnd-EIdef","BO-6rnd-EInova","BO-6sel-EIdef", "PB3Opt", "Ranking Search")
new_df <- melt(df, id = c("ID"), measured = cols)
friedman.test(value ~ variable | ID, data = new_df)

new_df %>% friedman_effsize(value ~ variable | ID)


colnames(new_df) <- c("ID", "Abordagem", "Best")

new_df %>% group_by(Abordagem) %>%
  get_summary_stats(Best, type = "median_iqr")




