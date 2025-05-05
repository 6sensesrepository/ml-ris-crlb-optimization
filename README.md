# RIS phase optimization for Near-Field 5G Positioning: ML-enhanced CRLB Minimization

This article addresses near-field localization using Reconfigurable Intelligent Surfaces (RIS) in 5G systems, where Line-of-Sight (LOS) between the base station and the user is obstructed. We propose a RIS phase optimization method based on the minimization of the Crame ́r-Rao Lower Bound (CRLB). This minimization itself is computationally costly, for which a data-driven method is employed with remarkable computational savings and positioning performance. The main contributions of this work are: (1) the application of machine learning to enhance CRLB minimization for RIS phase optimization; (2) an overview on RIS phases preprocessing methods to enhance deep neural networks training for the task; and (3) an end-to-end simulation of the positioning task with the presented method, showing a computational improvement without compromising positioning accuracy.


## Folder structure

```
└── /src
    ├── /results_generation       # Generate results for each plot
    └── /optimization_functions_1 # Needed functions
    └── /datasets                 # Needed datasets to train the network
    └── /ml_python                # trained network
    └── /smooth phases            # plots of the 40 RIS phases over the grid of positions
    
```

## Basic Run
In order to reproduce the results one have to execute *Results_plots.m*


