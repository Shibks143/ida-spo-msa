# Notices

1. [Signal Processing Toolbox](https://www.mathworks.com/products/signal.html) of MATLAB is required for finding peaks in disaggregation script.
1. Use `scriptFindDeaggTuples` to get the disaggregation tuples. 
   - The output given in terms of M-R-λ (magnitude-distance-contribution) tells whether there are multiple peaks in the hazard.
   - The above (M-R) tuples will be required for groun motion selection.
   - The tool is now updated to give the contributions (in %) from different tectonic regimes. This input will also go for ground motion selection.
   - Keep the truncation to 3. Deaggregation (at least at longer periods) is sensitive to this parameter. USGS-2014 used 2.5, we use 3 and number of bins as 12. So the outer ranges become (-∞, -2.5] and (2.5, +∞).
1. Use `script_simple_plotDeagg_v2` to plot disaggregation.
1. `script_PlotDeagg_CND_v2` is only used to beautify the disaggregation plot. For any others purposes, this script will NOT be needed.

