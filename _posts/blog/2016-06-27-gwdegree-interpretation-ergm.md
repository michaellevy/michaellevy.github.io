---
layout: media
title: "A Shiny app to help interpret GW-Degree estimates in ERGMs"
excerpt: "Most researchers have the relationship between network centralization and GW-Degree estimates exactly backwards. Here is a Shiny app and conference poster that show how to correctly interpret GW-Degree."
modified: "2016-06-27"
categories: blog
comments: true
tags: [networks, shiny, rstats]
image:
  feature:  
  teaser:  blog/gwdegree/degreeDistribution.png
---

Most researchers are misinterpreting geometrically weighted degree (GWD) estimates in exponential random graph models (ERGMs) of networks. By a 3:1 ratio papers cite positive estimates of GWD as indicative of a popularity or centralization force; in fact, positive estimates indicate dispersion of edges.

### Shiny app

[Here is a Shiny app](https://michaellevy.shinyapps.io/gwdegree/) that allows you to examine the effects of GWD parameter and decay-parameter values on network degree distributions. On the app's other tabs, it provides some intuition on how the GWD statistic works and how GWD and GWESP -- which is used to model triadic closure -- are confounded.

### Poster

I presented this research at the 2016 Political Networks conference. Check out the poster, which includes a literature review showing how prevalent this mistake is, by clicking on the image.

[![PolNet Poster on GWDegree Interpretation](/images/blog/gwdegree/gwdegreePoster.png)](https://figshare.com/articles/Interpretation_of_GW-Degree_Estimates_in_ERGMs/3465020)

<br>

### App use and local deployment

You can play with the Shiny app online through the above link, but if you're going to use it extensively, it will be faster and more reliable to clone the app and run it locally. Instructions for that are at the [GitHub repo](https://github.com/michaellevy/GWDegree-Shiny). Because the ERGM simulations and estimations are computationally expensive, I've restricted network size and density limits and simulation parameters pretty heavily for the online version. If you'd like a version of the app that relaxes those restrictions, send me a message to spur me to build that out.

Here are my imagined uses for the app, besides just trying to providing some intuition on how the statistic and parameters behave.

- Before estimating ERGMs, enter observed network size and density and compare empirical degree distribution to those generated under a range of decay, \\(\theta_S\\), and GWD, \\(\theta_{GWD}\\), values.

- After estimating ERGMs, enter estimated parameter values and compare degree distribution under the null hypothesis of a random graph to the degree distribution implied by GWD estimates.


