#' ---
#' title: "Regression and Other Stories: Sesame street"
#' author: "Andrew Gelman, Jennifer Hill, Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' ---

#' Causal analysis of Sesame Street experiment. See Chapters 18 and 21
#' in Regression and Other Stories.
#' 
#' -------------
#' 

#+ setup, include=FALSE
knitr::opts_chunk$set(message=FALSE, error=FALSE, warning=FALSE, comment=NA)

#' **Load packages**
library("rprojroot")
root<-has_dirname("ROS-Examples")$make_fix_file()
library("rstanarm")
library("brms")
library("foreign")

#' Set random seed for reproducability
SEED <- 1234

#' **Load data**
sesame <- read.dta(file=root("Sesame/data","sesame.dta"))
sesame$watched <- ifelse(sesame$viewcat==1, 0, 1)
sesame$encouraged <- ifelse(sesame$viewenc==2, 0, 1)
sesame$y <- sesame$postlet
sesame$pretest <- sesame$prelet

#' **Look at compliance**
(sesame_tab <- table(sesame[,c('watched','encouraged')]))
round(prop.table(sesame_tab, margin=2), digits=2)

#' **WALD ESTIMATOR**
#' 
#' Estimate the intent-to-treat (ITT) effect of the instrument
#' (encouragement) on the treatment (regular watching), that is,
#' percentage of children actually induced to watch Sesame Street by
#' the intervention**
itt_zt <- stan_glm(watched ~ encouraged, data=sesame, seed=SEED, refresh=0)
print(itt_zt, digits=2)

#' Estimate the intent-to-treat (ITT) estimate on the outcome
#' (post-treatment letter identification)
itt_zy <- stan_glm(postlet ~ encouraged, data=sesame, refresh=0)
print(itt_zy, digits=1)

#' Calculate Wald estimate, ie the ratio of the above two estimates
wald_est <- coef(itt_zy)["encouraged"] / coef(itt_zt)["encouraged"]
round(wald_est, digits=1)

#' **Two stage approach**
#'
#' The first step is to regress the "treatment" variable---an
#' indicator for regular watching (watched)---on the randomized
#' instrument, encouragement to watch (encouraged).
fit_2a <- stan_glm(watched ~ encouraged, data=sesame, seed=SEED, refresh=0)
print(fit_2a, digits=2)
summary(fit_2a$fitted, digits=2)
sesame$watched_hat <- fit_2a$fitted
#' Then we plug predicted values of watched into the equation
#' predicting the letter recognition outcome.
fit_2b <- stan_glm(postlet ~ watched_hat, data=sesame, seed=SEED, refresh=0)
print(fit_2b, digits = 1)

#' **Two stage approach with adjusting for covariates in an instrumental variables framework**
#' 
#' The first step is to regress the "treatment" variable on the
#' randomized instrument, encouragement to watch (encouraged) and
#' pre-treatment variable.
fit_3a <- stan_glm(watched ~ encouraged + prelet + as.factor(site) + setting,
                   data=sesame, seed=SEED, refresh=0)
print(fit_3a, digits=2)
summary(fit_3a$fitted, digits=2)
#' Then we plug predicted values of watched into the equation
#' predicting the letter recognition outcome.
watched_hat_3 <- fit_3a$fitted
fit_3b <- stan_glm(postlet ~ watched_hat_3 + prelet + as.factor(site) + setting,
                   data=sesame, seed=SEED, refresh=0)
print(fit_3b, digits = 1)

#' **Estimate the standard errors**
#'
#' Use the predictor matrix from this second-stage regression.
X_adj <- X <- model.matrix(fit_3b)
X_adj[,"watched_hat_3"] <- sesame$watched
n <- nrow(X)
p <- ncol(X)
#' **Compute the standard deviation of the adjusted residuals**
RMSE1 <- sqrt(sum((sesame$postlet - X %*% coef(fit_3b))^2)/(n-p))
RMSE2 <- sqrt(sum((sesame$postlet - X_adj %*% coef(fit_3b))^2)/(n-p))
se_adj <- se(fit_3b)["watched_hat_3"] * sqrt(RMSE1 / RMSE2)
print(se_adj, digits=2)

#' **Perform two-stage approach automatically using brms**
f1 <- bf(watched ~ encour)
f2 <- bf(postlet ~ watched)
#+ results='hide'
IV_brm_a <- brm(f1 + f2, data=sesame, seed=SEED)
#+
print(IV_brm_a, digits=1)

#' **Perform two-stage approach incorporating other pre-treatment
#' variables as controls using brms**
f1 <- bf(watched ~ encour + prelet + setting + factor(site))
f2 <- bf(postlet ~ watched + prelet + setting + factor(site))
#+ results='hide'
IV_brm_b <- brm(f1 + f2, data=sesame, seed=SEED)
#+
print(IV_brm_b, digits=1)
