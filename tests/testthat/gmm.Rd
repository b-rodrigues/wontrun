\name{gmm}

\alias{gmm}

\title{Generalized method of moment estimation}

\description{
 Function to estimate a vector of parameters based on moment conditions using the GMM method of Hansen(82). 
}
\usage{
gmm(g, x, t0 = NULL, gradv = NULL, type = c("twoStep","cue","iterative"), 
wmatrix = c("optimal","ident"), vcov = c("HAC","iid"), 
kernel = c("Quadratic Spectral","Truncated", "Bartlett", 
"Parzen", "Tukey-Hanning"), crit = 10e-7, bw = bwAndrews, 
prewhite = FALSE, ar.method = "ols", approx = "AR(1)", tol = 1e-7, 
itermax = 100, optfct = c("optim","optimize","nlminb"), model=TRUE, X=FALSE, Y=FALSE, 
TypeGmm = "baseGmm", centeredVcov = TRUE, weightsMatrix = NULL, ...)
}
\arguments{
\item{g}{A function of the form \eqn{g(\theta,x)} and which returns a \eqn{n \times q} matrix with typical element \eqn{g_i(\theta,x_t)} for \eqn{i=1,...q} and \eqn{t=1,...,n}. This matrix is then used to build the q sample moment conditions. It can also be a formula if the model is linear (see details below).}

\item{x}{The matrix or vector of data from which the function \eqn{g(\theta,x)} is computed. If "g" is a formula, it is an \eqn{n \times Nh} matrix of instruments (see details below).}

\item{t0}{A \eqn{k \times 1} vector of starting values. It is required only when "g" is a function because only then a numerical algorithm is used to minimize the objective function. If the dimension of \eqn{\theta} is one, see the argument "optfct".}

\item{gradv}{A function of the form \eqn{G(\theta,x)} which returns a \eqn{q\times k} matrix of derivatives of \eqn{\bar{g}(\theta)} with respect to \eqn{\theta}. By default, the numerical algorithm \code{numericDeriv} is used. It is of course strongly suggested to provide this function when it is possible. This gradiant is used compute the asymptotic covariance matrix of \eqn{\hat{\theta}}. If "g" is a formula, the gradiant is not required (see the details below).}

\item{type}{The GMM method: "twostep" is the two step GMM proposed by Hansen(1982) and the "cue" and "iterative" are respectively the continuous updated and the iterative GMM proposed by Hansen, Eaton et Yaron (1996)}

\item{wmatrix}{Which weighting matrix should be used in the objective function. By default, it is the inverse of the covariance matrix of \eqn{g(\theta,x)}. The other choice is the identity matrix which is usually used to obtain a first step estimate of \eqn{\theta} }

\item{vcov}{Assumption on the properties of the random vector x. By default, x is a weakly dependant process. The "iid" option will avoid using the HAC matrix which will accelerate the estimation if one is ready to make that assumption.}

\item{kernel}{type of kernel used to compute the covariance matrix of the vector of sample moment conditions (see \code{\link{kernHAC}} for more details)}

\item{crit}{The stoping rule for the iterative GMM. It can be reduce to increase the precision.}

\item{bw}{The method to compute the bandwidth parameter. By default it is \code{\link{bwAndrews}} which is proposed by Andrews (1991). The alternative is \code{\link{bwNeweyWest}} of Newey-West(1994).}

\item{prewhite}{logical or integer. Should the estimating functions be prewhitened? If \code{TRUE} or greater than 0 a VAR model of order \code{as.integer(prewhite)} is fitted via \code{ar} with method \code{"ols"} and \code{demean = FALSE}.}

\item{ar.method}{character. The \code{method} argument passed to \code{\link{ar}} for prewhitening.}

\item{approx}{A character specifying the approximation method if the bandwidth has to be chosen by \code{bwAndrews}.}

\item{tol}{Weights that exceed \code{tol} are used for computing the covariance matrix, all other weights are treated as 0.}

\item{itermax}{The maximum number of iterations for the iterative GMM. It is unlikely that the algorithm does not converge but we keep it as a safety.}

\item{optfct}{Only when the dimension of \eqn{\theta} is 1, you can choose between the algorithm \code{\link{optim}} or \code{\link{optimize}}. In that case, the former is unreliable. If \code{\link{optimize}} is chosen, "t0" must be \eqn{1\times 2} which represents the interval in which the algorithm seeks the solution. It is also possible to choose the \code{\link{nlminb}} algorithm. In that case, borns for the coefficients can be set by the options \code{upper=} and \code{lower=}.}

\item{model, X, Y}{logicals.  If \code{TRUE} the corresponding components of the fit (the model frame, the model matrix, the response) are returned if g is a formula.}

\item{TypeGmm}{The name of the class object created by the method \code{getModel}. It allows developers to extand the package and create other GMM methods.}

\item{centeredVcov}{Should the moment function be centered when computing its covariance matrix. Doing so may improve inference.}

\item{weightsMatrix}{It allows users to provide \code{gmm} with a fixed weighting matrix. This matrix must be \eqn{q \times q}, symmetric and strictly positive definite. When provided, the \code{type} option becomes irrelevant. }

\item{...}{More options to give to \code{\link{optim}}.}
}

\details{
If we want to estimate a model like \eqn{Y_t = \theta_1 + X_{2t} \theta_2 + \cdots + X_{k}\theta_k + \epsilon_t} using the moment conditions \eqn{Cov(\epsilon_tH_t)=0}, where \eqn{H_t} is a vector of \eqn{Nh} instruments, than we can define "g" like we do for \code{\link{lm}}. We would have \eqn{g = y ~\tilde{}~ x2+x3+ \cdots +xk} and the argument "x" above would become the matrix H of instruments. As for \code{\link{lm}}, \eqn{Y_t} can be a \eqn{Ny \times 1} vector which would imply that \eqn{k=Nh \times Ny}. The intercept is included by default so you do not have to add a column of ones to the matrix \eqn{H}. You do not need to provide the gradiant in that case since in that case it is embedded in \code{\link{gmm}}. The intercept can be removed by adding -1 to the formula. In that case, the column of ones need to be added manually to H.

The following explains the last example bellow. Thanks to Dieter Rozenich, a student from the Vienna Universtiy of Economics and Business Administration. He suggested that it would help to understand the implementation of the jacobian.  

For the two parameters of a normal distribution \eqn{(\mu,\sigma)} we have the following three moment conditions:
\deqn{
m_{1} = \mu - x_{i}
}
\deqn{ 
m_{2} = \sigma^2 - (x_{i}-\mu)^2
}
\deqn{ 
m_{3} = x_{i}^{3} - \mu (\mu^2+3\sigma^{2}) 
}
\eqn{m_{1},m_{2}} can be directly obtained by the definition of \eqn{(\mu,\sigma)}. The third moment condition comes from the third derivative of the moment generating function (MGF)

\deqn{
    M_{X}(t) = exp\Big(\mu t + \frac{\sigma^{2}t^{2}}{2}\Big)
}

evaluated at \eqn{(t=0)}.

Note that we have more equations (3) than unknown parameters (2).

The Jacobian of these two conditions is (it should be an array but I can't make it work):

\deqn{ 1~~~~~~~~~~ 0 }
\deqn{ -2\mu+2x ~~~~~ 2\sigma }
\deqn{-3\mu^{2}-3\sigma^{2} ~~~~ -6\mu\sigma}
}

\value{
'gmm' returns an object of 'class' '"gmm"' 

The functions 'summary' is used to obtain and print a summary of the results.  It also compute the J-test of overidentying restriction

The object of class "gmm" is a list containing at least:

\item{coefficients}{\eqn{k\times 1} vector of coefficients}

\item{residuals}{the residuals, that is response minus fitted values if "g" is a formula.}

\item{fitted.values}{the fitted mean values if "g" is a formula.}

\item{vcov}{the covariance matrix of the coefficients}

\item{objective}{the value of the objective function \eqn{\| var(\bar{g})^{-1/2}\bar{g}\|^2}}

\item{terms}{the \code{\link{terms}} object used when g is a formula.}

\item{call}{the matched call.}
 
\item{y}{if requested, the response used (if "g" is a formula).}

\item{x}{if requested, the model matrix used if "g" is a formula or the data if "g" is a function.}

\item{model}{if requested (the default), the model frame used if "g" is a formula.}

 }


\references{
  Zeileis A (2006), Object-oriented Computation of Sandwich Estimators.
  \emph{Journal of Statistical Software}, \bold{16}(9), 1--16.
  URL \url{http://www.jstatsoft.org/v16/i09/}.

 Pierre Chausse (2010), Computing Generalized Method of Moments and Generalized Empirical Likelihood with R.
 \emph{Journal of Statistical Software}, \bold{34}(11), 1--35.
 URL \url{http://www.jstatsoft.org/v34/i11/}.

 Andrews DWK (1991),
  Heteroskedasticity and Autocorrelation Consistent Covariance Matrix Estimation.
  \emph{Econometrica}, \bold{59},
  817--858.

 Newey WK & West KD (1987), A Simple, Positive Semi-Definite,
 Heteroskedasticity and Autocorrelation Consistent Covariance
 Matrix. \emph{Econometrica}, \bold{55}, 703--708.

 Newey WK & West KD (1994), Automatic Lag Selection in Covariance
 Matrix Estimation. \emph{Review of Economic Studies}, \bold{61}, 631-653.

  Hansen, L.P. (1982),
  Large Sample Properties of Generalized Method of Moments Estimators.
  \emph{Econometrica}, \bold{50},
  1029-1054,

  Hansen, L.P. and Heaton, J. and Yaron, A.(1996),
  Finit-Sample Properties of Some Alternative GMM Estimators.
  \emph{Journal of Business and Economic Statistics}, \bold{14}
  262-280.
}
\examples{

## CAPM test with GMM
data(Finance)
r <- Finance[1:300, 1:10]
rm <- Finance[1:300, "rm"]
rf <- Finance[1:300, "rf"]

z <- as.matrix(r-rf)
t <- nrow(z)
zm <- rm-rf
h <- matrix(zm, t, 1)
res <- gmm(z ~ zm, x = h)
summary(res)

}

