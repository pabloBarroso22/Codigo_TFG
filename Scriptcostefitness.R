#Análisis del coste en Citrobacter Freundii
setwd("~/TFG/data/Curvas")

# AREA BAJO LA CURVA A DIA 1 (CF12 Y CF13) - COSTE DEL PLÁSMIDO
PCCF12 <- read.csv("PlasmidCostCF12.csv")
PCCF13 <- read.csv("PPlasmidCost_CF13.csv")

PCCF <- rbind(PCCF12, PCCF13)

# AREA BAJO LA CURVA A DIA 1 Y 15 (CF12 Y CF13) - INCREMENTO DEL FITNESS EN 25 DÍAS 
CF12CF13 <- read.csv("CF1_15.csv") #cf12y13juntos

CF12CF13 %>%
  ggplot(aes(x = Sample, y = AUC_Relative)) +
  geom_boxplot(aes(col = Condición, fill = Condición), alpha = 0.2, width = 0.5) +
  geom_jitter(aes(col = Condición ), size = 2) +
  theme_bw(base_size = 28) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(panel.grid = element_blank())


#Análisis day1 - day15

CF12CF13 %>% 
  ggplot(aes(x = as.factor(Day.y), y = AUC)) +
  geom_boxplot(aes(col = Condición, fill = Condición), alpha = 0.2, width = 0.5) +
  theme_bw(base_size = 28) + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  ylim(900,1400)+ theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  ylab("Fitness (ABC)") +
  xlab("Dia")

#Estadística incremento fitness tras 15 días

model <- lm(AUC~as.factor(Day.y), data = CF12CF13)
ggqqplot(model)  
shapiro.test(residuals(model))
bartlett.test(AUC~as.factor(Day.y), data = CF12CF13)

kruskal.test(AUC~as.factor(Day.y), data = CF12CF13)

#Coste del plásmido CF12 y CF13 Separado
PCCF%>%
  filter(Condición != "pOXA-48+AAC") %>%
  ggplot(aes(x = Sample, y = AUC_Relative)) +
  geom_boxplot(aes(col = Condición, fill = Condición), alpha = 0.2, width = 0.5) +
  theme_bw(base_size = 28) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  ylab("ABC relativa a las bacterias sin pOXA-48") + xlab("Cepa") + 
  geom_hline(yintercept = 1.0, linetype ="dashed", color = "lightgrey", size = 1) +
  ylim(0.8,1.3) 


