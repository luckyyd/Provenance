# Provenance source code

This is the repository of paper "Modelling and Simulation of Provenance in Food Chain to Trace Emerging Water"

## Components
The project contains 4 parts:
* Sampling algorithm
* Tracing algorithm 
* Provenance algorithm
* Ant Colony Optimization

## Tracing Algorithm
In folder "Food Chain Tracing->concentration".

>The tracing project checks the information stored for every sampling point and measures the contaminant content in each creature, including fish and shrimp. Then, the procedure sets the contaminant enrichment factor, according to the pollutant type and traces to the next layer of the food chain until the algae level.

The  `water_input()` `location_input()` inputs water and location parameters.

The `pollution_input()` loads all pollution data included in fishes and shrimps. 

The `workflow_provenance()` traces the pollution through food chain from top to bottom.

The `output_to_file()` store pollution tracing results in algae body. 

## Provenance Algorithm
In folder "Provenance Algorithm->provenance.m"

>We adopt a comprehensive approach with Differential Evolution and Markov Chain Monte Carlo (DE-MCMC) to identify the pollution source in two-dimensional water quality model. 
>Monte Carlo Markov chain (MCMC) sampling from a probability distribution in high dimensional random vector space based on constructing a Markov chain that has the desired distribution as its equilibrium distribution. The state of the chain after a number of steps is then used as a sample of the desired distribution.

Parameters:
* `data.xdata` positions of x coordinate
* `data.ydata` positions of y coordinate
* `data.cdata` records of pollutions concentrations
* `data.tdata` records of timeline

Results:
* `xmin` is a 3*1 matrix indicates the results of pollution amounts, x coordinate and y coordinate.
* `mse` is the estimate for the error variance.
* The chain plot of 3 parameters is shown in figure 2.
* The predictive posterior distribution is shown in figure 5.

## Ant Colony Optimization
In folder "Ant Colony Optimization"


## Author
Dian Yang

Date: 2016.7

