---
layout: media
title: "All 15 home teams win! What are the odds?"
categories: blog
date: 2015-08-13
comments: true
image:
  feature: /blog/hometeams/celeb.jpg
  teaser: /blog/hometeams/celeb.jpg
---

My dad just sent me an article saying that yesterday was the first time in the modern history of Major League Baseball that all 15 home teams won in a single day. Seems pretty incredible, right? To get 15 of 15 winners in a 50/50 contest is a 0.5^15 = 1-in-32,768 shot. To get a better sense of just how rare an event this is, we need to know two things: 1. how often is it possible for it to happen (i.e. all 30 teams play in a day), and 2. when it's possible, what is the probability of it happening (i.e. all 15 home teams winning).

Both are pretty easy to figure out: [This guy](http://newballpark.org/2014/09/10/mlb-2015-travel-grid-schedule-now-available/) makes a convenient csv-formatted version schedule of all regular season MLB games. A couple lines of R code tells us that, for 2015 at least, all 30 teams play on the same day 128 times. [Aside: That seems crazy to me, that of each team's 162 games, 4/5 of them fall on a day when every other team plays. It's a busy season (And there's probably some bias to the weekends, but anyway...)].

And as to the home team advantage, [this guy](http://www.baseball-reference.com/blog/archives/9916) has answered that question. You can't get complete data from that site without a paid subscription, but eyeballing from his graph, I'm estimating that home teams win with an average of 54.2% over the long run. 

So, when all 30 teams play, we should expect all 15 home teams to win 0.542^15  = 1 in every 9,773 times. And with 128 such days per year, we should expect to this happen once every 9,773 / 128 = 76 years. 

So really, it was about time.
