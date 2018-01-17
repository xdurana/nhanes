library(xgboost)
library(caret)
library(pROC)

outcome <- c('is_diabetic')
predictors <- names(diabetes)[!names(diabetes) %in% outcome]

train_matrix <- as.matrix(diabetes, rownames.force = NA)

train_dmatrix <- xgb.DMatrix(data = train_matrix[, predictors], label = train_matrix[, outcome] )

fit.xgb <- xgb.cv(
  data = train_dmatrix,
  verbose = 0,
  nrounds = 100,
  nfold = 5,
  eta = 0.1,
  missing = NA,
  showsd = T,
  objective = "binary:logistic"
)

which(fit.xgb$evaluation_log$test_error_mean == min(fit.xgb$evaluation_log$test_error_mean))

fit.xgb <- xgboost(
  data = train_dmatrix,
  verbose = 0,
  eta = 0.1,
  missing = NA,
  nround = 2,
  objective = "binary:logistic"
)

xgb.dump(fit.xgb)

predictions <- predict(fit.xgb, as.matrix(diabetes[, predictors]))

mean(as.numeric(predictions > 0.5) != train_matrix[, outcome])

confusionMatrix(
  as.numeric(predictions > 0.1),
  train_matrix[, outcome],
  mode = "everything"
)

plot.roc(
  as.numeric(predictions > 0.5),
  train_matrix[, outcome],
  main = "Confidence intervals",
  percent = TRUE,
  ci = TRUE,
  print.auc=TRUE
)

# feature importance

importance_matrix <- xgb.importance(feature_names = predictors, model = fit.xgb)
xgb.plot.importance(importance_matrix[1:10,])
head(importance_matrix)
