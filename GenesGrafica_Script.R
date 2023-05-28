# Región mínima Duplicaciones CF12 y CF13 (la misma región)
setwd("~/TFG/data/DUPLICATION")

GenesRM <- read.csv("Analisis_funcional_regiónmínima.csv", sep ="\t")

GenesRM %>%
  ggplot(aes(x=1, y=Genes, col=Función, fill=Función)) +
  geom_bar(stat="identity") +
  theme_bw(base_size = 28) + ylab("Número de Genes") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(panel.grid = element_blank())
  