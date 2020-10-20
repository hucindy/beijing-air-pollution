# Beijing Air Pollution

# load libraries
library(dplyr)
library(PerformanceAnalytics)
library(ggplot2)
library(ggpubr)
library(gridExtra)
library(jtools)
library(coefplot)

# load data
setwd("~/projects/beijing-air-pollution")
data <- read.csv("beijing_pm2.5_2010-2014.csv")
ggplot(data, aes(y=data$pm2.5,x=1)) + geom_violin(fill="#F8766D", width = 0.5) + 
  geom_boxplot(width = 0.1) + 
  stat_summary(fun=mean, geom="point", shape=20, size=4)+
  theme() + 
  labs(x="", y="pm2.5") +
  ggtitle("Boxplot and Density of PM2.5") + coord_flip() +
  annotate("text", x= 1.165, y=900, color="black",size = 4,
           label=paste("Min: ",fivenum(data$pm2.5)[1],"\n",
                       "Q1:",fivenum(data$pm2.5)[2],"\n",
                       "Median: ",fivenum(data$pm2.5)[3],"\n",
                       "Mean:",round(mean(na.omit(data$pm2.5)),1),"\n",
                       "Q3:",fivenum(data$pm2.5)[4],"\n",
                       "Max: ",fivenum(data$pm2.5)[5],"\n",
                       "NA:",sum(is.na(data$pm2.5)))) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background =
          element_blank(), axis.ticks.x=element_blank(), axis.ticks.y=element_blank(), 
        axis.text.y = element_blank())

data <- na.omit(data) %>% mutate_at(vars(No, year, month, day, hour, cbwd), funs(factor))
data <- data %>% mutate(cbwd=recode(cbwd, "cv"="SW"))

# correlation matrix
chart.Correlation(data %>% select(6:9,11:13), histogram=TRUE, pch=19)

# temperature vs dewpoint across time
grid.arrange(
  ggplot(data) +
    geom_smooth(aes(x=DEWP, y=TEMP,color=as.factor(year)))+
    ggtitle("TEMP vs. DEWP across year")+
    theme(legend.title=element_blank()),
  ggplot(data) +
    geom_smooth(aes(x=DEWP, y=TEMP,color=as.factor(day)))+
    ggtitle("TEMP vs. DEWP across day")+
    theme(legend.title=element_blank()),
  ggplot(data) +
    geom_smooth(aes(x=DEWP, y=TEMP,color=as.factor(hour)))+
    ggtitle("TEMP vs. DEWP across hour")+
    theme(legend.title=element_blank()),
  ncol=3
)

ggplot(data) +
  geom_smooth(aes(x=DEWP, y=TEMP))+
  facet_grid(.~month)+
  ggtitle("TEMP vs. DEWP across month")+
  theme(legend.title=element_blank())
# pressure vs dewpoint across time
grid.arrange(
  ggplot(data) +
    geom_smooth(aes(x=DEWP, y=PRES,color=as.factor(year)))+
    ggtitle("PRES vs. DEWP across year")+
    theme(legend.title=element_blank()),
  ggplot(data)+
    geom_smooth(aes(x=DEWP, y=PRES,color=as.factor(day)))+
    ggtitle("PRES vs. DEWP across day")+
    theme(legend.title=element_blank()),
  ggplot(data) +
    geom_smooth(aes(x=DEWP, y=PRES,color=as.factor(hour)))+
    ggtitle("PRES vs. DEWP across hour")+
    theme(legend.title=element_blank()),
  ncol=3
)

ggplot(data) +
  geom_smooth(aes(x=DEWP, y=PRES))+
  facet_grid(.~month)+
  ggtitle("PRES vs. DEWP across month")+
  theme(legend.title=element_blank())

# pressure vs dewpoint across time
grid.arrange(
  ggplot(data) +
    geom_smooth(aes(x=TEMP, y=PRES,color=as.factor(year)))+
    ggtitle("TEMP vs. PRES across year")+
    theme(legend.title=element_blank()),
  ggplot(data) +
    geom_smooth(aes(x=TEMP, y=PRES,color=as.factor(day)))+
    ggtitle("TEMP vs. PRES across day")+
    theme(legend.title=element_blank()),
  ggplot(data) +
    geom_smooth(aes(x=TEMP, y=PRES,color=as.factor(hour)))+
    ggtitle("TEMP vs. PRES across hour")+
    theme(legend.title=element_blank()),
  ncol=3
)

ggplot(data) +
  geom_smooth(aes(x=TEMP, y=PRES))+
  facet_grid(.~month)+
  ggtitle("TEMP vs. PRES across month")+
  theme(legend.title=element_blank())

# density plots
grid.arrange(
  ggplot(data, aes(x = pm2.5, fill = year)) + geom_density(alpha = 0.55) + ggtitle("PM2.5 density vs year") + theme(legend.position = "none"),
  ggplot(data, aes(x = pm2.5, fill = month)) + geom_density(alpha = 0.5) + ggtitle("PM2.5 density vs month")+ theme(legend.position = "none"),
  ggplot(data, aes(x = pm2.5, fill = day)) + geom_density(alpha = 0.5) + ggtitle("PM2.5 density vs day")+ theme(legend.position = "none"),
  ggplot(data, aes(x = pm2.5, fill = hour)) + geom_density(alpha = 0.5)+ ggtitle("PM2.5 density vs hour")+ theme(legend.position = "none"),
  ggplot(data, aes(x = pm2.5, fill = cbwd)) + geom_density(alpha = 0.5)+ ggtitle("PM2.5 density vs combined wind direction")+ theme(legend.position = "none"),
  ncol=3
)

# boxplot of pm2.5 vs year
grid.arrange(
  ggboxplot(data, x="year", y="pm2.5", color="year", legend = "none", outlier.size = 3, alpha=0.1) +
    stat_summary(fun=mean, geom="line", aes(group=1), color = "blue", size=1.1)+ylim(0,500)+
    ggtitle("PM2.5 vs year"),
  
  # boxplot of pm2.5 vs month 
  ggboxplot(data, x="month", y="pm2.5", color="month", legend="none", outlier.size=3, alpha=0.1) +
    stat_summary(fun=mean, geom="line", aes(group=1), color = "blue", size=1.1)+ ylim(0,500)+ 
    ggtitle("PM2.5 vs month"),
  
  ncol=2
)

# pm2.5 vs month across day and hour
grid.arrange(
  ggplot(data, aes(x=month, y=pm2.5)) + facet_wrap(day~.)+ geom_smooth(aes(as.numeric(as.character(month)), pm2.5))+ ggtitle("PM2.5 vs month across day"),
  
  ggplot(data, aes(x=month, y=pm2.5)) + facet_wrap(hour~.)+ geom_smooth(aes(as.numeric(as.character(month)), pm2.5))+ ggtitle("PM2.5 vs month across hour"),
  
  ncol=2
)

grid.arrange(
  # boxplot of pm2.5 vs cbwd 
  ggboxplot(data, x = "cbwd", y = "pm2.5", color = "cbwd", legend = "none", outlier.size = 3, alpha=0.1) +
    ggtitle("PM2.5 vs combined wind direction") + ylim(0,500),
  
  # pm2.5 vs month across cbwd 
  ggplot(data, aes(x=month, y=pm2.5)) + 
    geom_smooth(aes(as.numeric(as.character(month)), pm2.5, fill=cbwd))+ ggtitle("PM2.5 vs month across combined wind direction")+scale_x_continuous(breaks=c(1:12)),
  ncol=2
)

# multiple linear regression model
# log transformation on Y to normalize data
log10_pm2.5 <- log10(data$pm2.5+1)

# model 1: includes single variables and interactions
lm1 <- lm(log10_pm2.5~DEWP+TEMP+PRES+Iws+Is+Ir+year+month+day+hour+cbwd+
            year*DEWP+month*DEWP+day*DEWP+hour*DEWP+cbwd*DEWP+Iws*DEWP+Is*DEWP+Ir*DEWP+
            year*TEMP+month*TEMP+day*TEMP+hour*TEMP+cbwd*TEMP+Iws*TEMP+Is*TEMP+Ir*TEMP+
            year*PRES+month*PRES+day*PRES+hour*PRES+cbwd*PRES+Iws*PRES+Is*PRES+Ir*PRES+
            year*Iws+month*Iws+day*Iws+hour*Iws+cbwd*Iws+Is*Iws+Ir*Iws+
            year*Is+month*Is+day*Is+hour*Is+cbwd*Is+Ir*Iws+
            year*Ir+month*Ir+day*Ir+hour*Ir+cbwd*Ir, data=data)

# multiple R^2 = 0.6423
# model is too complicated
# remove statistically insignificant/unimportant variables:
# year, interactions with year
# hour, interactions with hour
# day, interactions with day
# Is, insteractions with Is
# DEWP*Is, DEWP*Ir, TEMP*Is, TEMP*Ir, month*Ir, Ir*cbwd, PRES*Ir, Iws*Ir, Iws*cbwd
# TEMP*Iws, PRES*Iws, DEWP*cbwd, PRES*cbwd, TEMP*cbwd

final_lm <- (lm(log10_pm2.5~
                  scale(DEWP)+ scale(TEMP)+ scale(PRES)+ scale(Iws)+ scale(Ir)+ month+ cbwd+
                  month*scale(DEWP)+ month*scale(TEMP)+ month*scale(PRES)+ month*scale(Iws)+
                  scale(Iws)*scale(DEWP),
                data=data))
# final model multiple R^2 = 0.5775
# model summary
summ(final_lm)

#coefficient plot
coefplot(final_lm)
#coef <- sort(summary(final_lm)$coefficients[,1])
# diagnostic plots
par(mfrow = c(1, 2))
plot(final_lm, which = 2)
plot(final_lm, which = 3)