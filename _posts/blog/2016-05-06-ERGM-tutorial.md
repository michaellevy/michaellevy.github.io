---
layout: media
categories: blog
title: "ERGM Tutorial"
excerpt: "Network management, visualization, and exponential random graph modeling in R with statnet."
date: "2016-05-11"
tags: [rstats, networks, teaching]
comments: true
image:
   teaser: blog/ergm-tutorial/simnets.png
---

This was originally for a talk to the UC Davis [Network Science group](ucdnetworkscience.wikispaces.com/home) on using `statnet` to manage, visualize, and model networks with a focus on exponential random graph models (ERGM). I have cleaned it up a little so that it hopefully stands on its own. If anything is unclear, feel free to leave questions in the comments.

{% include toc.html %}

# Introduction

## Motivation: Why ERGM?

### To predict ties

- As function of individual covariates, e.g. Are girls more popular than boys?

- As function of network structures, e.g. If Adam is friends with Bill, and Bill is friends with Carl, what can we say about the chances of Adam and Carl being friends?
        
### To handle non-independence of observations

Suppose we want to predict a set of dichotomous ties, such as which countries will be at war, and our predictors are actor attributes, such as type of government and difference in defense budgets.

What's wrong with estimating a logistic regression from an *n* x *k* matrix like this?

regime 1 | regime 2 | budget diff | war?
:---:|:---:|:---:|:---:
democracy | democracy | $5e7 | 0
democracy | theocracy | $1e9 | 0
democracy | dictatorship | $2e9 | 1

Even if you're not explicitly interested in how other ties affect the likelihood of a tie, network effects imply a correlation of residuals, so ignoring them will produce biased estimates. Here is a hopefully intuitive example: If the U.S. and U.K. are both at war with Iraq, that fact must be considered for an unbiased estimate of the odds of the U.S. and U.K. being at war with each other.

Cranmer and Desmarais (2011) used ERGM to challenge conventional international-relations wisdom on democracies going to war:

![Cranmer & Desmarais](/images/blog/ergm-tutorial/Cranmer.png)

### To disentangle and quantify exogenous and endogenous effects

- Simultaneously model effect of network structures, actor attributes, and relational attributes

- Get estimates and uncertainty for each effect

### To simulate networks

ERGMs are generative: Given a set of sufficient statistics on network structures and covariates of interest, we can generate networks that are consistent with any set of parameters on those statistics.

## ERGM Output

- Much like a logit (see above table). Coefficients are the change in the (log-odds) likelihood of a tie for a unit change in a predictor.

- Predictors are network-level statistics that represent Markovian processes, so we can think about their changes locally. E.g. in the above table, the estimate of -0.0005 on distance says that the log-odds an edge decreases by 0.0005 for every unit of distance between the nodes. The network statistic that represents that effect is the sum of distances between nodes that have an edge between them.

## Underlying machinery

- For details from a physicist's perspective see Pierre-Andre's talk ([pdf](http://ucdnetworkscience.wikispaces.com/file/view/ERGMs_pan.pdf/576164437/ERGMs_pan.pdf))

- Define joint-likelihood of all ties and assume observed set is expectation

- Choose set of (\\(k\\)) sufficient statistics (\\(\Gamma\\))

- Use MCMC to find parameter values (\\(\theta\\)) for statistics that maximize the likelihood of the set of observed ties (\\(Y_m\\))
    - MCMC provides confidence intervals
  
- Maximize \\(\theta\\):

$$
P(Y_m) = \dfrac{exp(-\sum_{j=1}^k\Gamma_{mj}\theta_j)}{\sum_{m=1}^Mexp(-\sum_{j=1}^k\Gamma_{mj}\theta_j)}
$$

- From parameter estimates, can estimate the probability of any edge:

$$
P(Y_{ij} | Y_{-ij}, \theta) = logistic \sum_{h=1}^{k}\theta_{h}\delta_{h}^{ij}(Y)
$$

That not only allows us to calculate the probability of tie for a particular dyad, but but also to aggregate tie-probabilities arbitrarily by calculating probabilities for every dyad in the network and then summarizing the probabilities by whatever is of interest.

# Using `statnet`

## Network Data Management



Load statnet suite of packages, includes network, sna, ergm, and more:


{% highlight r %}
library(statnet)
{% endhighlight %}

Load a sample dataset. Vertices are monks in a monastery, and edges are self-reported liking between the monks. Typing the name of the network object provides some descriptive info. 


{% highlight r %}
data('sampson')
n = samplike
n
{% endhighlight %}



{% highlight text %}
##  Network attributes:
##   vertices = 18 
##   directed = TRUE 
##   hyper = FALSE 
##   loops = FALSE 
##   multiple = FALSE 
##   total edges= 88 
##     missing edges= 0 
##     non-missing edges= 88 
## 
##  Vertex attribute names: 
##     cloisterville group vertex.names 
## 
##  Edge attribute names: 
##     nominations
{% endhighlight %}

What attributes do nodes in this network have?


{% highlight r %}
list.vertex.attributes(n)
{% endhighlight %}



{% highlight text %}
## [1] "cloisterville" "group"         "na"            "vertex.names"
{% endhighlight %}

Accessing a nodal attribute's values:


{% highlight r %}
get.vertex.attribute(n, 'cloisterville')   # Whether they attended cloisterville before coming to the monestary
{% endhighlight %}



{% highlight text %}
##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE
## [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE
{% endhighlight %}

For most attribute methods, you can mix and match levels: `vertex`, `edge`, and `network`, and what you want to do: `get`, `set`, `delete`, `list`. E.g. 


{% highlight r %}
set.vertex.attribute(n, 'integers', 1:network.size(n))
get.vertex.attribute(n, 'integers')
delete.vertex.attribute(n, 'integers')
{% endhighlight %}

More info on functions to view and change attributes of networks, vertices, and edges: `?attribute.methods`.

A convenient shortcut: `n %v% 'group'` is identical to `get.vertex.attribute(n, 'group')` (and retrieves the values of the group attribute of nodes. `%e%` and `%n%` function the same way for edges and network, respectively. These shortcuts can be used for both assignment and retrieval.


## Plotting

`statnet` has pretty decent plotting facilities, at least on par with `igraph`, I think. The full set of options is available at `?plot.network`. The following code demonstrates a few of my common specifications: put names on labels (by default, the "vertex.names" vertex attribute), size nodes to their in-degree, color by group (another vertex attribute), and shape nodes by whether they were in cloisterville (4 sides are squares, 50 sides are basically circles). `pad` protects the labels from getting clipped.


{% highlight r %}
plot(n
     , displaylabels = TRUE
     , vertex.cex = degree(n, cmode = 'indegree') / 2
     , vertex.col = 'group'
     , vertex.sides = ifelse(n %v% 'cloisterville', 4, 50)
     , pad = 1
)
{% endhighlight %}

![plot of chunk unnamed-chunk-7](/assets/Rfig/ERGM-tutorial//unnamed-chunk-7-1.svg)

# ERGM

## Estimation and Interpretation

Estimate the simplest model, one with only a term for tie density (akin to an intercept term in a glm):


{% highlight r %}
m1 = ergm(n ~ edges)
summary(m1)
{% endhighlight %}



{% highlight text %}
## Evaluating log-likelihood at the estimate. 
## 
## ==========================
## Summary of model fit
## ==========================
## 
## Formula:   n ~ edges
## 
## Iterations:  4 out of 20 
## 
## Monte Carlo MLE Results:
##       Estimate Std. Error MCMC % p-value    
## edges  -0.9072     0.1263      0  <1e-04 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##      Null Deviance: 424.2  on 306  degrees of freedom
##  Residual Deviance: 367.2  on 305  degrees of freedom
##  
## AIC: 369.2    BIC: 372.9    (Smaller is better.)
{% endhighlight %}

Because that is a dyadic-independent model (the likelihood of a tie doesn't depend on any other), ergm solves the logistic regression instead of resorting to MCMC.

Note that the edges term represents exactly the density of the network (in log-odds). That is, the probability of any tie (aka the density of the network) is the inverse-logit of the coefficient on edges:


{% highlight r %}
all.equal(network.density(n), plogis(coef(m1)[[1]]))
{% endhighlight %}



{% highlight text %}
## [1] TRUE
{% endhighlight %}

Now let's make things more interesting and estimate a term for reciprocity of ties. That is, given an i -> j tie, what is the change in log-odds likelihood of a j -> i tie? The coefficient estimate on `mutual` tells us exactly that:


{% highlight r %}
m2 = ergm(n ~ edges + mutual)
summary(m2)
{% endhighlight %}



{% highlight text %}
## Starting maximum likelihood estimation via MCMLE:
## Iteration 1 of at most 20: 
## The log-likelihood improved by 0.0002026 
## Step length converged once. Increasing MCMC sample size.
## Iteration 2 of at most 20: 
## The log-likelihood improved by 0.0007232 
## Step length converged twice. Stopping.
## Evaluating log-likelihood at the estimate. Using 20 bridges: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 .
## 
## This model was fit using MCMC.  To examine model diagnostics and check for degeneracy, use the mcmc.diagnostics() function.
## 
## ==========================
## Summary of model fit
## ==========================
## 
## Formula:   n ~ edges + mutual
## 
## Iterations:  2 out of 20 
## 
## Monte Carlo MLE Results:
##        Estimate Std. Error MCMC % p-value    
## edges   -1.7634     0.2047      0  <1e-04 ***
## mutual   2.3290     0.4154      0  <1e-04 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##      Null Deviance: 424.2  on 306  degrees of freedom
##  Residual Deviance: 332.3  on 304  degrees of freedom
##  
## AIC: 336.3    BIC: 343.7    (Smaller is better.)
{% endhighlight %}

Whoa, something different happened there! MCMC happened. `ergm` went off and did a bunch of simulations to find approximate MLE coefficients. Let's interpret them. The baseline probability of a tie now is


{% highlight r %}
plogis(coef(m2)[['edges']])
{% endhighlight %}



{% highlight text %}
## [1] 0.1463638
{% endhighlight %}

But if the reciprocal tie is present, then the log odds of the tie is 2.32x greater, which we can translate into probability using the logistic function:


{% highlight r %}
plogis(coef(m2)[['edges']] + coef(m2)[['mutual']])
{% endhighlight %}



{% highlight text %}
## [1] 0.6377387
{% endhighlight %}

Much more likely: 64% chance, compared to the baseline of 15%.

Before we start writing up our submission to *Science* though, we need to check two things: 1) that the MCMC routine behaved well (that our estimates are likely good approximations of the MLEs), and 2) that our model fits the data well. `statnet` has functions to do both those things.

## Checking MCMC chains

We use the `mcmc.diagnostics` function to get info on the MCMC chains, which by default are presented both graphically and through summary statistics. The statistics can be quite useful, but for simplicity here I'm going to silence them and focus on the trace plots of the chains.


{% highlight r %}
mcmc.diagnostics(m2)
{% endhighlight %}

![plot of chunk unnamed-chunk-13](/assets/Rfig/ERGM-tutorial//unnamed-chunk-13-1.svg)

We look for the same things as in any MCMC estimation: well-mixed, stationary chains. These look great -- the chains thoroughly explore the parameter space and don't wander over the course of the simulation. If your chains wander, you might A) have an ill-specified model, and/or B) be able to improve things by increasing the length of the MCMC routine or changing other parameters, which you can control via the `control` argument to `ergm`. Here's a (silly) example to show how to change the MCMC parameters and what bad chains look like:


{% highlight r %}
mbad = ergm(n ~ edges + mutual,
            control = control.ergm(MCMC.interval = 2))
mcmc.diagnostics(mbad)
{% endhighlight %}

![plot of chunk unnamed-chunk-14](/assets/Rfig/ERGM-tutorial//unnamed-chunk-14-1.svg)

See `?control.ergm` for the many customizable details of estimation.

## Examining model fit

Now that we can trust our model estimates, let's see if they make a good fit to the data. We use the `gof` (goodness-of-fit) function for this purpose. `gof` simulates networks from the ERGM estimates and, for some set of network statistics, compares the distribution in the simulated networks to the observed values.

The current `gof` implementation has two useful modalities, one checks goodness-of-fit against the statistics included in the model (in aggregate), for which the text output is usually sufficient. Note that a p-value closer to one is better: This is the difference between the observed networks and simulations from the model.


{% highlight r %}
m2_gof = gof(m2, GOF = ~model)
m2_gof
{% endhighlight %}



{% highlight text %}
## 
## Goodness-of-fit for model statistics 
## 
##        obs min  mean max MC p-value
## edges   88  63 88.26 116       0.94
## mutual  28  18 28.47  42       1.00
{% endhighlight %}

The other `gof` modality checks goodness-of-fit against some standard summary statistics -- by default: degree, edgewise shared partners, and path length -- decomposed to the components of the distributions. Plotting these is often quite informative. The black lines are the observed distributions and the boxplots reflect networks simulated from the model.


{% highlight r %}
m2_gof2 = gof(m2)
par(mfrow = c(2, 2))
plot(m2_gof2)
{% endhighlight %}

![plot of chunk unnamed-chunk-16](/assets/Rfig/ERGM-tutorial//unnamed-chunk-16-1.svg)

To change which statistics are included, specify them as a model formula to the `GOF` argument to the `gof` function. E.g. `gof(m2, GOF = ~ triadcensus + odegree + idegree)`. The list of supported statistics is available in the help file for `gof`.

## Simulating networks

Another nice feature of ERGMs is that they are generative. Given a set of coefficient values, we can simulate networks that are near the maximum likelihood realization of sufficient statistics. This can be useful for examining fit, among other things, and is easy using the S3 method for `simulate` for an `ergm` object. In addition to checking model fit, you can change parameter values, constrain the network in various ways, etc. See `?simulate.ergm` for details.

Simulate four networks that are consistent with our model and plot them, as we plotted the observed network above:


{% highlight r %}
sim_nets = simulate(m2, nsim = 4)

# Define a plotting function:
plot_nets = function(n)
    plot(n
     , displaylabels = FALSE
     , vertex.cex = degree(n, cmode = 'indegree') / 2 + 1
     , vertex.col = 'group'
     , vertex.sides = ifelse(n %v% 'cloisterville', 4, 50)
     )

par(mfrow = c(2, 2))
invisible(lapply(sim_nets, plot_nets))  # I wrap that in `invsible()` because `plot.network` returns the coordinates of nodes in the plot, which can be useful for reproducability or programmatic manipulation, but is distracting here.
{% endhighlight %}

![plot of chunk unnamed-chunk-17](/assets/Rfig/ERGM-tutorial//unnamed-chunk-17-1.svg)

Visualizing those simulated networks makes it clear we're not getting the monks into their groups. We can accomplish that by including a term for group homophily. This kind of iterative estimation and checking of fit is part of the art of ERGMing (and should be for model fitting in general, I think).

For a complete list of ready-to-use statistics, see `?ergm.terms`. If you don't see what you want, you can roll your own using the `ergm.userterms` package. To do so requires a bit of C, but really isn't too bad (assuming the statistic you want calculate is simple).
 
To add a term for homophily within Sampson's groups we use the term `nodematch`, which takes at least one argument (the nodal attribute), and provides the change in the likelihood of a tie if the two nodes match on that attribute. Note that you can estimate a differential homophily effect; that is, the change in tie likelihood for two nodes being in the same group can vary by group, by specifying the `diff = TRUE` argument to `nodematch`.

Before we estimate the model, a handy trick: Remember that ERGM works by calculating network-level statistics. You can get the values of those statistics using the S3 method for `summary` for an ERGM formula:


{% highlight r %}
summary(n ~ edges + mutual + nodematch('group'))
{% endhighlight %}



{% highlight text %}
##           edges          mutual nodematch.group 
##              88              28              63
{% endhighlight %}

So of the 88 ties in the network, 28 of them are reciprocal, and 63 of them are between monks within a group. So we should expect a strong positive coefficient for the group-homophily term. Let's see:


{% highlight r %}
m3 = ergm(n ~ edges + mutual + nodematch('group'))
{% endhighlight %}


{% highlight r %}
summary(m3)
{% endhighlight %}



{% highlight text %}
## 
## ==========================
## Summary of model fit
## ==========================
## 
## Formula:   n ~ edges + mutual + nodematch("group")
## 
## Iterations:  2 out of 20 
## 
## Monte Carlo MLE Results:
##                 Estimate Std. Error MCMC % p-value    
## edges            -2.2638     0.2277      0 < 1e-04 ***
## mutual            1.4309     0.4740      0 0.00276 ** 
## nodematch.group   2.0316     0.3103      0 < 1e-04 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##      Null Deviance: 424.2  on 306  degrees of freedom
##  Residual Deviance: 268.4  on 303  degrees of freedom
##  
## AIC: 274.4    BIC: 285.6    (Smaller is better.)
{% endhighlight %}

Indeed. The log-odds of a within-group tie are 2x greater than an across-group tie. We can exponentiate to find the change in the odds,  `exp(coef(m3)[3])` = 7.63. The change in the odds is true independent of the other attributes of the tie (e.g. whether or not it is reciprocal). The probability of a tie, however, is non-linear: it depends on the value of other statistics, so to calculate a change in probability you must choose a value for every other statistic in the model, then you can use the inverse-logit to find the difference in probability across your effect of interest. E.g. Let's look at the probability of non-reciprocal ties within- and across-groups:

Probability of a non-reciprocal, across-group tie:


{% highlight r %}
plogis(coef(m3)[1])
{% endhighlight %}



{% highlight text %}
##      edges 
## 0.09416372
{% endhighlight %}

Probability of a non-reciprocal, within-group tie:


{% highlight r %}
plogis(sum(coef(m3)[c(1, 3)]))  
{% endhighlight %}



{% highlight text %}
## [1] 0.442199
{% endhighlight %}

Let's take a look at the goodness of fit of that model:


{% highlight r %}
par(mfrow = c(2, 2))
invisible(plot(gof(m3)))
{% endhighlight %}

![plot of chunk unnamed-chunk-23](/assets/Rfig/ERGM-tutorial//unnamed-chunk-23-1.svg)

We're not capturing the variance in in-degree -- the most popular monks in our simulated networks are not as popular as in the data. Two-stars can be used to represent popularity (because the more edges on a node, the more two stars an additional edge will create):


{% highlight r %}
m4 = ergm(n ~ edges + mutual + nodematch('group') + istar(2))
{% endhighlight %}


{% highlight r %}
summary(m4)
{% endhighlight %}



{% highlight text %}
## 
## ==========================
## Summary of model fit
## ==========================
## 
## Formula:   n ~ edges + mutual + nodematch("group") + istar(2)
## 
## Iterations:  2 out of 20 
## 
## Monte Carlo MLE Results:
##                 Estimate Std. Error MCMC %  p-value    
## edges           -3.67834    0.35402      0  < 1e-04 ***
## mutual           1.53178    0.42420      0 0.000357 ***
## nodematch.group  2.20809    0.31874      0  < 1e-04 ***
## istar2           0.27079    0.03945      0  < 1e-04 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##      Null Deviance: 424.2  on 306  degrees of freedom
##  Residual Deviance: 258.3  on 302  degrees of freedom
##  
## AIC: 266.3    BIC: 281.2    (Smaller is better.)
{% endhighlight %}



{% highlight r %}
# GOF plots:
par(mfrow = c(2, 2))
invisible(plot(gof(m4)))
{% endhighlight %}

![plot of chunk unnamed-chunk-25](/assets/Rfig/ERGM-tutorial//unnamed-chunk-25-1.svg)

Let's simulate some networks from that model and see what they look like:


{% highlight r %}
sim_nets = simulate(m4, nsim = 4)
par(mfrow = c(2, 2))
invisible(lapply(sim_nets, plot_nets)) 
{% endhighlight %}

![plot of chunk unnamed-chunk-26](/assets/Rfig/ERGM-tutorial//unnamed-chunk-26-1.svg)

## Model comparison

Is the fit getting better? Looks like it, but hard to say, and there is danger of overfitting here as elsewhere. Can use formal model comparison as with other models:


{% highlight r %}
round(sapply(list(m1, m2, m3, m4), AIC), 0)
{% endhighlight %}



{% highlight text %}
## [1] 369 336 274 266
{% endhighlight %}

## Model degeneracy and geometerically-weighted terms

Model degeneracy is a major problem for ERGMs. Degeneracy refers to a case where the MLE for the specified sufficient statistics produce graphs that are either complete, or empty, or have all edges concentrated in a small region of the graph, or otherwise produce networks that are not of interest. Handcock's 2003 *Assessing Degeneracy in Statistical Models of Social Networks* ([pdf](https://www.csss.washington.edu/Papers/2003/wp39.pdf)) is an excellent early treatment of the issue. It is a sign of an ill-specified model, but unfortunately we often want estimates for theoretically justified reasons that we cannot get due to degeneracy issues. The quintessential such term is for triangles: How does the likelihood of a friendship change if two people already have a friend in common? For this small of a network we can estimate that directly:


{% highlight r %}
m5 = ergm(n ~ edges + mutual + nodematch('group') + istar(2) + triangles)
{% endhighlight %}


{% highlight r %}
summary(m5)
{% endhighlight %}



{% highlight text %}
## 
## ==========================
## Summary of model fit
## ==========================
## 
## Formula:   n ~ edges + mutual + nodematch("group") + istar(2) + triangles
## 
## Iterations:  2 out of 20 
## 
## Monte Carlo MLE Results:
##                 Estimate Std. Error MCMC % p-value    
## edges           -3.79191    0.47633      0 < 1e-04 ***
## mutual           1.59482    0.51259      0 0.00204 ** 
## nodematch.group  3.64250    0.66687      0 < 1e-04 ***
## istar2           0.43567    0.07368      0 < 1e-04 ***
## triangle        -0.23436    0.07482      0 0.00190 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##      Null Deviance: 424.2  on 306  degrees of freedom
##  Residual Deviance: 245.8  on 301  degrees of freedom
##  
## AIC: 255.8    BIC: 274.5    (Smaller is better.)
{% endhighlight %}

In this case, having a shared friend makes a monk *less* likely to report liking another monk (\\(\theta_{triangle} < 0\\)), after the other effects are accounted for. That is very rare for networks with positively-valenced ties. It is also rare that non-degenerate estimates are possible for models with triangles, particularly for graphs larger than a few dozen nodes. 

That may not be as much of a substantive problem as it seems. The implication of a triangles term is that the likelihood of tie changes proportionately to the number of shared friends two people have. That is, if having one shared friend makes a tie 25% more likely, having six shared friends makes a tie 150% more likely. Perhaps we should discount each additional tie. We can do that with the geometrically-weighted edgewise shared partners (gwesp) term. It takes a parameter, \\(\alpha\\) that controls how much to discount 2nd, 3rd, etc. shared partners. `ergm` will estimate a value for \\(\alpha\\) by default, but this is generally not a good idea; instead fix it via the `fixed` argument to `gwesp`. The closer \\(\alpha\\) is to zero, the more dramatic the discounting applied to subsequent shared partners. 


{% highlight r %}
m6 = ergm(n ~ edges + mutual + nodematch('group') + gwesp(alpha = .5, fixed = TRUE))
{% endhighlight %}


{% highlight r %}
summary(m6)
{% endhighlight %}



{% highlight text %}
## 
## ==========================
## Summary of model fit
## ==========================
## 
## Formula:   n ~ edges + mutual + nodematch("group") + gwesp(alpha = 0.5, 
##     fixed = TRUE)
## 
## Iterations:  2 out of 20 
## 
## Monte Carlo MLE Results:
##                 Estimate Std. Error MCMC % p-value    
## edges            -1.9489     0.3819      0 < 1e-04 ***
## mutual            1.3992     0.4747      0 0.00345 ** 
## nodematch.group   2.3202     0.4375      0 < 1e-04 ***
## gwesp.fixed.0.5  -0.2142     0.2008      0 0.28691    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##      Null Deviance: 424.2  on 306  degrees of freedom
##  Residual Deviance: 267.2  on 302  degrees of freedom
##  
## AIC: 275.2    BIC: 290    (Smaller is better.)
{% endhighlight %}

Similarly, geometrically weighted degree (gwdegree) estimates the change in tie likelihood given the degree of the nodes involved, but with marginally decreasing weighting as degree increases. Like triangles, two-stars often produces degeneracy for all but the smallest graphs; gwdegree can circumvent this problem. It takes a parameter related to gwesp's \\(\alpha\\), decay, which should also generally be fixed. The closer decay is to zero, the more gwdegree considers low degree nodes relative to high degree nodes. For undirected networks, the term is `gwdegree`; for directed networks, in- and out-degree are modeled separately via `gwidegree`, and `gwodegree`, respectively. These terms can be useful for modeling a popularity effect, but they are often, perhaps unfortunately, used simply to aid model convergence. 


{% highlight r %}
m7 = ergm(n ~ edges + mutual + nodematch('group') + 
              gwesp(alpha = .5, fixed = TRUE) + gwidegree(decay = 1, fixed = TRUE))
{% endhighlight %}

{% highlight r %}
summary(m7)
{% endhighlight %}



{% highlight text %}
## 
## ==========================
## Summary of model fit
## ==========================
## 
## Formula:   n ~ edges + mutual + nodematch("group") + gwesp(alpha = 0.5, 
##     fixed = TRUE) + gwidegree(decay = 1, fixed = TRUE)
## 
## Iterations:  2 out of 20 
## 
## Monte Carlo MLE Results:
##                 Estimate Std. Error MCMC % p-value    
## edges            -1.1466     0.4544      0 0.01215 *  
## mutual            1.3940     0.4869      0 0.00449 ** 
## nodematch.group   2.6517     0.4589      0 < 1e-04 ***
## gwesp.fixed.0.5  -0.4338     0.1804      0 0.01680 *  
## gwidegree        -3.0532     0.9595      0 0.00162 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##      Null Deviance: 424.2  on 306  degrees of freedom
##  Residual Deviance: 260.8  on 301  degrees of freedom
##  
## AIC: 270.8    BIC: 289.4    (Smaller is better.)
{% endhighlight %}

The way the `gwdegree` terms are constructed, negative estimates reflect an increased likelihood on ties to higher-degree nodes. Appropriate use and interpretation of the gw- terms is tricky, and I am working on a paper with more detailed guidance, which I will be presenting at PolNet 2016. For now, [Hunter, 2007](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2031865/) is an excellent reference, and the [statnet listserve](https://mailman13.u.washington.edu/mailman/private/statnet_help/) is quite friendly and has a rich archive of discussions online.

I hope this has been helpful. Feel free to leave questions below.
