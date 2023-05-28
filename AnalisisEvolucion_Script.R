# IS Boxplot
setwd("~/TFG/data/BRESEQ")

IS_Mv <- read.csv("IS_Sample.csv")

IS_Mv %>%
  ggplot(aes(x=Condición, y=IS)) +
  geom_boxplot(aes(col = Condición, fill = Condición), alpha = 0.2, width = 0.5) +
  geom_jitter(aes(col = Condición), size = 2) +
  theme_bw(base_size = 28) + ylab("Número de Secuencias de Inserción") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(panel.grid = element_blank())

#EStadística IS movimientos

model <- lm(IS~Condición, data = IS_Mv)
ggqqplot(model)  
shapiro.test(residuals(model))
bartlett.test(IS~Condición, data = IS_Mv)
leveneTest(IS~Condición), data = IS_Mv)

IS_Mv$Condición <- as.factor(IS_Mv$Condición)

IS_Mv_ANOVA <- aov(IS~Condición, data = IS_Mv)
summary(IS_Mv_ANOVA)

Pairs <- glht(IS_Mv_ANOVA, linfct = mcp(Condición = "Tukey"))
summary(Pairs)


# Mutaciones S, NS, I

SNP <- read.csv("IS%SNPs_CF12&CF13.csv")

SNP$Mutación <- factor(SNP$Mutación, levels = c("SNP", "NU"))

SNP %>%
  ggplot(aes(x=Mutación, y=N, col= TIPO, fill=TIPO)) +
  geom_bar(stat= "identity") +
  facet_wrap(~Condición) + 
  theme_bw(base_size = 28) + ylab("Número de Eventos") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  theme(panel.grid = element_blank())
