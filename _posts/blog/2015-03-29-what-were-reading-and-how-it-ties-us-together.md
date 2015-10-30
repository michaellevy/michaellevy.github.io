---
layout: media
title: "What we're reading -- and how it ties us together"
categories: blog
date: 2015-03-29
comments: true
image:
  teaser: /blog/journalNets/tease.png

---

tl;dr: Network of an interdisciplinary environmental social science lab as tied together by the journals we read. A few key journals, especially Social Networks, hold us together. R code follows.

The [Center for Environmental Policy and Behavior](http://environmentalpolicy.ucdavis.edu/), my grad lab, is remarkably interdisciplinary. For some sense of our breadth, consider that our nine core graduate students represent five different graduate programs: Ecology, Geography, Hydrology, Political Science, and Transportation Technology and Policy. That's great for many reasons, not least that it's an intellectually exciting environment in which to live, but it sometimes leaves me wondering what ties us together. So I thought I'd see if the journals we read could answer that question.

I asked everyone in the lab what journals they routinely read and used the responses to construct a bipartite network (with people and journals being the two modes). This was my first time working with bipartite network data, so I played around with different projections, visualizations, and centrality measures to get a better understanding of how we fit together via what we read, as well as how different approaches to examining bipartite networks succeed and fail.

Here's the raw bipartite network, with people in red and journals in blue. What immediately stands out is that most of the lab is reading a whole bunch of stuff that no one else in the lab is reading. That's potentially really useful -- we go off and gather information and methods from different fields and bring back the best of it (hopefully) to share. The risk is that people might feel isolated and/or lack opportunities for conversations about their interests, and there's often no one to fall back on in case you missed or misunderstood something (ie, there's a lack of redundancy). To some extent those risks are ameliorated by other contacts -- many of us have secondary labs we interact with, and there are also our graduate groups, various IGERTs, classes, campus initiatives, etc. -- but since we share office space we naturally spend most of our workdays interacting within the lab, so these contacts (I suspect) represent the bulk of our academic contact.

<figure>
	<img src="/images/blog/journalNets/twomode.png">
	<figcaption>Bipartite network of CEPB lab members and the journals we read</figcaption>
</figure>

Having noted how much of each person's reading is unique to them, let's clean things up by removing those journals. We are left with only journals that two or more people read. Now it's easy to see communities and the key journals that connect them. In very rough terms, we've got an ecology cluster in the upper left around Ecology and Society; a small political science cluster below it around APSR; perhaps a climate change community in the lower left; a policy/governance community on the right; and network analysis up top. 

<figure>
	<img src="/images/blog/journalNets/twomode_trimmed.png">
	<figcaption>As above, minus journals read by only one person</figcaption>
</figure>

To get a better sense of how the people in the lab are connected through journals, I plotted a one-mode projection of the bipartite network. I don't love statnet for visualization. It is adequate for basic stuff like the above plots, but it's not what it's built for. I don't particularly like iGraph's visualizations either, and I wanted to keep the workflow in R, which as far as I know rules out Gephi, so I did a bit of searching and stumbled upon [ggnet](https://github.com/briatte/ggnet) -- a ggplot implementation (via the [GGally](http://cran.r-project.org/web/packages/GGally/index.html) package) of network plotting. It doesn't nearly harness all the power of ggplot, and it only took a couple minutes to run into its limits, but it's a nice start and so far for me at least, it beats statnet's native plotting functions.

One thing that stands out here is (reassuringly) that the two professors who run the lab are at the center of the network. No surprise there. There also seems to be a major community formed around the Ecology Graduate Group... All of the graduate students and alumni in the lower-right part of the graph are/were Ecology students. I suspect my (Michael) centrality in the network is largely a function of my having seen everyone else's lists of journals before creating my own, making the most common titles easily accessible to me when I was writing my list.

<figure>
	<img src="/images/blog/journalNets/people.png">
	<figcaption>One mode projection of bipartite network: Lab members are connected by shared journals. Node color reflects position in the lab; edge thickness reflects number of shared journals.</figcaption>
</figure>

Rather than just speculating, let's bring some network analysis tools to bear on the question of what the key journals are. I calculated three commonly-used centrality scores for all the journals mentioned by more than one person, first on a one-mode projection of journals, then for journals in the two-mode network. 

By all measures, Social Networks is the most central journal in our lab. This is interesting. A majority of lab members use social network analysis (SNA) as a primary tool, and on one hand, it makes sense that for a group whose topics differ, a methodological approach unites. On the other hand, there are quite a few people in the lab who don't use SNA at all, and given that we are the Center for Environmental Policy and Behavior, one might expect a policy- and/or environment-focused journal to be more central. 

PNAS, being a fully interdisciplinary journal, ranks unsurprisingly high. I find it interesting though that its eigenvector (EV) centrality is lower than the other measures. EV centrality gets at how central the nodes you connect to are, so perhaps it makes sense that a journal that many people look at but is of key importance for no one ranks lower on EV centrality than degree centrality. Conversely, PSJ has high EV centrality but scores somewhat lower by the other measures, I suspect on account of its connecting Gwen at the network core to the non-Ecology part of the network. Finally, Ecology and Society ranks highly across measures, due its being nominated by many people in the "ecology community" of the lab.

I'm not sure why eigenvector centrality scores couldn't be calculated for the bipartite network, but statnet threw a warning message about matrix pathology, and there's clearly something wrong since AJPS is structurally equivalent to JPART but their scores are different. 

<figure>
	<img src="/images/blog/journalNets/centralities.png">
	<figcaption>Three centrality scores for journals calculated on the one-mode journal projection (left) or the bipartite network (right). Eigenvector centrality could not be calculated for the bipartite network.</figcaption>
</figure>

Here are the R scripts I wrote for these analyses. They should be plug-and-play if you want to do a similar analysis for your lab, or any bipartite network for that matter. The input file, journalsByPerson.csv, is structured with names in the first row and the journals each person reads listed under their names.

I try to code by the "don't repeat yourself" maxim, but at the end of the first script, I manually call a plotting function repeatedly with different arguments. I know there's a way to do it with do.call(), but I got too fed up trying to structure the arguments list and had to move on. Suggestions are welcome.

#### Main script
{% highlight r %}
source("labJournals_fx.R")

# Read the data and get into network object
d = read.csv("journalsByPerson.csv", 
                    header = TRUE,
                    stringsAsFactors = FALSE) 
el = 
  melt(d, id.vars = NULL,
       value.name = "Journal", variable.name = "Person")
el = el[el$Journal != "", ]

net2mode = bipartiteConstructor(el)

# Plot two-mode network:
png("labJournalsNetwork2mode.png", width = 800, height = 600)
plot(net2mode, 
     displaylabels = TRUE,
     vertex.col = "vertex.mode",
     label.cex = 
       ifelse(network.size(net2mode) > 40, 0.67, 1)
     )
dev.off()

# How do people connect via journals?
peopleNet = bipartiteProjector(el, mode = 1)
peopleNet %v% 'vertex.names'
peopleNet %v% "role" = 
  c('professor', 'postdoc', 'grad student', 'professor', 'postdoc',
    'grad student', 'visiting scholar', 'alumni', 'grad student',
    'grad student', 'grad student', 'grad student', 'alumni')
png("labJournalsNetworkPeople.png", width = 750)
ggnet(peopleNet, 
      label.nodes = TRUE, 
      col = 'black',  # Node-label color
      node.group = peopleNet %v% "role",
      segment.size = peopleNet %e% 'value',
      legend.position = c(0.05, .9))
dev.off()

# How do journals connect via people?
journalNet = bipartiteProjector(el, mode = 2)
plot(journalNet, displaylabels = TRUE, label.cex = .6)  # That's a mess

## ID journals mentioned by more than one person
multiMentionJournals =
  data.frame(Journal = net2mode %v% "vertex.names",
             Degree = degree(net2mode) / 2,
             type = net2mode %v% "vertex.mode") %>%
  filter(type == "Journal",
         Degree > 1) %>%
  .$Journal %>%
  as.character

# Journal centralities from one-mode projection w/o trimming
journalCentralities = centralityCalculator(journalNet) %>%
  filter(Journal %in% multiMentionJournals)

# Or, are centrality measures of the journals in the 2-mode network is more revealing?
# But we don't want people's one-off journals to be weighting the network, so
# trim journals to only those that are mentioned by multiple people. That should 
# help with visualization too. 

trimmed2mode = bipartiteConstructor(el, trimJournals = TRUE)
png("labJournalsNetwork2mode_trimmed.png", width = 700)
plot(trimmed2mode,
     displaylabels = TRUE,
     vertex.col = "vertex.mode",
     label.cex = .85)
dev.off()

centralities2mode = centralityCalculator(trimmed2mode) %>%
  filter(Journal %in% multiMentionJournals)  # To get rid of people

png("JournalCentralities.png", height = 800, width = 800)
par(mfcol = c(3, 2))
dotplotter(journalCentralities, "Degree")
dotplotter(journalCentralities, "Eigenvector")
dotplotter(journalCentralities, "Betweenness")
dotplotter(centralities2mode, "Degree")
dotplotter(centralities2mode, "Eigenvector")
dotplotter(centralities2mode, "Betweenness")
mtext("One-mode projection \t\t\t\t Bipartite network",
      line = -2, outer = TRUE, cex = 1.33)
dev.off()
{% endhighlight %}

#### Functions
{% highlight r %}
# This is labJournals_fx.R

library(statnet)
library(dplyr)
library(reshape2)
library(GGally)

# Define a function to construct 2-mode network
bipartiteConstructor = function(edgeList, trimJournals = FALSE) {
  if(trimJournals) {
    keep =
      edgeList %>%
      group_by(Journal) %>%
      summarize(ct = n()) %>%
      filter(ct > 1) %>%
      .$Journal
    edgeList = filter(edgeList, Journal %in% keep)
  }
  # Tag names of people to later define node class (people vs. journals):
  edgeListTagged = mutate(edgeList, Person = paste0("Member-", edgeList$Person))
  net2mode = 
    network(edgeListTagged, 
            bipartite = length(unique(edgeList$Person)), 
            directed = FALSE)
  people = grep("^Member", net2mode %v% "vertex.names")
  vertexMode = rep("Journal", network.size(net2mode))
  vertexMode[people] = "Member"
  net2mode %v% "vertex.names" = gsub("Member-", "", net2mode %v% "vertex.names")
  net2mode %v% "vertex.mode" = vertexMode
  net2mode
}

# Define a function to project one-mode from two-mode networks
bipartiteProjector =
  function(netMatrix, edgeList = TRUE, mode = 1) {
    # Returns one-mode projection of a bipartite network
    # netMatrix is the network matrix in adjacency (default) or edgelist form.
    # edgeList is boolean; if true the edgelist will be coerced to adjacency
    # Mode is the index of adjacency matrix (or column of edgelist) on which to project;
    # i.e., 1(2) projects row(column)-entries
    if(edgeList)
      netMatrix = as.matrix(table(netMatrix))
    if(mode == 2)
      netMatrix = t(netMatrix)
    projectedMatrix = netMatrix %*% t(netMatrix)
    network(projectedMatrix, 
            directed = FALSE,
            ignore.eval=FALSE,
            names.eval="value")
  }

# Define a function to make a dotchart for each centrality measure
dotplotter =
  function(df = journalCentralities, measure) {
    df %>%
      filter(CentralityMeasure == measure) %>%
      arrange(Score) %>%
      with(dotchart(Score, 
                    labels=Journal, 
                    main = unique(CentralityMeasure),
                    cex = .8))
  }

# Calculate various centrality scores and put in a df, given a network
centralityCalculator = function(net) {
  data.frame(Journal = net %v% "vertex.names",
             Degree = degree(net) / 2,
             Eigenvector = evcent(net),
             Betweenness = betweenness(net)) %>%
    melt(id.vars = "Journal", 
         variable.name = "CentralityMeasure",
         value.name = "Score") 
}
{% endhighlight %}
