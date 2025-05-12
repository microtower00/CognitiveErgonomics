
# Read the data
# D <- read.csv2("C:/Users/Usuario/OneDrive/Documents/Universita di Trento/Second Semester/RM - Quantitative/FP/dataCSV.csv")
D = cleaned_data


# 0. PREPARATION OF DATASET.
head(D)

D$Gender <- as.factor(D$Gender)
D$Education <- as.factor(D$Education)
D$Employment <- as.factor(D$Employment)
D$F.Chat <- as.factor(D$F.Chat)
D$F.Google <- as.factor(D$F.Google)

D$AVERAGE_CHAT_TRUST <- rowMeans(D[, c("AVG.MCT", "AVG.TCT")], na.rm = TRUE)
D$AVERAGE_GOOGLE_TRUST <- rowMeans(D[, c("AVG.MGT", "AVG.TGT")], na.rm = TRUE)
D$AVERAGE_CHAT_PREFERENCE <- rowMeans(D[, c("AVG.MCP", "AVG.TCP")], na.rm = TRUE)
D$AVERAGE_GOOGLE_PREFERENCE <- rowMeans(D[, c("AVG.MGP", "AVG.TGP")], na.rm = TRUE)

D$AgeCategory = ifelse(D$Age >= 18 & D$Age <= 26, 1, ifelse(D$Age >= 27, 2, NA))
D$AgeCategory = as.factor(D$AgeCategory)

summary(D)


# 1. ANOVA MAIN ANALYSIS
boxplot(D$AVG.MGT,D$AVG.MCT,D$AVG.TGT,D$AVG.TCT, names=c("MG","MC","TG","TC"), ylab="Trustability index")


Tind <- c(D$AVG.MGT,D$AVG.TGT,D$AVG.MCT,D$AVG.TCT)
SE <- as.factor(c(rep("G",188),rep("C",188)))
Type <- as.factor(c(rep("S",94),rep("NS",94),rep("S",94),rep("NS",94)))

library(car)


boxplot(Tind ~ SE*Type,ylab="Trust Index") 
Tindex <- lm(Tind ~ SE + Type + SE*Type) 
Anova(Tindex) 


# 2. DEMOGRAPHIC DIFFERENCES FOR SEARCH ENGINES

# A. CHAT-GPT

# GENDER --> T-TEST
# Hyp: no difference
t.test(D$AVERAGE_CHAT_TRUST[D$Gender == 1],
       D$AVERAGE_CHAT_TRUST[D$Gender == 2],
       var.equal = TRUE)
# p-value = 0.3954

# AGE --> T-TEST
# Hyp: younger more trust
boxplot(D$AVERAGE_CHAT_TRUST[D$AgeCategory == 1],D$AVERAGE_CHAT_TRUST[D$AgeCategory == 2])
t.test(D$AVERAGE_CHAT_TRUST[D$AgeCategory == 1], # young
       D$AVERAGE_CHAT_TRUST[D$AgeCategory == 2], # old
       var.equal = TRUE,
       alternative = "greater")
# p-value = 0.1094


# ED. LEVEL --> ANOVA
# Hyp: no difference
boxplot(D$AVERAGE_CHAT_TRUST ~ D$Education)
LMEdChat = lm(D$AVERAGE_CHAT_TRUST ~ D$Education)
Anova(LMEdChat)
# p-value = 0.1905


# EMPLOYMENT --> ANOVA
# Hyp: students trust more
boxplot(D$AVERAGE_CHAT_TRUST ~ D$Employment)
LMEmpChat = lm(D$AVERAGE_CHAT_TRUST ~ D$Employment)
Anova(LMEdChat)
# p-value = 0.042

# post-hoc analysis for 1 (unemployed) vs 2 (student) and 1 vs 3 (employed)
t.test(D$AVERAGE_CHAT_TRUST[D$Employment == 1],
       D$AVERAGE_CHAT_TRUST[D$Employment == 2],
       var.equal = TRUE)
# p-value = 0.09785

t.test(D$AVERAGE_CHAT_TRUST[D$Employment == 1],
       D$AVERAGE_CHAT_TRUST[D$Employment == 3],
       var.equal = TRUE)
# p-value = 0.018



# B. GOOGLE SEARCH

# GENDER --> T-TEST
# Hyp: no difference
t.test(D$AVERAGE_GOOGLE_TRUST[D$Gender == 1],
       D$AVERAGE_GOOGLE_TRUST[D$Gender == 2],
       var.equal = TRUE)
# p-value = 0.4673

# AGE --> T-TEST
# Hyp: no difference
boxplot(D$AVERAGE_GOOGLE_TRUST[D$AgeCategory == 1],D$AVERAGE_GOOGLE_TRUST[D$AgeCategory == 2])
t.test(D$AVERAGE_GOOGLE_TRUST[D$AgeCategory == 1],
       D$AVERAGE_GOOGLE_TRUST[D$AgeCategory == 2],
       var.equal = TRUE)

# p-value = 0.03777

# ED. LEVEL --> ANOVA
# Hyp: no difference
boxplot(D$AVERAGE_GOOGLE_TRUST ~ D$Education)
LMEdGoogle = lm(D$AVERAGE_GOOGLE_TRUST ~ D$Education)
Anova(LMEdGoogle)
# p-value = 0.3557


# EMPLOYMENT --> ANOVA
# Hyp: no difference
boxplot(D$AVERAGE_GOOGLE_TRUST ~ D$Employment)
LMEmpGoogle = lm(D$AVERAGE_GOOGLE_TRUST ~ D$Employment)
Anova(LMEmpGoogle)
# p-value = 0.413



# 3. LINEAR REGRESSION TO SEE IF PREFERENCE AND TRUST ARE CORRELATED

# CHAT-GPT
lmCHAT = lm(D$AVERAGE_CHAT_PREFERENCE ~  D$AVERAGE_CHAT_TRUST)
summary(lmCHAT)
plot(D$AVERAGE_CHAT_PREFERENCE ~ D$AVERAGE_CHAT_TRUST)
abline(lmCHAT)


# Coefficients:
#  Estimate Std. Error t value Pr(>|t|)    
# (Intercept)          -0.62411    0.28179  -2.215   0.0292 *  
#  D$AVERAGE_CHAT_TRUST  1.20590    0.08396  14.363   <2e-16 ***


# CHAT-GPT
lmGOOGLE = lm(D$AVERAGE_GOOGLE_PREFERENCE ~  D$AVERAGE_GOOGLE_TRUST)
summary(lmGOOGLE)
plot(D$AVERAGE_GOOGLE_PREFERENCE ~ D$AVERAGE_GOOGLE_TRUST)
abline(lmGOOGLE)



