---
layout: media
title: "Teaching R to 200 students in a week"
categories: blog
date: 2015-09-20
comments: true
image:
  feature: teachingBanner.png
  teaser: teachingBanner.png
---

I just taught a week-long "R Bootcamp" to 200 R newbies. It went quite well, and I thought it would be valuable to jot down some thoughts on what worked and what I might change if doing it again.

The course design and my approach to teaching scientific computing in general have been deeply shaped by [Greg Wilson](https://twitter.com/gvwilsons) and the [Software Carpentry](https://software-carpentry.org/) pedagogy, and this was an experiment in scaling that approach. Software/Data Carpentry workshops are typically two days, cover 3-4 computational tools, and have a student:instructor/assistant ratio of about 8:1. Here, we had five days, just one computational tool, and a ratio of about 50:1. The mission was also different. My goals, in descending priority, were to get students:

1. Motivated to struggle through the difficult challenges that inevitably arise when learning a new tool.  
2. Competent helping themselves when they hit an obstacle using R help files/Google/Stack Overflow/R users groups/etc.  
3. Able to go into a statistics class that uses R and be sufficiently fluent that they can wrestle with the concepts instead of (as I've seen over and over) losing the statistical forest for R-syntax trees.

If they hit those three goals, they would be well on their way to using R competently in their research. 

## What worked

#### Motivation precedes detail
Way too many courses start with something like, "These are the atomic data types in R," or "Here are various ways to subset a data frame." It takes an exceptionally motivated student to persevere  through that kind of technical detail without an emotional connection to the payoff for motivation. So, I started with ggplot. Actually I started with a motivational example ("Here's what you're going to learn to do this week") -- extracting each of the students' first names from the registration form, analyzing the change in popularity of each of those names over time using the babynames dataset, and writing a plot for each name to a pdf file. Then we straight into making plots with ggplot. Of course they didn't understand the details, but by 10am on day 1 they were making beautiful plots, which meant that at 2pm on day 1 they were motivated for the hard work of understanding function calls, and at 9am on day 2 they showed up again motivated to dig in.

#### Live coding
The lectures were entirely live-coded in front of the class except two motivating examples. This has many advantages, three of which are really tough to achieve working with, say, code written into a presentation:

1. It shows them that I make mistakes (it's okay, it happens to everyone), and how I fix mistakes (I see that the error popped up after this line and says R expected a string, so I suspect... ).  
2. It builds in flexibility. I can slow down or speed up according to how the students are progressing, and I can field questions and code answers seamlessly.  
3. It forces me to slow down to a speed that happens to be similar to the speed at which they can take in the new material. I -- and I suspect most of us -- still tend toward going too fast even while writing and annotating code, but it is almost impossible to go sufficiently slow if you're not writing the code; it just feels too awkward to stand there silently, doing nothing, while they absorb a line of code that you pre-wrote in a presentation, over and over and over.

#### Live code piped to their browsers
Sometimes they can't make out a character on the projector, or they want to tweak a line of code and see what happens, or they fall behind and need a chunk of code to catch up. To get the code to them, I share a Dropbox direct link to the live script. They pull up that link in their web browser; I save religiously; they refresh when they want an update. There's probably a smoother way to do that, but this works fine. Thanks to [Noam Ross](https://twitter.com/noamross) for the tip on how to do this. 

While coding, I also annotate each line/code chunk to describe what I'm doing/why I'm doing it. This forces me to slow down even more, and I end up explaining what I'm doing with each line twice, verbally and in the annotation. And then when someday they remember something useful from the class and want a reminder of how to do it, they have a reference with which they are already familiar to which they can return. 

#### In-class exercises
Lectures get boring. Computing lectures get really boring, really fast. And coding is a hands-on skill -- you cannot learn to do it by reading or watching someone else do it. So every half-hour to hour I stop, put a step-by-step exercise on the projector, and have them do something similar to what I've just demonstrated, with the difference from what I did growing larger over the course of each day and the week. After they do the exercises, I live code solutions.

#### Stickies and good assistants
Each student gets a red and green sticky-note. During the lecture, a red sticky on the top of their laptop means they need help, and an assistant can come help them without interrupting the class. During the exercises, a red sticky works the same, and a green sticky goes up when they are ready to move on.

I had between one and three assistants in the room throughout. Huge thanks especially to [Myfanwy Rowlands](https://twitter.com/Voovarb), [Mike Koontz](https://twitter.com/_mikoontz), and Nick Ulle, each of whom volunteered a decent chunk of their weeks. It wouldn't have worked without them. I was nervous about the approximately 50:1 student:instructor ratio, but it actually worked fine. We were busy during some of the exercises, but never overwhelmed, and the students having to wait a moment is often useful to get them trying to solve problems themselves.

#### Daily feedback
Each day, I asked the students to fill out a quick survey: How well do you understand what was taught today, what's working for you, and what could use a change? I then start each day showing the class' comprehension from previous days. This shows them I'm listening, and it also shows them where they are in the distribution of students. The latter can help with classroom dynamics, as the students who are struggling realize they shouldn't slow the class down, and the students who are doing well know that if they aren't getting something, most of the students probably aren't either. The plot shows the daily distributions of comprehension, from 1 ("not at all") to 5 ("extremely well'). I'd say day 1 is just about perfect. The students liked day 3, which was a rehash of the day 1 and 2 topics (ggplot and dplyr), and the rehashing is definitely useful for solidifying understanding, but we probably could've done more. On the other hand, I'd rather never see any "1"s.

<figure>
	<img src="/images/blog/teachingR/comprehension_plot.png" style="width:600px">
	<figcaption>Distribution of student-reported comprehension by day</figcaption>
</figure>

#### Advanced exercises
As the week went on, the variance among students increased. Balancing not leaving the quicker students bored and letting the slower students work was tricky. By including some advanced exercises that required finding new functions or using concepts in new ways, the advanced students stayed engaged. 

#### Keeping the curriculum flexible
I planned each day's lesson after finishing the preceding day. This allowed me to respond to the pace the students could keep and, later in the week, to what they wanted to learn. I can't imagine trying to plan everything before the class starts and being unresponsive to how the class is going. This made for a long week with little sleep for me, but I actually found the whole thing energizing.

#### Reinforcing concepts
Once is never enough. They made their first ggplots the first morning, and then they made a bunch more the first afternoon. On day 2 they made more and saw that they are presenting similar information through summary statistics from dplyr's group_by %>% aggregate and ggplot's grouping. On day 4 they plotted the data to generate hypotheses and show model results. All of this helps make conceptual connections among different ways of analyzing data, and the repeated practice solidifies their understanding of how to use tools such as ggplot.

## What I might change

#### dplyr and piping comes later
As I mentioned above, I think it's critical that motivation, which comes primarily from accomplishment, comes before details. So, I did ggplot on day 1 and dplyr on day 2, and after the review on day 3, the students could do the bulk of basic data manipulation and plotting. However, that's a lot of non-standard evaluation to start out with, and the dplyr syntax is basically another language. I think dplyr is great for what it is and is extremely useful beginners (especially group_by %>% summarise), but teaching it so early left students confused about basic stuff around assignment, subsetting, and arguments to functions, and it made the jump to working with lists hard. Next time I would do subsetting, filtering, creating new columns, and frequency tables all in base R early on and introduce dplyr as a convenience later. 

#### RMarkdown comes just a bit later
I introduced RMarkdown, reproducibility, and literate programming on the afternoon of day 1. I like this "theory" coming early, and the students were motivated by being able to produce html documents, but working in a .rmd file is a little less convenient (and less stable) than working in a script; it adds another set of things to understand (chunk options, YAML, etc.); and the document's environment vs. the global environment was confusing. I'd put this maybe late on day 2 or in day 3 instead.

#### More frequent exercises
My plan was to do short exercises in the morning and have the afternoons be just one long set of exercises to work on with help at hand. This quickly changed to about 5 exercises of about five questions each scattered throughout the day. Here is a typical example from day 4:

> ### Putting it all together
- Download the quarterly presidential approval ratings dataset from SmartSite. Load and inspect it, making any necessary changes.
- Is it tidy? If not, tidy it.
- Graphically explore these questions to develop a testable hypothesis:
	- Do the presidents differ in their approval ratings?
	- Do approval ratings vary over time?
	- Is there a seasonal effect of quarter on approval ratings?
- Test your hypothesis using a linear model.
- Summarize your findings with one table and one plot.

This sort of exercise would require about an hour of working time for the students to get through. In the future, I would leave about two exercises of this length in each day, and add a bunch of single-task exercises to break-up the lecture and have them practice individual techniques as they are taught.

#### Keep the statistics out of statistical computing
At the end of day 3, we had done data visualization and manipulation, and I asked the students what they would like to see covered in the next two days. The overwhelming response was statistical modeling. I was conscious of the fact that statistical knowledge varied widely among the students, and I didn't want to teach statistics -- I wanted to provide the R skills to be able to go to a statistics class and not get bogged down in the code. But I thought I could teach how to work with statistical models without teaching statistics. I was basically wrong about that.

I taught lm() and plotting model results, which was fine until I added an interaction effect, which left behind a frighteningly large fraction of the class. I wanted to make the connection between an interaction effect and grouping in ggplot, but you just can't get that without first getting solid on what an interaction effect is, and apparently that's not as straight-forward as I thought. I look forward to teaching a basic stats class that uses R where I can teach these things in concert, but that's a different course. I also tried to teach predict(), which was a disaster. I wanted to show how to work with model objects using just the simplest models (simple regression in this case!), but making predictions from a model requires a firm understanding of how a model works, and adding confidence intervals to the mean vs. a prediction was a bridge way too far. So, you can only teach statistical computing to the extent that the students understand the statistics.

#### In sum
<img src="/images/blog/teachingR/postClass.jpg" style="width:450px; margin:0px 20px"  align="left" title='Students make my day by eating up "I heart R" stickers at the end of the class.'>
The format worked well. The students enjoyed it and learned quite a lot in five days, and it was really satisfying for me to teach. I was pleasantly surprised at how well Software Carpentry tactics scaled to a much larger class, and I was pleasantly reminded of how satisfying teaching is, especially when you believe in the importance of what you're teaching. Thanks to UC Davis' Grad Pathways and Professors for the Future program for making it possible. 

I look forward to teaching this again, perhaps next time as a proper, twice or thrice weekly, quarter-long class, and someday as part of an applied statistics course. I hope. :-)