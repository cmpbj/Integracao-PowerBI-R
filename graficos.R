# Códigos para geração dos gráficos no Power BI:
# Vamos criar 5 gráficos para serem utilizados com a ferrametna de integração entre o Power BI
# e o Script R
# Para utilizar os códigos, retire as linhas que contem o comando 'ggsave...'

# Evolução da Média Diária do Valor dos Combustíveis por Produto:

library(tidyverse)
library(tidyr)
library(ggplot2)
library(dplyr)
library(RColorBrewer)


df <- summarize(group_by(dataset, data_da_coleta, produto),
                media = mean(valor_de_venda))


graph <- ggplot(data = df, aes(x = data_da_coleta, y = round(media, 2),
                               fill = produto, label = round(media, 2))) +
  geom_bar(stat = "identity", position = "dodge", width = 0.40) +
  scale_y_continuous(limits = c(0, 10)) +
  geom_label(position = position_dodge(width = 1)) +
  ggtitle("Evolução da Média Mensal do Valor dos Combustíveis por Produto") +
  labs(x = "Data",
       y = "Média",
       fill = "Produto") +
  scale_colour_brewer(palette = "Dark2") +
  theme_bw() +
  theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5, color = "black"),
        axis.text = element_text(size = 11, colour = "black"),
        legend.text=element_text(size=11, color = "black"))
print(graph)
ggsave("evolucao_precos.png", graph,
       width = 10, height = 6, dpi = 500, units = "in", device = "png")

# Comparação do preço da gasolina em maio por região

df <- filter(dataset, produto == "Gasolina", data_da_coleta == "05-2022")


graph2 <- ggplot(data = df, aes(x = regiao_sigla, y = valor_de_venda,
                                fill = regiao_sigla)) +
  scale_y_continuous(limits = c(0, 10)) +
  geom_violin() +
  ggtitle("Comparação do Preço da Gasolina em Maio Por Região") +
  labs(x = "",
       y = "") +
  scale_fill_brewer(palette = "Dark2") +
  theme_bw() +
  theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5, color = "black"),
        axis.text = element_text(size = 11, color = "black"),
        legend.position = "none")

print(graph2)
ggsave("preco_gasolina_regiao.png", graph2,
       width = 10, height = 6, dpi = 500, units = "in", device = "png")

# Distribuição dos Valores de Venda por Produto

cor <- brewer.pal(3, "Dark2")

graph3 <- ggplot(data = dataset, aes(x = produto, y = valor_de_venda)) +
  geom_boxplot(fill = cor) +
  scale_y_continuous(limits = c(0, 10)) +
  ggtitle("Distribuição dos Valores de Venda por Produto") +
  labs(x = "Produto",
       y = "Valor de venda") +
  theme_bw() + 
  theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5, color = "black"),
        axis.text = element_text(size = 11, color = "black"))
print(graph3)
ggsave("distribuicao_precos.png", graph3,
       width = 10, height = 6, dpi = 500, units = "in", device = "png")

# Ranking dos 10 estados com a média da gasolina mais cara em maio de 2022

df_gasolina <- filter(dataset, produto == "Gasolina", 
                      data_da_coleta == "05-2022")

df_gasolina <- summarize(group_by(df_gasolina, estado_sigla),
                         media = mean(valor_de_venda))

df_ranking <- df_gasolina %>%
  arrange(desc(df_gasolina$media))

subset_ranking <- df_ranking[1:10,]

numero_cores <- 10
cores <- colorRampPalette(brewer.pal(8, "Dark2"))(numero_cores)

graph4 <- ggplot(data = subset_ranking, aes(x = reorder(estado_sigla, +media), y = media,
                                            fill = estado_sigla,
                                            label = round(media, 2))) +
  geom_bar(stat = "identity", width=.55) +
  geom_label() +
  scale_y_continuous(limits = c(0, 10)) +
  ggtitle("Estados com a Média da Gasolina mais Cara em Maio") +
  labs(x = "UF",
       y = "Média") +
  scale_fill_manual(values = cores) +
  theme_bw() + 
  theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5, color = "black"),
        axis.text = element_text(size = 11, color = "black"),
        legend.position = "none") +
  coord_flip()

print(graph4)

ggsave("ranking_estados.png", graph4,
       width = 10, height = 6, dpi = 500, units = "in", device = "png")

# Ranking das cidades com a média da gasolina mais cara em maio de 2022

df_gasolina_muni <- filter(dataset, produto == "Gasolina", 
                           data_da_coleta == "05-2022")

df_gasolina_muni <- summarize(group_by(df_gasolina_muni, estado_sigla, municipio),
                              media = mean(valor_de_venda))

df_ranking_muni <- df_gasolina_muni %>%
  arrange(desc(df_gasolina_muni$media))

subset_ranking_muni <-df_ranking_muni[1:10,]

graph5 <- ggplot(data = subset_ranking_muni, aes(x = reorder(municipio, +media), y = media, fill = estado_sigla,
                                                 label = round(media, 2))) +
  geom_bar(stat = "identity", width=.50) + 
  geom_label() +
  scale_y_continuous(limits = c(0, 10)) +
  ggtitle("Cidades com a Média da Gasolina mais Cara em Maio") +
  labs(x = "Cidades",
       y = "Média",
       fill = "Estado") +
  scale_colour_brewer(palette = "Dark2") +
  theme_bw() + 
  theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5, color = "black"),
        axis.text = element_text(size = 11, color = "black"),
        legend.text=element_text(size=11, color = "black")) +
  coord_flip()

print(graph5)

ggsave("ranking_cidades.png", graph5,
       width = 10, height = 6, dpi = 500, units = "in", device = "png")
