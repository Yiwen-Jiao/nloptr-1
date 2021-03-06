# Copyright (C) 2014 Hans W. Borchers. All Rights Reserved.
# This code is published under the L-GPL.
#
# File:   varmetric.R
# Author: Hans W. Borchers
# Date:   27 January 2014
#
# Wrapper to solve optimization problem using Varmetric.

varmetric <-
function(x0, fn, gr = NULL, rank2 = TRUE,
            lower = NULL, upper = NULL,
            nl.info = FALSE, control = list(), ...)
{
    opts <- nl.opts(control)
    if (rank2)
        opts["algorithm"] <- "NLOPT_LD_VAR2"
    else
        opts["algorithm"] <- "NLOPT_LD_VAR1"

    fun <- match.fun(fn)
    fn  <- function(x) fun(x, ...)

    if (is.null(gr)) {
        gr <- function(x) nl.grad(x, fn)
    } else {
        .gr <- match.fun(gr)
        gr <- function(x) .gr(x, ...)
    }

    S0 <- nloptr(x0,
                eval_f = fn,
                eval_grad_f = gr,
                lb = lower,
                ub = upper,
                opts = opts)

    if (nl.info) print(S0)
    S1 <- list(par = S0$solution, value = S0$objective, iter = S0$iterations,
                convergence = S0$status, message = S0$message)
    return(S1)
}
