# Factors Influencing Customer Participation in a Program to Replace Lead Pipes for Drinking Water

This repo contains data and code for "[Factors Influencing Customer Participation in a Program to Replace Lead Pipes for Drinking Water](https://www.epa.gov/environmental-economics/customer-participation-lead-service-line-replacement)". 

> **Abstract:** 
> Many public water systems are struggling to locate and replace lead pipes that distribute drinking water across the United States. This study investigates factors associated with customer participation in a voluntary lead service line (LSL) inspection and replacement program. It also uses quasi-experimental and experimental methods to evaluate the causal impacts of two grant programs that subsidized homeowner LSL replacement costs on LSL program participation. LSLs were more prevalent in areas with a higher concentration of older housing stock, Black and Hispanic residents, renters, and lower property values. Owner-occupied and higher valued properties were more likely to participate in the LSL program. Results from the two grant program evaluations suggest that subsidies for low-income homeowners to cover LSL replacement costs can significantly boost participation, but only when the programs are well publicized and easy to access. Even then, there was still significant non-participation among properties with confirmed LSLs. 

## Requirements
1. *Stata* is used to estimate the regressions throughout the study. The code for the regression specifications is provided. The account-level LSL program data used in this study were acquired under a non-disclosure data use agreement with Trenton Water Works and are not provided in this repository. *Stata* is available through a license with StataCorp [here](https://www.stata.com/), but the code can be viewed with any text editor.

2. *R* is used to generate the figures and plots using the aggregated block group level data. *R* is free and available for download [here](https://www.r-project.org/). The *RStudio* integrated development environment is useful for replication, it is free and available for download [here](https://www.rstudio.com/products/rstudio/).

3. Optional: *Github* is free and available for download [here](https://github.com/git-guides/install-git). *Github* is used to house this repository and by installing and using it to clone the repository one will simplify the replication procedure. However, a user could also simply download a zipped file version of this repository, unzip in the desired location and follow the replication procedures outlined below.

## Getting Started
Begin by cloning this repository. This can be done by clicking on the green "code" button in this repository and following those instructions, or by navigating in the terminal via the command line to the desired location of the cloned repository and then typing: 

```
git clone https://github.com/bryanparthum/lslr-paper.git
```

Alternatively, you can make a `fork` of this repository. This allows for development on the `fork` while preserving its relationship with this repository.

## License
The software code contained within this repository is made available under the [MIT license](http://opensource.org/licenses/mit-license.php). The data and figures are made available under the [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) license.
