
This chapter has focussed exclusively on the class of linear models, which assume a relationship of the form `y = a_1 * x1 + a_2 * x2 + ... + a_n * xn`. Linear models additionally assume that the residuals have a normal distribution, which we haven't talked about. There are a large set of model classes that extend the linear model in various interesting ways. Some of them are:

* __Generalised linear models__, e.g. `stats::glm()`. Linear models assume that
  the response is continuous and the error has a normal distribution. 
  Generalised linear models extend linear models to include non-continuous
  responses (e.g. binary data or counts). They work by defining a distance
  metric based on the statistical idea of likelihood.
  
* __Generalised additive models__, e.g. `mgcv::gam()`, extend generalised
  linear models to incorporate arbitrary smooth functions. That means you can
  write a formula like `y ~ s(x)` which becomes an equation like 
  `y = f(x)` and let `gam()` estimate what that function is (subject to some
  smoothness constraints to make the problem tractable).
  
* __Penalised linear models__, e.g. `glmnet::glmnet()`, add a penalty term to
  the distance that penalises complex models (as defined by the distance 
  between the parameter vector and the origin). This tends to make
  models that generalise better to new datasets from the same population.

* __Robust linear models__, e.g. `MASS:rlm()`, tweak the distance to downweight 
  points that are very far away. This makes them less sensitive to the presence
  of outliers, at the cost of being not quite as good when there are no 
  outliers.
  
* __Trees__, e.g. `rpart::rpart()`, attack the problem in a completely different
  way than linear models. They fit a piece-wise constant model, splitting the
  data into progressively smaller and smaller pieces. Trees aren't terribly
  effective by themselves, but they are very powerful when used in aggregate
  by models like __random forests__ (e.g. `randomForest::randomForest()`) or 
  __gradient boosting machines__ (e.g. `xgboost::xgboost`.)

These models all work similarly from a programming perspective. Once you've mastered linear models, you should find it easy to master the mechanics of these other model classes. Being a skilled modeller is a mixture of some good general principles and having a big toolbox of techniques. Now that you've learned some general tools and one useful class of models, you can go on and learn more classes from other sources.