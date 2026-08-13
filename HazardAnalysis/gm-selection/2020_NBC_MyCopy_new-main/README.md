# Seismic Hazard and Ground Motion Selection Tool as per 2020-NBC-Canadian-Seismic-Hazard (incorporating 6th National Seismic Hazard Model of Canada from scratch)

#### *Prakash Singh Badal, Postdoc, University of California, Davis, aprakashn@gmail.com*
#### *Solomon Tesfamariam, Professor, University of Waterloo, solomon.tesfamariam@uwaterloo.ca*

This respository builds up on NRCan's 2020 revision of Canada's 6th Generation National Seismic Hazard Model (NSHM6G). NSHM6G has completed shifted to ```OpenQuake``` platform by GEM. The programs contained in the present repo include the draft hazard models (e.g., source modeling, ground motion models, etc.) of NRCan and are subject to change by NRCan. The objectives of present repo are to (a) carry out hazard analysis, (b) deaggregation, and (c) eventually select ground motion records from different datasets suitable to the seismicity of the site/region for different targets. Information and data within this repository rely on NRCan's repo and are out of sync. Therefore, the present repo may not contain up-to-date hazard models. The liability does not lie with the authors of the present repo and care should be taken while using it to make any decisions.
       
<p align="center"> <img width="500" src="/_images/SHM6_regionalization_Kolaj.png" alt="Regionalization of Canada per SHM6"> </p>
<p align="center"> <b> Three regional models used in SHM6 to calculate hazard. In the regions with overlapping zones, the larger of the two adjacent models is used (figure from <a href="https://doi.org/10.4095/327322">Kolaj et al., 2020</a>). </b> </p>

It is worth noting that with the updated [NBCC 2020 (2022)](https://doi.org/10.4224/w324-hv93), the need for site class factors is eliminated and the response spectra for continuous values of $V_{s,30}$ can be obtained either from [seismic hazard tool](https://earthquakescanada.nrcan.gc.ca/hazard-alea/interpolat/nbc2020-cnb2020-en.php) for NBCC 2020. Alternatively, the seismic hazard values can also be obtained by querying the [NRCAN web-service](https://www.earthquakescanada.nrcan.gc.ca/api/canshm/graphql) in ```json``` format using the GraphQL Application Programming Interface (API). 

The current project adopted a rigorous and fundamental approach of performing probabilistic seismic hazard analysis from the source model using [OpenQuake (2022)](https://platform.openquake.org/) is adopted. This allows to obtain the seismic hazard curves for actual period of interest and eliminates the need to interpolate standard hazard curves. Additionally, the PSHA yields deaggregation results used later for the ground motion selection (under method-B).

The curren repo is now expanded with more functionalities:
  - NBCC 2020 hazard and deaggregation calculations from scratch using ```OpenQuake``` and source modeling.
      > This would require analysis on a local system using ```OpenQuake```
  - Querying NBCC 2020 API for hazard values. This will work only for standard intensity measures, _viz._, $PGA$, $Sa(0.05)$, $Sa(0.1)$, $Sa(0.2)$, $Sa(0.3)$, $Sa(0.5)$, $Sa(1.0)$, $Sa(2.0)$, $Sa(5.0)$, and $Sa(10.0)$.

  - Time history record selection.
    - Databases in use- NGA-West2 and K-NET/KiK-net (Chilean records are not yet included).
    - Targeting Conditional Spectra, 
    - Targeting conditional spectra for multiple tectonic regimes, dominating earthquakes, and databases.
    - (not yet included) Targeting vector-valued multi return period spectrum
  
# A brief summary of each directory: 
 
 1. ```AllOpenQuakeOutputs```- Outputs of OpenQuake for some example locations (indicative only).
 1. ```Database```- Flatfiles for NGA and KiK-net databases. Need to download the two large files manually. The zip download of repo only downloads shortcuts for these two files. The user should replace these shortcuts by manually downloaded files.
 1. ```GMM```- Ground Motion Models.
 1. ```GMSelection_DownloadData```- Script for downloading KiK-net files. Recall that NGA records need to be downloaded separately. PEER does not allow programmatic download of strong motion records.
 1. ```GMSelection_format```- An app to format the downloaded NGA/KiK-net records. 
 1. ```GMSelection_NGA_KiK_mixed```- An app to select the ground motion records.
 1. ```NBCC2020_OfficialResults```- NBCC 2020 official hazard results.
 1. ```NBCC2020_queryAPI```- A simple code to automatically query the NRCan's API in order to get seismic hazard value and curves of NBCC 2020.
 1. ```NRCan_Hazard_analysisTools```- Tools to carry out PSHA.
 1. ```NRCan_ProcessPSHA```- Script to deaggregate the analyzed PSHA results.
 
 
# A usual sequence of analysis and some tips: 

 1. If using zipped download, you need to manually download two .mat files in ```Database``` directory. Github desktop and other git tools will automatically download large files.
 1. Run PSHA (tool given above. See ```NRCan_Hazard_analysisTools```). It is recommended to follow ReadMe in that directory.
 1. Deaggregate to get tuples (tool given above. See ```NRCan_ProcessPSHA```) corresponding to (one or multiple) tectonics.
    - Decide appropriate number of ground motion for each tectonic based on the source-based deaggregation. The tool for processing_PSHA (for more details, check readme in that directory) is now updated to give contributions from different sources.
 1. Select ground motion records (tool given above. See ```GMSelection_NGA_KiK_mixed```).
 1. The selected record IDs are stored in the summary directory after the selection is successful. Copy the .dat files with record IDs in the same directory as the download tool for the next step.
 1. Download records from NGA and KiK-net. Manually for NGA, using the tool for KiK-net (See ```GMSelection_DownloadData```).
    - You will need an account for <a href="https://ngawest2.berkeley.edu">NGA-West2</a>.
    - Before executing the MATLAB program for downloading records from Japanese database, you will also need an activated account on <a href="https://www.kyoshin.bosai.go.jp/kyoshin/search/index_en.html">NIED, Kyoshin</a>.
 1. Save all raw records (NGA and KiK both) in extracted form (remember the app reads .AT2/.NS2/.EW2 files) in a directory under `GMSelection_format`. Format records using the tool (App in ```GMSelection_format```).
    - Some downloaded time-history starts at a non-zero acceleration. Execute script (largely manual as of now, needs the location and numbers of time-histories) named, `fun_correctTimeHistoryForNonZeroBeginning`. The script also saves the corrected spectra files using the function `fun_saveResSpecStandalone` (obviously, no need to separately execute this function). Update with the corrected time-history and spectra files for analyses.
 1. For psb's analysis, save time-history records in OpenSeesProcessingFiles\EQs and spectra files in OpenSeesProcessingFiles\EQ_Spectra_Saved. defineEQInfoForMATLAB file is not required for analysis, but good to have it as a summary of selected ground motion records and renamed IDs.
 
 
# Other possible issues/resolutions/improvements in the tool: 
 
 1. As mentioned above, make sure to download two .mat files in ```Database``` directory manually and replace the auto-downloaded shortcuts for the same.
 1. Before running the tool for ground motion selection in the directory ```GMSelection_NGA_KiK_mixed```, make sure that MATLAB's directory is navigated to the location of the app.
 1. Install the <a href="https://www.mathworks.com/products/statistics.html">Statistics and Machine Learning Toolbox</a> for MATLAB.
 1. If your account on Kyoshin is not activated, the download will silently fail.
 1. The downloaded records in KiK-net may have a non-zero shift, i.e. the time-history may be centered around non-zero ground acceleration.
    - Yet to check: the accuracy of response spectra in the database (```.mat``` file).
    - Yet to implement: shift of downloaded time-history to correct for centeral value such that the acceleration starts and ends at zero. 
