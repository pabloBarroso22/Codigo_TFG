# Número de copias por plásmido
setwd("~/TFG/data/PCN")

CF13_table <- read.csv("CF13-pcn.csv")
CF12_table <- read.csv("CF12_pcn.csv")

# Boxplot NCP
ggplot(data = CF12_table, mapping= aes(x = Condition, y= median_ratio, col = p_contig)) +
  geom_point()

CF12_table %>%
  ggplot(aes(x = Condition, y = median_ratio)) +
  geom_boxplot(aes(col = Condition, fill = Condition), alpha = 0.2, width = 0.5) +
  geom_jitter(aes(col = Condition), size = 2) +
  geom_text(aes(label = Sample)) + 
  facet_wrap(~ p_contig, nrow = 1) +
  theme_bw(base_size = 18) +
  ylab("NCP") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Boxplot sólo pOXA-48 (Juntando CF12 y CF13)

CF <- rbind(CF12_table, CF13_table)

CF %>%
  filter(p_contig == "pOXA-48", Condition != "No pOXA-48", Condition != "No pOXA-48 – Anc", Condition != "pOXA-48 – Anc") %>%
  ggplot(aes(x = Condition, y = median_ratio)) +
  geom_boxplot(aes(col = Condition, fill = Condition), alpha = 0.2, width = 0.5) +
  geom_jitter(aes(col = Condition), size = 2) +
  facet_wrap(~ p_contig, nrow = 1) +
  theme_bw(base_size = 28) +
  ylab("Número de copias del plásmido (NCP)") + xlab("Condición") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), panel.grid = element_blank())

# Estadística para demostrar el aumento del NCP del pOXA-48 en presencia del antibiótico
CF_est <- CF %>%
  filter(p_contig == "pOXA-48", Condition != "No pOXA-48", Condition != "No pOXA-48 – Anc")

model <- lm(median_ratio~Condition, data = CF_est)
ggqqplot(model)  
shapiro.test(residuals(model))
bartlett.test(median_ratio~Condition, data = CF_est)

CF_est$Condition <- as.factor(CF_est$Condition)
CF_ANOVA <- aov(median_ratio~Condition, data = CF_est)
summary(CF_ANOVA)

Pairs <- glht(CF_ANOVA, linfct = mcp(Condition = "Tukey"))
summary(Pairs)


"kruskal.test(median_ratio~Condition, data = CF_est)

dunnTest(median_ratio~Condition, data = CF_est, method = ""bonferroni")


