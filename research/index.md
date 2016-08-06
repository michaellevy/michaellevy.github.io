---
layout: article
title: Research
date: 2015-10-02
modified: 2016-04-29
excerpt: 
image:
feature: 
teaser: 
thumb:
share: false
---

I study how people think about and act on sustainability issues, with a particular interest in social and cultural influences. I use computational tools to study networks of people and ideas, to understand why relationships form the way they do, what we can learn from their patterns, and how they affect the behavior of individuals and systems. 

These are my current research projects:

{% include toc.html %}

## Mental Models of Sustainable Agriculture

<figure class="half">
	<img src="/images/quincyWorkshop.jpg" style="height:250px; width:500px">
	<a href="/images/aggregateMM.jpg">
		<img src="/images/aggregateMM.jpg" style="height:250px; width:333px"></a>
	<figcaption>At an elicitation workshop in Quincy, California participants discuss how sustainable agriculture works while I translate into a mental model on a projector. Right: an aggregated mental model of sustainable agriculture.</figcaption>
</figure>

Sustainability is famously nebulous. To bring light to what sustainable agriculture means and how it works in California, I organized panels of agriculture experts in eight counties representing the socioeconomic and environmental breadth of California agriculture. Each expert deconstructed their mental model of sustainable agriculture -- a detailed representation of the concepts relevant to sustainable agriculture and the causal relationships among them. In addition to that individual process, each panel engaged in a participatory discussion to develop a group consensus model of sustainable agriculture in their region. I got an incredibly rich source of data, and participants got a better understanding of how they understand sustainable agriculture and how that fits with their community's understanding -- win-win.

With 150 experts' mental models in hand, I can compare and contrast understanding of how sustainable agriculture operates across professions, experience level, and geographic regions. In one branch of this project, I use network analysis to compare structural patterns of the models, without considering their content, to look at different ways and depths of understanding. The key idea that's emerging here is that nodes are cheap, but links are expensive. That is, it's easy enough to rattle off a long list of factors relevant to sustainable agriculture, but to make the causal connections among them takes more effort and deeper understanding.

Of course, I look at the content of the models too. To put all the experts' models in the same terms, I developed an algorithm that leverages Google search results to assign semantic similarity to concepts. Then I cluster related concepts so that each model is composed of the same concepts. That opens the door to a number of analyses. I can compare the content and connections of different models (e.g. do people in drier regions think more or less about water? Do they make different connections between water and social and economic goals?). I can also infer a consensus model that reflects the aggregate understanding of all the experts, and I can compare deviations from that model. I can also use the aggregate model as the consensus view of how sustainable agriculture works in California and can derive conclusions via qualitative inspection and quantitative network analysis, and I can also use the model as a stocks-and-flows system dynamics model to run simulations and examine the effects of policy interventions and environmental change. With Neil McRoberts and Mark Lubell.


## Social Capital in Vineyard Management Networks

<figure>
	<a href="/images/growerNetworks.jpg"><img src="/images/growerNetworks.jpg"></a>
	<figcaption>Communication networks in vineyard management. These networks are rich in clustering, which builds bonding social capital to solve cooperation dilemmas such as environmental management.</figcaption>
</figure>

This project examines the structure of information ties among viticulturists. From those structural patterns, I draw conclusions about social aspects of the decision context in which growers operate. For example, open network structures suggest a collaborative environment in which information seeking and innovation diffusion flourish. In contrast, closed networks structures suggest an environment in which trust building is important, for example to solve environmental cooperation dilemmas. With Mark Lubell.


## Drivers of Environmental Certification Adoption

<figure>
	<a href="/images/certEsts.png">
		<img src="/images/certEsts-sm.png"></a>
	<figcaption>Maximum <i>a posteriori</i> parameter estimates and credibility intervals for the effect of various demographic and social variables on likelihood of joining three environmental certification programs.</figcaption>
</figure>

What drives farmer participation in voluntary environmental programs such as USDA Organic certification? In this project, we found that for established programs where benefits are well developed, farm size and its attendant economic resources and incentives are a principle driver. For newer programs, where benefits are less immediate, social networks play a dominant role as the community decides whether or not to buy in to the program. With Mark Lubell, Aseem Prakash, and Matt Potoski.

## Interpreting Geometrically-Weighted Degree Estimates in ERGMs

<figure>
	<a href="/images/gwSims.jpg">
		<img src="/images/gwSims.jpg"></a>
	<figcaption>Centralization and clustering in networks simulated across a range of parameter values for two statistics commonly used in exponential random graph models.</figcaption>
</figure>

Geometrically-weighted statistics have become an important part of ERGMs (exponential random graph models), but they can be difficult to interpret. This project seeks to explicate how to use and interpret the geometrically-weighted degree parameter and how to select values of its shape sub-parameter. With Mark Lubell, Philip Leifeld, and Skyler Cranmer.

## Fire dynamics and homeowner behavior in the WUI

<figure>
	<a href="/images/netlogo.png">
		<img src="/images/netlogo-sm.png"></a>
	<figcaption>Prototype agent-based model of homeowner adoption of defensible space behavior.</figcaption>
</figure>

Wildfire is a significant and growing threat in California and firefighting resources are stretched thin. As a [SESYNC graduate pursuit](https://www.sesync.org/news/mon-2015-10-19-1400/rfp-socio-environmental-synthesis-research-for-graduate-students), myself and five other graduate students, all from different disciplines and universities, are developing a model that couples vegetation and fire dynamics to homeowner behavior in the San Diego WUI (wildland-urban interface). I am leading the agent-based model of defensible space adoption, which is driven by a Bayesian multilevel model. With Patrick Bitterman, Ellen Esch, Katie Lyon, Michael Saha, and Kenny Wallen.