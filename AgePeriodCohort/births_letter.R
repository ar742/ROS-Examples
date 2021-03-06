#' ---
#' title: "Regression and Other Stories: AgePeriodCohort"
#' author: "Andrew Gelman, Jennifer Hill, Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' ---

#' Age-Period-Cohort - Age adjustment: additional plots.  See Chapter
#' 3 in Regression and Other Stories.
#' 
#' -------------
#'

#+ setup, include=FALSE
knitr::opts_chunk$set(message=FALSE, error=FALSE, warning=FALSE, comment=NA)
# switch this to TRUE to save figures in separate files
savefigs <- FALSE

#' **Load packages**
library("rprojroot")
root<-has_dirname("ROS-Examples")$make_fix_file()

#' **Initialize running the first part**
#+ results='hide'
source(root("AgePeriodCohort/births.R"))

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig1a.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
plot(years_1,  number_of_deaths/number_of_people, xaxt="n", type="l", bty="l", xaxs="i", xlab="", ylab="Death rate among non-Hisp whites 45-54", main="Raw death rates\nfor 45-54-year-old non-Hisp whites", cex.main=1.1)
axis(1, seq(1990,2020,5))
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig1b.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
plot(years_1, avg_age, xaxt="n", type="l", bty="l", xaxs="i", xlab="", ylab="Avg age among non-Hisp whites 45-54", main="But the average age in this group is going up!", cex.main=1.1)
axis(1, seq(1990,2020,5))
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig1c.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
plot(years_1, number_of_deaths/number_of_people, xaxt="n", type="l", bty="l", xaxs="i", xlab="", ylab="Death rate for 45-54 non-Hisp whites", main="The trend in raw death rates since 2005\ncan be explained by age-aggregation bias", cex.main=1.1)
lines(years_1, death_rate_extrap_2013, col="green4")
axis(1, seq(1990,2020,5))
text(2003.5, .00395, "Raw death rate", cex=1)
text(2001.5, .00408, "Expected just from\nage shift", col="green4", cex=1)
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig1c_grayscale.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
plot(years_1, number_of_deaths/number_of_people, xaxt="n", type="l", bty="l", xaxs="i", xlab="", ylab="Death rate for 45-54 non-Hisp whites", main="The trend in raw death rates since 2005\ncan be explained by age-aggregation bias", cex.main=1.1)
lines(years_1, death_rate_extrap_2013)
axis(1, seq(1990,2020,5))
text(2003.5, .00395, "Raw death rate", cex=1)
text(2001.5, .00408, "Expected just from\nage shift", cex=1)
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig2a.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
plot(years_1, age_adj_rate_flat/age_adj_rate_flat[1], xaxt="n", type="l", bty="l", xaxs="i", xlab="", ylab="Age-adj death rate, relative to 1999", main="Trend in age-adjusted death rate\nfor 45-54-year-old non-Hisp whites", cex.main=1.1)
axis(1, seq(1990,2020,5))
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig2b.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
rng <- range(age_adj_rate_flat/age_adj_rate_flat[1], age_adj_rate_1999/age_adj_rate_1999[1], age_adj_rate_2013/age_adj_rate_2013[1])
plot(years_1, age_adj_rate_flat/age_adj_rate_flat[1], ylim=rng, xaxt="n", type="l", bty="l", xaxs="i", xlab="", ylab="Age-adj death rate, relative to 1999", main="It doesn't matter too much what age adjustment\nyou use for 45-54-year-old non-Hisp whites", cex.main=1.1)
lines(years_1, age_adj_rate_1999/age_adj_rate_1999[1], lty=2)
lines(years_1, age_adj_rate_2013/age_adj_rate_2013[1], lty=3)
text(2003, 1.055, "Using 1999\nage dist")
text(2004, 1.030, "Using 2013\nage dist")
axis(1, seq(1990,2020,5))
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig2c.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
plot(range(years_1), c(1, 1.1), xaxt="n", yaxt="n", type="n", bty="l", xaxs="i", xlab="", ylab="Death rate relative to 1999", main="Age-adjusted death rates for non-Hispanic whites\naged 45-54: Trends for women and men", cex.main=1.1)
lines(years_1, male_avg_death_rate[,2,1]/male_avg_death_rate[1,2,1], col="blue")
lines(years_1, female_avg_death_rate[,2,1]/female_avg_death_rate[1,2,1], col="red")
axis(1, seq(1990,2020,5))
axis(2, seq(1, 1.1, .05))
text(2011.5, 1.068, "Women", col="red", cex=1.2)
text(2010.5, 1.014, "Men", col="blue", cex=1.2)
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("AgePeriodCohort/figs","fig2c_grayscale.pdf"), height=4, width=5)
#+
par(mar=c(2.5, 3, 3, .2), mgp=c(2,.5,0), tck=-.01)
plot(range(years_1), c(1, 1.1), xaxt="n", yaxt="n", type="n", bty="l", xaxs="i", xlab="", ylab="Death rate relative to 1999", main="Age-adjusted death rates for non-Hispanic whites\naged 45-54: Trends for women and men", cex.main=1.1)
lines(years_1, male_avg_death_rate[,2,1]/male_avg_death_rate[1,2,1])
lines(years_1, female_avg_death_rate[,2,1]/female_avg_death_rate[1,2,1])
axis(1, seq(1990,2020,5))
axis(2, seq(1, 1.1, .05))
text(2011.5, 1.068, "Women", cex=1.2)
text(2010.5, 1.014, "Men",  cex=1.2)
grid(col="gray")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()
