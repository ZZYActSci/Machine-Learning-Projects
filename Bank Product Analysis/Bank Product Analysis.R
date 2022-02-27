library(tidyverse)
library(ggplot2)
prefix <- '/Users/ziyezhang/Desktop/MMA/MGSC 661/final project/bank-additional/'

df <- read.table(paste(prefix,'bank-additional-full.csv',sep=''),header=TRUE,sep=";")

summary(df)

# check missing values
df %>% summarise_all(list(~sum(is.na(.))))

# data cleaning
df <- df[(df$education!='illiterate') & (df$default!='yes') ,]
# data used in classification
# df <- df[(df$education!='illiterate') & (df$default!='yes') ,]

df[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], as.factor)

# Create a histogram for duration
# this attribute highly affects the output target (e.g., if duration=0 then y='no'). 
# Yet, the duration is not known before a call is performed. 
# Also, after the end of the call y is obviously known. 
# Thus, this input is discarded
ggplot(df[df$duration<=2000 & df$duration>=500,], aes(x = duration,fill=y)) +
  geom_histogram(binwidth = 200, col = "black")+scale_fill_viridis_d()

df <- df %>% dplyr::select(-c('duration'))

df$y_num = ifelse(df$y=='no',0,1)

# Data Exploration --------------------------------------------------------
# Variables used in modelling, which need more visualization.
# age, I(age^2), job, education, month, default, day_of_week, poutcome, 
# campaign, cons.price.idx, cons.conf.idx, euribor3m 

# Create a histogram for age.
ggplot(df, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "dodgerblue", col = "black")

# Create bar chart for job.
ggplot(df, aes(x = job)) +
  geom_bar(stat = "count", fill = "dodgerblue", col = "black") +
  theme(axis.text = element_text(size = 6))

# Create a bar chart for education.
ggplot(df, aes(x = education)) +
  geom_bar(stat = "count", fill = "dodgerblue", col = "black") +
  theme(axis.text = element_text(size = 8))

# Create a boxplot of the age distribution for different jobs.

ggplot(df,aes(x=job,y=age))+geom_boxplot(fill= "dodgerblue", col = "black")+
  labs(y = "Age Distribution",x='Job')+
  theme(axis.text = element_text(size = 5))


# 	Create a graph showing the proportion purchasing by Age.
ggplot(df) +
  aes(x = age, fill = y) +
  labs(y = "Proportion of Purchases",x='Age') +
  ggtitle("Proportion of Purchases by Age") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))

# Create a graph showing the proportion purchasing by Education.
ggplot(df) +
  aes(x = education, fill = y) +
  labs(y = "Proportion of Purchases",x='Education') +
  ggtitle("Proportion of Purchases by Education") +
  geom_bar(position = "fill")+
  theme(axis.text = element_text(size = 4))+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))

# Create a graph showing the proportion purchasing by Way of Contact
ggplot(df) +
  aes(x = contact, fill = y) +
  labs(y = "Proportion of Purchases",x='Way of Contact') +
  ggtitle("Proportion of Purchases by Contact") +
  geom_bar(position = "fill")+
  theme(axis.text = element_text(size = 10))+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))


# Create a graph showing proportion of purchase by Month
ggplot(df %>% mutate(month=fct_relevel(month,
  c('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec')))) +
  aes(x = month, fill = y) +
  labs(y = "Proportion of Purchases",x='Month') +
  ggtitle("Proportion of Purchases by Education") +
  geom_bar(position = "fill")+
  theme(axis.text = element_text(size = 10))+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))

# Create a graph showing proportion of purchase by Weekday
ggplot(df %>% mutate(day_of_week=fct_relevel(day_of_week,
  c('mon','tue','wed','thu','fri')))) +
  aes(x = day_of_week, fill = y) +
  labs(y = "Proportion of Purchases",x='Day of Week') +
  ggtitle("Proportion of Purchases by Day of Week") +
  geom_bar(position = "fill")+
  theme(axis.text = element_text(size = 10))+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))


# 	Create a graph showing the proportion purchasing by default.
ggplot(df) +
  aes(x = default, fill = y) +
  labs(y = "Proportion of Purchases",x='Default') +
  ggtitle("Proportion of Purchases by Default") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))

# Create a graph showing the proportion purchasing by job

ggplot(df) +
  aes(x = job, fill = y) +
  labs(y = "Proportion of Purchases",x='Job') +
  ggtitle("Proportion of Purchases by Job") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))+
  theme(axis.text = element_text(size = 4))


# Create a graph showing the proportion purchasing by previous outcome

ggplot(df) +
  aes(x = poutcome, fill = y) +
  labs(y = "Proportion of Purchases",x='Previous Contact Outcome') +
  ggtitle("Proportion of Purchases by Previous Contact Outcome") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))+
  theme(axis.text = element_text(size = 10))




ggplot(df[df$campaign<=30,]) +
  aes(x = campaign, fill = y) +
  labs(y = "Proportion of Purchases",x='Number of contacts performed during this campaign') +
  ggtitle("Proportion of Purchases by Campaign") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))


# cons.price.idx, cons.conf.idx, euribor3m 
ggplot(df) +
  aes(x = cons.price.idx, fill = y) +
  labs(y = "Proportion of Purchases",x='cons.price.idx') +
  ggtitle("Proportion of Purchases by cons.price.idx") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))

ggplot(df) +
  aes(x =  cons.conf.idx, fill = y) +
  labs(y = "Proportion of Purchases",x='cons.conf.idx') +
  ggtitle("Proportion of Purchases by cons.conf.idx") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))

ggplot(df) +
  aes(x =  euribor3m , fill = y) +
  labs(y = "Proportion of Purchases",x='euribor3m') +
  ggtitle("Proportion of Purchases by euribor3m") +
  geom_bar(position = "fill")+scale_fill_viridis_d() + 
  guides(fill=guide_legend(title="Purchase"))



cor(df[,c('euribor3m','emp.var.rate','cons.price.idx', 
          'cons.conf.idx','nr.employed')] )

#install.packages('corrplot')
library(corrplot)
corrmatrix <- cor(df[,c('euribor3m','emp.var.rate','cons.price.idx', 
                        'cons.conf.idx','nr.employed')])
corrplot(corrmatrix, method = 'color')
corrplot(corrmatrix, method = 'number')


# Use PCA to explore the relationships between financial variables and target -----------------
### PCA with target variable ###
library(caTools)
tmp <- df[,c('euribor3m','emp.var.rate','cons.price.idx',
             'cons.conf.idx','nr.employed','y_num')]

pca <- prcomp(tmp,scale=TRUE)
summary(pca)
library(ggfortify)
autoplot(pca, data = tmp, loadings = TRUE, col='dodgerblue',
         loadings.label = TRUE,loadings.label.colour='darkred',
         loadings.label.size = 5,loadings.colour = 'dodgerblue')+xlim(c(-0.01,0.01))


# PCA on financial variables ---------------------------------------------------------------------
library(caTools)
tmp <- df[,c('euribor3m','emp.var.rate','cons.price.idx', 
             'cons.conf.idx','nr.employed')]

pca <- prcomp(tmp,scale=TRUE)
summary(pca)
library(ggfortify)
autoplot(pca, data = tmp, loadings = TRUE, col='dodgerblue',
         loadings.label = TRUE,loadings.label.colour='darkred',
         loadings.label.size = 5,loadings.colour = 'dodgerblue')+xlim(c(-0.01,0.01))

pred <- as.data.frame(predict(pca, newdata = 
    df[, c('euribor3m','emp.var.rate','cons.price.idx', 
      'cons.conf.idx','nr.employed')]))
df <- cbind(df, pred[, 1:2])

# Clustering on financial variables  ------------------------------------------
wss <- function(k) {
  kmeans(tmp, k)$tot.withinss
}
k.values <- 1:5

wss_values <- map_dbl(k.values,wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

set.seed(123)
kmean_cluster <- kmeans(tmp,2)

autoplot(kmean_cluster, data = tmp, frame = TRUE,frame.type = 'norm')

kmean_cluster$size

kmean_cluster$centers

# library(cluster)
# ss <- silhouette(kmean_cluster$cluster, dist(tmp))
# silh <- mean(ss[, 3])

# Clustering on customer variables ----------------------------------------
prefix <- '/Users/ziyezhang/Desktop/MMA/MGSC 661/final project/bank-additional/'

df <- read.table(paste(prefix,'bank-additional-full.csv',sep=''),header=TRUE,sep=";")
# data used in clustering
df <- df[(df$job!='unknown') & (df$marital!='unknown') &
           (df$education!='unknown') & (df$education!='illiterate') &
           (df$loan!='unknown') & (df$housing!='unknown') & (df$default!='yes') ,]
df[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], as.factor)

df <- df %>% dplyr::select(-c('duration'))


#install.packages('fastDummies')
library(fastDummies)
dummy_df <- dummy_cols(df[,2:7])
personal_information <- cbind('age'=df[,1],dummy_df[,8:ncol(dummy_df)])
wss <- function(k) {
  kmeans(personal_information, k)$tot.withinss
}
k.values <- 1:5
wss_values <- map_dbl(k.values,wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares",
     main='Customer Information Clustering Elbow Plot')

set.seed(123)
kmean_cluster <- kmeans(personal_information,3)
kmean_cluster$centers

#calculate silhouette score
#install.packages('cluster')
library(cluster)
# ss <- silhouette(kmean_cluster$cluster, dist(personal_information))

#draw plot of silhouette scores
# library(cluster)
# silh_values <- vector()
# for (i in 2:5){
#   kmean_cluster <- kmeans(personal_information,i)
#   ss <- silhouette(kmean_cluster$cluster, dist(personal_information))
#   silh <- mean(ss[, 3])
#   silh_values <- cbind(silh_values,silh)
#   
# }
# k.values <- c(2:5)
# 
# plot(k.values, silh_values,
#      type="b", pch = 19, frame = FALSE, 
#      xlab="Number of clusters K",
#      ylab="Silhouette scores")



# Train Test Split --------------------------------------------------------
prefix <- '/Users/ziyezhang/Desktop/MMA/MGSC 661/final project/bank-additional/'

df <- read.table(paste(prefix,'bank-additional-full.csv',sep=''),header=TRUE,sep=";")

# data used in classification
#df <- df[(df$education!='illiterate') & (df$default!='yes') ,]
df <- df[(df$education!='illiterate') & (df$default!='yes') ,]
df[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], as.factor)

df <- df %>% dplyr::select(-c('duration'))

df$y_num = ifelse(df$y=='no',0,1)

df <- cbind(df, pred[, 1:2])

library(caTools)
set.seed(123)
sample=sample.split(df$y, SplitRatio=0.7)
train=subset(df, sample==TRUE) 
test=subset(df, sample==FALSE)
rm(sample)

# ------------
# precision will be more important than recall when the cost of acting is high, 
# but the cost of not acting is low

# Recall is more important than precision when the cost of acting is low, 
# but the opportunity cost of passing up on a candidate is high.
# ------------


# ------------
# We would like to have high recall rate,
# in other words, we are interested in identifying all potential real purchase customers
# precision, where we predicted to make a purchase, can be low, 
# because dialing a call is not costly, but a successful purchase is.
# ------------

# the classes are imbalanced; apply SMOTE to make it more balanced
table(train$y)

# install.packages('performanceEstimation')
library(performanceEstimation)
## now using SMOTE to create a more "balanced problem"
newTrain <- smote(y ~ ., train, perc.over = 0.001,perc.under=1500)
newTrain %>% summarise_all(list(~sum(is.na(.))))
newTrain <- drop_na(newTrain)
# newTrain <- train
table(newTrain$y)

metrics <- c()
# Logistic Regression -----------------------------------------------------
logit1=glm(y~age+job+marital+education+default+housing+contact+
             month+day_of_week+campaign+pdays+
             previous+poutcome+emp.var.rate+
             cons.price.idx+cons.conf.idx+
             euribor3m+nr.employed, data=newTrain, family = 'binomial')
summary(logit1)
library(car)
vif(logit1)

# remove collinear variables
logit2=glm(y~age+I(age^2)+job+marital+education+default+housing+contact+
             month+day_of_week+campaign+pdays+
             previous+poutcome+cons.price.idx+cons.conf.idx+
             euribor3m, data=newTrain, family = 'binomial')
vif(logit2)
summary(logit2)

# use first two components to replace financial variables
logit3=glm(y~age+I(age^2)+job+marital+education+default+housing+contact+
             month+day_of_week+campaign+pdays+
             previous+poutcome+PC1+PC2, data=newTrain, family = 'binomial')
vif(logit3)
summary(logit3)

# see test results
library(caret)
test_pred_prob=predict(logit3, test,type='response') 
# library(pROC)
# roc <- roc(test$y, test_pred_prob)
# par(pty = "s")
# plot(roc)
# pROC::auc(roc)
# ggplot(data=NULL,aes(x=(1-roc$specificities),y=roc$sensitivities,col=roc$thresholds))+geom_line()
# ggplot(data=NULL,aes(x=roc$thresholds,y=roc$sensitivities))+geom_line()
# 
# roc$thresholds[roc$specificities<=0.375 & roc$specificities>=0.374]
# 
# test_pred = as.factor(ifelse(test_pred_prob>0.5,'yes','no'))
# confusionMatrix(test_pred,test$y)$table
# # see roc results
# logit_probs <- predict(logit2, newTrain, type = "response")
# logit_probs_test <- predict(logit2, test, type = "response")


# Stepiwise selection
# glm(formula = y ~ age + I(age^2) + default + month + campaign + 
#       pdays + poutcome + PC1 + PC2, family = "binomial", data = newTrain)
# library(MASS)
# step.logit2.backward <- stepAIC(logit3,direction='backward',trace=FALSE)
# summary(step.logit2.backward)
step.logit2.backward <- glm(formula = y ~ age + I(age^2) + default + month + education + 
                              poutcome + PC1 + PC2, 
                            family = "binomial", data = newTrain)

train_pred_prob=predict(step.logit2.backward,train,type='response') 
train_pred = as.factor(ifelse(train_pred_prob>0.5,'yes','no'))

test_pred_prob=predict(step.logit2.backward, test,type='response') 
test_pred = as.factor(ifelse(test_pred_prob>0.5,'yes','no'))

confusionMatrix(train_pred,train$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]


step.logit2.backward2 <- glm(formula = y ~ age + I(age^2) + default + month + education +
                              poutcome + cons.price.idx + cons.conf.idx + euribor3m, 
                            family = "binomial", data = newTrain)
train_pred_prob=predict(step.logit2.backward2,train,type='response') 
train_pred = as.factor(ifelse(train_pred_prob>0.5,'yes','no'))

test_pred_prob=predict(step.logit2.backward2, test,type='response') 
test_pred = as.factor(ifelse(test_pred_prob>0.5,'yes','no'))

confusionMatrix(train_pred,train$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]

metrics <- cbind(metrics,confusionMatrix(test_pred,test$y,mode= "prec_recall",
      positive='yes')$byClass[c('Precision','Recall','Balanced Accuracy')])

# Discriminant Analysis ---------------------------------------------------
library(MASS)
# Linear
linear_da <- lda(y~age+job+marital+education+default+housing+contact+
                   month+day_of_week+campaign+pdays+
                   previous+poutcome+emp.var.rate+
                   cons.price.idx+cons.conf.idx+
                   euribor3m+nr.employed,data=newTrain)
linear_da
test_pred=predict(linear_da, test) 
confusionMatrix(test_pred$class,test$y)$table

linear_da2 <- lda(y ~ default + month + education +
                    poutcome + cons.price.idx + cons.conf.idx + euribor3m,
           data=newTrain)
linear_da2

train_pred = predict(linear_da2, train) 
test_pred=predict(linear_da2, test) 

confusionMatrix(train_pred$class,train$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred$class,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
metrics <- cbind(metrics,confusionMatrix(test_pred$class,test$y,mode= "prec_recall",positive='yes')$
                   byClass[c('Precision','Recall','Balanced Accuracy')])

confusionMatrix(test_pred$class,test$y)$table

# Quadratic
quadratic_da <- qda(y~age+job+marital+education+default+housing+contact+
                      month+day_of_week+campaign+pdays+
                      previous+poutcome+cons.price.idx+cons.conf.idx+
                      euribor3m,data=newTrain)
test_pred=predict(quadratic_da, test) 
confusionMatrix(test_pred$class,test$y)$table

quadratic_da3 <- qda(y ~ default + month + education + job +
                       poutcome + PC1 +PC2,
                     data=newTrain)
quadratic_da3

train_pred = predict(quadratic_da3, train) 
test_pred=predict(quadratic_da3, test) 

confusionMatrix(train_pred$class,train$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred$class,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]



quadratic_da2 <- qda(y ~ default + month + education + job + 
                    poutcome + cons.price.idx + cons.conf.idx + euribor3m,
                  data=newTrain)
quadratic_da2

train_pred = predict(quadratic_da2, train) 
test_pred=predict(quadratic_da2, test) 

confusionMatrix(train_pred$class,train$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred$class,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]

metrics <- cbind(metrics,confusionMatrix(test_pred$class,test$y,mode= "prec_recall",positive='yes')$
                   byClass[c('Precision','Recall','Balanced Accuracy')])



# Decision Tree ---------------------------------------------------------

library(rpart)
library(rpart.plot)

set.seed(1234)
tree1 <- rpart(y~age+job+marital+education+default+housing+loan+contact+
                 month+day_of_week+campaign+pdays+
                 previous+poutcome+cons.price.idx+cons.conf.idx+
                 euribor3m, data = newTrain, method = "class",
               control = rpart.control(minbucket = 10, 
                                       cp = 0.000001, maxdepth = 10))

#rpart.plot(tree1, type = 0, digits = 2)
tree1

printcp(tree1)
plotcp(tree1)

opt_cp=tree1$cptable[which.min(tree1$cptable[,'xerror']),"CP"]
opt_cp
set.seed(1234)
tree2 <- rpart(y~age+job+marital+education+default+housing+loan+contact+
                 month+day_of_week+campaign+pdays+
                 previous+poutcome+cons.price.idx+cons.conf.idx+
                 euribor3m,
               data = newTrain, method = "class",
               control = rpart.control(minbucket = 10, 
                                       cp = opt_cp, maxdepth = 6))

rpart.plot(tree2, type = 0, digits = 2)

train_pred <- predict(tree2, type = "class", newdata = train)
test_pred <- predict(tree2, type = "class", newdata = test)

confusionMatrix(train_pred,train$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]

set.seed(1234)
# grow a tree with top 9 variables selected 
tree3 <- rpart(y~age+job+euribor3m+day_of_week+pdays + default +
                 education+month+contact+cons.price.idx,
               data = newTrain, method = "class",
               control = rpart.control(minbucket = 40, 
                                       cp = 0.000001, maxdepth = 6))
opt_cp=tree3$cptable[which.min(tree3$cptable[,'xerror']),"CP"]

tree3 <- rpart(y~age+job+euribor3m+day_of_week+pdays + default +
                 education+month+contact+cons.price.idx,
               data = newTrain, method = "class",
               control = rpart.control(minbucket = 40, 
                                       cp = opt_cp, maxdepth = 6))

rpart.plot(tree3, type = 0, digits = 2)

train_pred <- predict(tree3, type = "class", newdata = train)
test_pred <- predict(tree3, type = "class", newdata = test)

confusionMatrix(train_pred,train$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]

metrics <- cbind(metrics,confusionMatrix(test_pred,test$y,mode= "prec_recall",positive='yes')$
                   byClass[c('Precision','Recall','Balanced Accuracy')])



# # Cross Validation --- GBM -----------------------------------------------------------
# set.seed(7)
# library(caret)
# control <- trainControl(method="cv", number=5)
# 
# grid <- expand.grid(n.trees=seq(5000,8000,1000), interaction.depth=c(1,2,3,4),
#                     shrinkage=seq(0.05,0.08,0.01),n.minobsinnode=10)
# # train the model
# model <- train(as.factor(y_num)~age+job+education+
#                  month+day_of_week+campaign+ cons.price.idx+
#                  cons.conf.idx+euribor3m, data=newTrain, 
#                method="gbm", trControl=control, tuneGrid=grid,metric='Kappa')
# 
# 
# print(model)
# # plot the effect of parameters on accuracy
# plot(model)
# model$bestTune
# # shrinkage  interaction.depth  n.trees  Accuracy   Kappa  
# # 0.08       1                  8000     0.7325151  0.4646273
# 
# 


# # Cross Validation ---Random Forest -----------------------------------------------------------
# set.seed(7)
# library(caret)
# control <- trainControl(method="cv", number=5)
# 
# grid <- expand.grid(mtry=c(2,3,4,5))
# # train the model
# model <- train(y~age+job+euribor3m+day_of_week+campaign+
#                  education+month+cons.conf.idx+cons.price.idx, data=newTrain,
#                method="rf", trControl=control, tuneGrid=grid,metric='Kappa')
# # summarize the model
# print(model)
# # plot the effect of parameters on accuracy
# plot(model)
# 



# Random Forest -----------------------------------------------------------
library(randomForest)
# all variables
newTrain <- newTrain[!is.na(newTrain$age),]
rft=randomForest(data=newTrain,y~age+job+marital+education+default+housing+loan+contact+
                   month+day_of_week+campaign+pdays+
                   previous+poutcome+cons.price.idx+cons.conf.idx+euribor3m)
# variable importance
varimp <- data.frame(varImp(rft))
varImpPlot(rft,main='Random Forest Feature Importance')
test_pred=predict(rft,test)
confusionMatrix(test_pred,test$y)$table


# Grow a random forest model using top 9 variables
set.seed(1234)
rft=randomForest(data=newTrain,y~age+job+euribor3m+day_of_week+campaign+
                   education+month+cons.conf.idx+cons.price.idx, mtry=1)
varImpPlot(rft)

train_pred <- predict(rft)
test_pred=predict(rft,test) 

confusionMatrix(train_pred,newTrain$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(test_pred,test$y,mode= "prec_recall",positive='yes')$
  byClass[c('Precision','Recall','Balanced Accuracy')]

metrics <- cbind(metrics,confusionMatrix(test_pred,test$y,mode= "prec_recall",positive='yes')$
                   byClass[c('Precision','Recall','Balanced Accuracy')])


# Gradient Boosting -------------------------------------------------------
library(gbm)
# all predictors 
gbt=gbm(data=newTrain,as.numeric(y_num)~age+job+marital+education+default+housing+loan+contact+
          month+day_of_week+campaign+pdays+
          previous+poutcome+cons.price.idx+cons.conf.idx+euribor3m,
        distribution= "bernoulli",n.trees = 10000 )
summary(gbt)
yy=summary(gbt)

xx=data.frame(name=yy$var,Overall=yy$rel.inf)
xx$name=rownames(xx)

ggplot(data=xx,aes(x=reorder(name,Overall),y=Overall,fill=Overall))+
  geom_bar(stat="identity")+
  labs(x='Variable',y='Relative Importance',title=
         'Gradient Boosting Feature Importance') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
test_pred_prob=predict(gbt, newdata=test, n.trees=8000, type='response')
test_pred = ifelse(test_pred_prob>0.5,1,0)
print(confusionMatrix(as.factor(test_pred),as.factor(test$y_num))$table)

# selected predictors
set.seed(1234)
gbt=gbm(data=newTrain,as.numeric(y_num)~age+job+education+
          month+day_of_week+campaign+ cons.price.idx+cons.conf.idx+euribor3m,
        distribution= "bernoulli",n.trees=7000,interaction.depth=1,shrinkage=0.08,
        n.minobsinnode=10)
summary(gbt)

train_pred_prob=predict(gbt, newdata=train, n.trees=7000, type='response')
train_pred = ifelse(train_pred_prob>0.5,1,0)

test_pred_prob=predict(gbt, newdata=test, n.trees=7000, type='response')
test_pred = ifelse(test_pred_prob>0.5,1,0)
print(confusionMatrix(as.factor(test_pred),as.factor(test$y_num))$table)

confusionMatrix(as.factor(train_pred),as.factor(train$y_num),
                mode= "prec_recall",positive='1')$
  byClass[c('Precision','Recall','Balanced Accuracy')]
confusionMatrix(as.factor(test_pred),as.factor(test$y_num),
                mode= "prec_recall",positive='1')$
  byClass[c('Precision','Recall','Balanced Accuracy')]

metrics <- cbind(metrics,confusionMatrix(as.factor(test_pred),as.factor(test$y_num),
                                         mode= "prec_recall",positive='1')$
                   byClass[c('Precision','Recall','Balanced Accuracy')])

# ------------------
Metrics <- as.data.frame(metrics,col.names=c('Logistic Regression',
                                             'Linear Discriminant Analysis',
                                             'Quadratic Discriminant Analysis',
                                             'Decision Tree',
                                             'Random Forest',
                                             'Gradient Boosting'))
colnames(Metrics) <- c('Logistic Regression',
                       'LDA',
                       'QDA',
                       'Decision Tree',
                       'Random Forest',
                       'Gradient Boosting')
Metrics
library(gridExtra)
png('/Users/ziyezhang/Desktop/Metrics.png',
    height=50*nrow(Metrics),width=200*ncol(Metrics))
grid.table(round(Metrics,4))
dev.off()
