# Pakete
library("data.table")
library("party")
library("randomForest")
library("gbm")
library("caret")
library("pROC")
library("Cairo")


# Lade Daten
load(file = "R for Predictive Analytics/assets/churn.RData")
source("R for Predictive Analytics/assets/Graphics.R")
source("R for Predictive Analytics/assets/lattice.R")


set.seed(301)

# Deskriptive Analyse
names(customer.data)
str(customer.data)

comment(customer.data$churn)
summary(customer.data$churn)
table(customer.data$churn)/NROW(customer.data)


# # Deskriptive Analyse
# customer.data[, churned :=
#                 factor((churn != "N"),
#                        levels = c(TRUE, FALSE), labels = c("yes", "no"))]
# Graphics("churned-splom")
# splom(customer.data[, list(churned, gender, age, children, assets, house,
#                            invest, trade, spend)],
#       lower.panel = dm.panel, upper.panel = panel.correlation,
#       as.matrix = TRUE)
# Graphics.off()


# Churn in Quartal 1
customer.data[, churn.1 := factor(churn == "Q1",
                                  levels = c(FALSE, TRUE), labels = c("no", "yes"))]


## Training- und Testmenge
train.rows <- sample.int(NROW(customer.data), floor(0.80 * NROW(customer.data)))
train.data <- customer.data[train.rows]
test.data <- customer.data[-train.rows]




# Logistische Regression
model.glm <- glm(formel, family = binomial(), data = train.data)
summary(model.glm)


bwplot(predict(model.glm, type = "response") ~ churn.1, data = train.data)

p.glm <- predict(model.glm, newdata = test.data, type = "response")
roc.glm <- pROC::roc(test.data$churn.1, p.glm)
plot(roc.glm)

aucs <- data.frame(method = "glm", auc = auc(roc.glm))





# Tree
model.tree <- ctree(formel, data = train.data)
CairoPNG("churn-tree-plot.png", width=2000, height=1000)
plot(model.tree)
dev.off()


model.tree.pred <- predict(model.tree, type = "response")
summary(model.tree.pred)
table(train.data$churn.1, model.tree.pred)

p.tree <- predict(model.tree, newdata = test.data, type = "prob")
p.tree <- sapply(p.tree, `[`, 2)
roc.tree <- pROC::roc(test.data$churn.1, p.tree)
plot(roc.tree, col = "red")

print(aucs <- rbind(aucs, data.frame(method = "tree", auc = auc(roc.tree))))

plot(roc.glm, add = TRUE, col = "blue")


# Random Forests
model.RF <- randomForest(x = train.mm, y = train.y, ntree = 250,
                         importance = TRUE, do.trace = 50)
print(model.RF)
plot(model.RF)
table(train.data$churn.1, model.RF$predicted)

p.RF <- predict(model.RF, newdata = test.mm, type = "prob")[, "yes"]
roc.RF <- pROC::roc(test.data$churn.1, p.RF)
Graphics("03-01-churn.1-rf-roc")
plot(roc.RF, col = "darkred")
Graphics.off()

(aucs <- rbind(aucs, data.frame(method = "RF", auc = auc(roc.RF))))

plot(roc.glm, add = TRUE, col = "blue")
plot(roc.tree, add = TRUE, col = "darkgreen")



# Formel
formel <- churn.1 ~ gender + age + children + C - 1

load("R for Predictive Analytics/assets/churn.model.gbm.RData")
load("R for Predictive Analytics/assets/churn.model.train.gbm.RData")
load("R for Predictive Analytics/assets/churn.model.rf.RData")

train.mf <- model.frame(formel, data = train.data)
train.y  <- model.response(train.mf)
train.mm <- model.matrix(formel, train.mf)

test.mf <- model.frame(formel, data = test.data)
test.y  <- model.response(test.mf)
test.mm <- model.matrix(formel, test.mf)


print(model.rf$finalModel)


p.rf <- predict(model.rf$finalModel, newdata = test.mm, type = "prob")[, "yes"]
p.ogbm <- predict(model.train.gbm, newdata = test.mm, type = "prob")[, "yes"]

roc.rf <- pROC::roc(test.data$churn.1, p.rf)
roc.ogbm <- pROC::roc(test.data$churn.1, p.ogbm)

aucs <- data.frame(method = "randomForest", auc = auc(roc.rf))
aucs <- rbind(aucs, data.frame(method = "gbm", auc = auc(roc.ogbm)))

CairoPNG("R for Predictive Analytics/assets/img/roc.png", width=500, height=500)
plot(roc.ogbm, col="darkgreen")
plot(roc.rf, col="steelblue", add=T)
legend("bottomright", legend = c("randomForest", "gbm"), col = c("steelblue", "darkgreen"),lwd = 2)
dev.off()













