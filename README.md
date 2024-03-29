<p>
<img src="https://github.com/PredictiveEcology/WBI_studyAreas/raw/main//figures/SpaDES_CS.png" align="right" width="60">
</p>

## Western Boreal Initiative

[![Gitter](https://badges.gitter.im/PredictiveEcology/western_boreal.svg)](https://gitter.im/PredictiveEcology/western_boreal?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

### Project overview

Modelling cumulative effects (CE) implies that we can measure and forecast current and future consequences of multiple stressors such as wildfires, pests, forestry and other anthropogenic disturbances, and climate change on the ecosystem services supplied by Canada’s forests.
As the number of natural and human-caused disturbances change, CE require evaluation of land and forest management interactions, while also assessing the implications of shifting prioritization among more than one forest value (e.g., woodland caribou, other Species at Risk (SAR), timber supply, carbon, and downstream economic values).
This is a critical issue for all jurisdictions in Canada and requires large multidisciplinary and collaborative efforts based on sound scientific and socio-economic research.
This Western Boreal Initiative represents an ambitious spatial expansion and diversification of forest values from a pilot project in Northwest Territories (Micheletti et al. in prep; Stewart et al. in prep; Micheletti et al. 2019a).

### Project Highlights

<p>
<img src="https://github.com/PredictiveEcology/WBI_studyAreas/raw/main/figures/StudyAreaWBI.png" align="right">
</p>

The proposed project will integrate the best available data, meta-modeling tools, a diverse array of domain experts, and ongoing stakeholder engagement to evaluate the cumulative effects of wildfire, key pests, and anthropogenic disturbances, and climate change on forest values in the Western Boreal Forests of Canada.
Working with scientists, foresters, provincial and territorial governments, Indigenous Peoples, and other stakeholders, we will provide forecasts of future forest conditions and interpretations of ecological and socio-economic indicators, as well as how these compare to various thresholds and targets.
When these indicators are forecasted to pass their respective thresholds and targets, we will quantify the trade-offs with other values, and attempt to identify solutions through optimization that maximize synergies and minimize negative trade-offs.
Key values we will evaluate are economic values related to forestry, conservation values of established ECCC priority places, protected areas, and National Parks, and Species at Risk, including woodland caribou, and the forest carbon consequences.
This work will support multi-species management objectives and the Pan Canadian Framework on Clean Growth and Climate Change.

### Objectives

We propose one higher level project objective and numerous sub-objectives.
At the highest level, our objective is to build a powerful and generic toolkit for forest, species, and land management under changing future conditions that we apply to the Western Boreal Forest region of Canada (Figure 2 and 3).
This toolkit will be built with flexible, interoperable, scientifically-based models and data and allow for a new generation of integrated answers to ongoing management questions.
The management context and paradigms that we are working within includes Cumulative Effects, The Pan-Canadian Framework on Clean Growth and Climate Change, Sustainable Forest Management, Multi-species Management, and Indigenous Co-production and Knowledge.
We divide this larger objective into a series of sub-objectives that will address specific elements.

<p>
<img src="https://github.com/PredictiveEcology/WBI_studyAreas/raw/main/figures/WesternBorealArrowsDiagram.png" align="right" width="480">
</p>

### [`SpaDES`](https://spades.predictiveecology.org)

This project is being developed using a foundational and predictive system for geospatial simulation - the [`SpaDES`](https://spades.predictiveecology.org) family of R packages (Chubaty and McIntire 2019a, McIntire et al., in prep).
Our approach facilitates findable, accessible, interoperable and reusable science, paramount for conducting landscape modeling and prediction in ecology (Keane et al. 2015, Dietze et al. 2018, Stall et al. 2019).
Moreover, such a framework allows for diverse models generated from previously siloed areas of expertise to be integrated into a continuous, adaptable and reusable workflow, directly conducting a cumulative effects analysis over large spatial extents.
In other words, due to the flexibility and transparency of being built in R, `SpaDES` empowers domain experts to build models with or without involving programmers to translate ecological mechanisms into code.
With the `SpaDES` platform "modules" of any sort can be created (i.e., any coherent idea or concept, such as "harmonize all data layers", "estimate parameters for fire module", "forest succession", "forest harvesting", "carbon accounting", "caribou resource selection function prediction"), sometimes very quickly, and due to being compatible with R, they can be readily shared and integrated with other conceptually compatible modules (i.e. compute forest carbon pools and caribou resource selection  while simulating harvesting on a dynamic landscape).
All these are unique advantages of the `SpaDES` platform over other graphical user interface, or black-box software.
The modular and open approach that `SpaDES` speeds up scientific collaboration, as "interoperable" modules can be developed in parallel in many research groups.
Similarly, with a single interoperable framework, `SpaDES` promotes the use of tools for generating user friendly web apps to visualize and understand cumulative effects.
With over 22,000 downloads and 37 independently developed modules and counting, `SpaDES` is a Canadian product rapidly increasing in use across multiple scientific communities.
