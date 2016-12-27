# Provenance source code

This is the repository of paper "Modelling and Simulation of Provenance in Food Chain to Trace Emerging Water"

## Components
The project contains 4 parts:
* Sampling algorithm
* Tracing algorithm 
* Provenance algorithm
* Ant Colony Optimization

## Tracing Algorithm
In folder "Food Chain Tracing"

>The tracing project checks the information stored for every sampling point and measures the contaminant content in each creature, including fish and shrimp. Then, the procedure sets the contaminant enrichment factor, according to the pollutant type and traces to the next layer of the food chain until the algae level.

The  `water_input()` `location_input()` inputs water and location parameters.
The `pollution_input()` loads all pollution data included in fishes and shrimps. 
The `workflow_provenance()` traces the pollution through food chain from top to bottom.
The `output_to_file()` store pollution tracing results in algae body. 

## Provenance Algorithm
In folder "Provenance Algorithm"

## Ant Colony Optimization
In folder "Ant Colony Optimization"


## Author
Dian Yang

Date: 2016.7

