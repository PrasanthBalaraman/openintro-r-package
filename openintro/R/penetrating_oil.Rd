\name{penetrating_oil}
\alias{penetrating_oil}
\docType{data}
\title{
What's the best way to loosen a rusty bolt?
}
\description{
The channel Project Farm on YouTube investigated
penetrating oils and other options for loosening rusty
bolts.
Eight options were evaluated, including a control group,
to determine which was most effective.
}
\usage{data("penetrating_oil")}
\format{
  A data frame with 30 observations on the following 2 variables.
  \describe{
    \item{\code{treatment}}{The different treatments tried:
        \code{none} (control),
        \code{Heat} (via blow torch),
        \code{Acetone/ATF},
        \code{AeroKroil},
        \code{Liquid Wrench},
        \code{PB Blaster},
        \code{Royal Purple}, and
        \code{WD-40}.}
    \item{\code{torque}}{Torque required to loosen the
        rusty bolt, which was measured in foot-pounds.}
  }
}
\source{https://www.youtube.com/watch?v=xUEob2oAKVs}
\examples{
m <- lm(torque ~ treatment, data = d)
anova(m)

# There are 28 pairwise comparisons to be made.
xbar <- tapply(d$torque, d$treatment, mean)
n <- tapply(d$torque, d$treatment, length)
s <- summary(m)$sigma
df <- summary(m)$df[1]

diff <- c()
se <- c()
k <- 0
N <- length(n)
K <- N * (N - 1) / 2
for (i in 1:(N - 1)) {
  for (j in (i + 1):N) {
    k <- k + 1
    diff[k] <- xbar[i] - xbar[j]
    se[k] <- s * sqrt(1 / n[i] + 1 / n[j])
    if (2 * K * pt(-abs(diff[k] / se[k]), df) < 0.05) {
      cat("0.05 - ", names(n)[c(i, j)], "\n")
    } else if (2 * K * pt(-abs(diff[k] / se[k]), df) < 0.1) {
      cat("0.1 - ", names(n)[c(i, j)], "\n")
    } else if (2 * K * pt(-abs(diff[k] / se[k]), df) < 0.2) {
      cat("0.2 - ", names(n)[c(i, j)], "\n")
    } else if (2 * K * pt(-abs(diff[k] / se[k]), df) < 0.3) {
      cat("0.3 - ", names(n)[c(i, j)], "\n")
    }
  }
}

# Smallest p-value using Bonferroni
min(2 * K * pt(-abs(diff / se), df))


# Better pairwise comparison method.
anova(m1 <- aov(torque ~ treatment, data = d))
TukeyHSD(m1)
}
\keyword{datasets}
