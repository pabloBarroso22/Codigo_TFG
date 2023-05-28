setwd("~/TFG/data/Curvas")

library(tidyverse)
library(readxl)
library(lattice)
library(deSolve)
library(growthrates)
library(dplyr)
library(gridExtra)
library(caTools)
library(tidyr)
library(flux)
library(ggrepel)
library(ggsci)
library(ggplot2)
library(ggrepel)

path_to_txt= "txt/"
path_to_Growthrates="GrowthRates_results/"
path_to_output="Output/"
Rosett_Alfonso <- read.delim("Rosett/Rosett_Alfonso")

file.list <- list.files(path =path_to_txt, full.names = F)
df.list <- lapply(paste0(path_to_txt, file.list), 
                  function(x)read.delim(x, header=T, nrows=133, dec=","))
                  
attr(df.list, "names") <- file.list
df <- bind_rows(df.list, .id = "id") %>% mutate(Time=rep(seq(0, (133*10)-10, 10),35))


df_test<-df %>% 
  select( -`T..Optical.Density.600`) %>% gather(-Time,-id,  key = Well, value = OD ) %>% 
  separate(id, into=c("Plate", "Day"), remove = F) 

write.table(df_test, file=paste0(path_to_output, "curves_alf"))


curve_data <- df_test %>% 
  left_join(Rosett_Alfonso %>% mutate(Plate=as.character(Plate), 
                                        Day=as.character(Day),
                                        Well=as.character(Well))) %>% 
  mutate(Day=as.numeric(Day))

curve_data <- curve_data %>% 
  filter(
         Sample!="-") %>% 
  mutate(OD=as.numeric(OD))

# Curves Citrobacter CF12

curve_data %>% 
  filter(Sample=="CF12") %>%
  ggplot(aes(y=OD, x=Time, color=Replicate, fill=Replicate, group=Replicate)) +
  geom_line()+
  geom_hline(yintercept=1, linetype="dotted", color="darkgrey")+
  facet_grid(~Plasmid~Antibiotic~Day)+
  labs(title="CF12")+
  theme_bw()+
  theme(panel.background = element_blank(), panel.grid = element_blank(), 
        aspect.ratio = 1, 
        #legend.position = "none",
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 45,  hjust=1))

# Curves Citrobacter CF13

curve_data %>% 
  filter(Sample=="CF13") %>%
  ggplot(aes(y=OD, x=Time, color=Replicate, fill=Replicate, group=Replicate)) +
  geom_line()+
  geom_hline(yintercept=1, linetype="dotted", color="darkgrey")+
  facet_grid(~Plasmid~Antibiotic~Day)+
  labs(title="CF13")+
  theme_bw()+
  theme(panel.background = element_blank(), panel.grid = element_blank(), 
        aspect.ratio = 1, 
        #legend.position = "none",
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 45,  hjust=1))

# Curves Klebsiella K25

curve_data %>% 
  filter(Sample=="K25") %>%
  ggplot(aes(y=OD, x=Time, color=Replicate, fill=Replicate, group=Replicate)) +
  geom_line()+
  geom_hline(yintercept=1, linetype="dotted", color="darkgrey")+
  facet_grid(~Plasmid~Antibiotic~Day)+
  labs(title="K25")+
  theme_bw()+
  theme(panel.background = element_blank(), panel.grid = element_blank(), 
        aspect.ratio = 1, 
        #legend.position = "none",
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 45,  hjust=1))

if (file.exists(paste0(path_to_Growthrates, "GrowthRates_results"))){
 Growthrate_results<-read.table((paste0(path_to_Growthrates, "GrowthRates_results")), header=T) %>% filter(r2>0.95)

} else{
manysplits<- all_easylinear(OD~Time | Plasmid + Sample +  Antibiotic + Replicate + Day + Project + Species,
                            data=anti_join(curve_data, curve_data %>% filter(Sample=="CF13" & Day==13 & Antibiotic=="NO" & Plasmid=="NO")))
write.table(results(manysplits), paste0(path_to_Growthrates, "GrowthRates_results"))

Growthrate_results<-results(manysplits) %>% filter(r2>0.95)
}

data_analysed<- curve_data %>% group_by(Plasmid,Sample, Day,  Replicate, Antibiotic, Project, Species) %>% 
  group_modify(~ as.data.frame(flux::auc(.x$Time, .x$OD))) %>%
  mutate(AUC=`flux::auc(.x$Time, .x$OD)`) %>% 
  select(-`flux::auc(.x$Time, .x$OD)`)%>% 
  ungroup() 

data_analysed_2<- data_analysed %>% 
  left_join(curve_data %>% 
  group_by(Plasmid, Sample, Day, Antibiotic, Project, Replicate, Species) %>% 
  summarise(ODmax=max(OD, na.rm = T)))
  
data<-data_analysed_2 %>% 
  mutate(Replicate_cntrl=Replicate, 
         Replicate=as.numeric(Replicate)-1) %>% 
  left_join(Growthrate_results)

data<-data %>% 
  filter(Day==3) %>% #Este es el día que usamos como referencia
  group_by(Plasmid, Sample, Day, Replicate, Antibiotic, Project, Species) %>% 
  summarise(Vmax_day3=mumax, 
            lag_day3=lag, 
            AUC_day3=AUC, 
            ODmax_day3=ODmax) %>% 
 left_join(data, by=c("Plasmid", "Sample", "Replicate", "Antibiotic", "Project", "Species")) %>% 
  select(-Day.x) %>% 
  mutate(Day=Day.y) %>% 
  mutate(Treatment=ifelse(Plasmid=="YES" & Antibiotic=="YES", "Plasmid+Ab",
                                              ifelse(Plasmid=="YES" & Antibiotic=="NO", "Plasmid", 
                                                     ifelse(Plasmid=="NO" & Antibiotic=="NO", "Control", "problems"))))
#Evolution AUC, OD, Vmax, lag

data %>% 
  filter(ODmax>0.2, Sample == "CF12" | Sample == "CF13" | Sample == "K25") %>%
  ggplot(aes(y=AUC, x=Day, color=Treatment, shape=as.factor(Replicate), group=interaction(Treatment))) +
  geom_jitter(width = 0.1, size=1)+
  geom_smooth(method=lm)+
  facet_wrap(~Sample, scales = "free_x")+
  scale_y_continuous(limits=c(500,1500))+
  labs(title="AUC")+
  theme_bw()+
  theme(panel.background = element_blank(), panel.grid = element_blank(), 
        aspect.ratio = 1, 
        #legend.position = "none",
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 45,  hjust=1))
data %>% 
  filter(ODmax>0.2, Sample == "CF12" | Sample == "CF13" | Sample == "K25") %>%
  ggplot(aes(y=ODmax_day3, x=Day, color=Treatment, shape=as.factor(Replicate), group=interaction(Treatment))) +
  geom_jitter(width = 0.1, size=1)+
  geom_smooth(method=lm)+
  facet_wrap(~Sample, scales = "free_x")+
  scale_y_continuous(limits=c(500,1500))+
  labs(title="AUC")+
  theme_bw()+
  theme(panel.background = element_blank(), panel.grid = element_blank(), 
        aspect.ratio = 1, 
        #legend.position = "none",
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 45,  hjust=1))
