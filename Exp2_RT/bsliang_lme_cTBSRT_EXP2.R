#Sys.setlocale("LC_ALL","Chinese")
setwd("E:/cTBS_HDDM_RTanalyses")

install.packages("lme4")
install.packages("lmerTest")

library(lme4)
library(lmerTest)

## Exp 2 iTBS

# Left iTBS, consonant, quiet
D <- read.csv("Exp2_iTBS_D_L_C_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Left iTBS, consonant, noisy
D <- read.csv("Exp2_iTBS_D_L_C_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Left iTBS, tone, quiet
D <- read.csv("Exp2_iTBS_D_L_T_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Left iTBS, tone, noisy
D <- read.csv("Exp2_iTBS_D_L_T_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right iTBS, consonant, quiet - *
D <- read.csv("Exp2_iTBS_D_R_C_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right iTBS, consonant, noisy
D <- read.csv("Exp2_iTBS_D_R_C_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right iTBS, tone, quiet + *
D <- read.csv("Exp2_iTBS_D_R_T_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right iTBS, tone, noisy + ***
D <- read.csv("Exp2_iTBS_D_R_T_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right iTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

## Exp 2 cTBS

# Left cTBS, consonant, quiet
D <- read.csv("Exp2_cTBS_D_L_C_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Left cTBS, consonant, noisy
D <- read.csv("Exp2_cTBS_D_L_C_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Left cTBS, tone, quiet
D <- read.csv("Exp2_cTBS_D_L_T_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Left cTBS, tone, noisy
D <- read.csv("Exp2_cTBS_D_L_T_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Left cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right cTBS, consonant, quiet
D <- read.csv("Exp2_cTBS_D_R_C_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right cTBS, consonant, noisy
D <- read.csv("Exp2_cTBS_D_R_C_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right cTBS, tone, quiet
D <- read.csv("Exp2_cTBS_D_R_T_Q_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)

# Right cTBS, tone, noisy
D <- read.csv("Exp2_cTBS_D_R_T_N_rawdata.csv")
D$turn_type<-factor(D$turn_type,levels=c("Sham","Right cTBS"))
D_m <- lmer(rt ~ 1 + turn_type + (1|subj_idx), data=D)
summary(D_m)