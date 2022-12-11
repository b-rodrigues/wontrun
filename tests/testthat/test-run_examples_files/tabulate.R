### Name: tabulate
### Title: Tabulation for Vectors
### Aliases: tabulate
### Keywords: arith

### ** Examples

tabulate(c(2,3,5))
tabulate(c(2,3,3,5), nbins = 10)
tabulate(c(-2,0,2,3,3,5))  # -2 and 0 are ignored
tabulate(c(-2,0,2,3,3,5), nbins = 3)
tabulate(factor(letters[1:10]))



