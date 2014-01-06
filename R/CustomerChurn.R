library(SMCRM)
library(lattice)
library(caret)

library("party")
library("randomForest")
library("gbm")

data(customerChurn)
str(customerChurn)

histogram( ~ duration, data=customerChurn, 
          xlab="Dauer in Tagen",
          breaks=15)
table(customerChurn$censor)


model.glm.2 <- glm(as.factor(censor) ~ avg_ret_exp + avg_ret_exp_sq + industry + revenue +
                     employees + total_crossbuy + total_freq + total_freq_sq,
                   family = binomial(), data = customerChurn)

p <- predict(model.glm.2, type = "response")
bwplot(censor ~ p, data = customerChurn)

model.tree <- ctree(as.factor(censor) ~ avg_ret_exp + avg_ret_exp_sq + industry + revenue +
                      employees + total_crossbuy + total_freq + total_freq_sq,
                    data = customerChurn)

plot(model.tree)
model.tree.pred <- predict(model.tree, type = "response")
summary(customerChurn$censor)
summary(model.tree.pred)
table(customerChurn$censor, model.tree.pred)