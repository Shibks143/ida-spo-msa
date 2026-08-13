# OpenQuake Installation instructions for Windows. Similar instructions should work for linux/macOS.

(a) install python [3.9.x from python website](https://www.python.org/downloads/) Not Conda; Not Windows App. Check if it is installed properly by executing python in `cmd.` Take 3.9.13 by scrolling in the specific release box. This is the last update of 3.9.x.

(b) install git https://git-scm.com/

(c) execute the following:
```console
C:
git clone https://github.com/gem/oq-engine.git
cd oq-engine
python install.py devel
```
This should install all necessary python packages. 
Make sure to run activate.bat (read the last message after `install.py` for openquake)
```console
C:\>%USERPROFILE%\openquake\Scripts\activate.bat
```
(d) Add folder with oq.exe (say, `C:\Users\%USERNAME%\openquake\Scripts\`) to system environment variable path. 

> If that did not work, consider replacing `%USERNAME%` with the actual username. 

(e) test oq installation with the command `oq engine --help`. Exit and then open a new `cmd` window to ensure successful installation. 

(f) Test a demo run with either
```console
oq engine --run C:\Users\%USERNAME%\openquake\demos\hazard\AreaSourceClassicalPSHA\job.ini
```
or,
```console
oq run C:\Users\%USERNAME%\openquake\demos\hazard\AreaSourceClassicalPSHA\job.ini
```
Sometimes, this will throw file-not-found error, meaning the demos directory is not in `C:\Users\%USERNAME%\openquake\`. The demos directory must be in the clone of the `OpenQuake` repo, i.e., `C:\oq-engine\demos\`. Try
```console
oq engine --run C:\oq-engine\demos\hazard\AreaSourceClassicalPSHA\job.ini
```
(g) For web-based ui, run the following on windows cmd:

```console
oq webui start
```

Instructions until this point are based on Universal installation script
    https://github.com/gem/oq-engine/blob/master/doc/installing/universal.md

(h) Copy `gmm_tables` (from `NRCan_Hazard_analysisTools/gmm_tables/`) to the directory where OpenQuake expects it (probably, `C:\Users\%USERNAME%`). The best way to know the precise location is to execute the hazard analysis (first sub-part of the next bullet) and read the error. 

(i) In order to execute a PSHA for a specific location, follow the two steps as given below:
	
 1. Create the job file.
 	1. For PSHA, create a new job file (`.ini`) by copying an existing file from `NRCan_Hazard_analysisTools\jobs\NBCC2020_OQ_SWinputs_psb\NRCan_NBCC2020_Van_450mps_CNDpaper_haz.ini`.
 	1. For deaggaregtaion, use the job file `NRCan_Hazard_analysisTools\jobs\NBCC2020_OQ_SWinputs_psb\NRCan_NBCC2020_Van_450mps_CNDpaper_dis.ini`.
	Enter the lat long of the location of interest. Add the period of the building of interest, if not listed in the intensity measure list.
 1. Run the following command on `cmd`.
	```console
	oq engine --run PATH\TO\THE\FILE.ini
	```
> Retrieve these results in .csv or .zip from the browser using `oq webui start`.

# General issues/suggestions for running OpenQuake analysis.

1. Disaggregation processes require large memory. Even if you have a good computer, expect the error in disaggregation for the binning. Somet things you can do are:
	- Run for a single IM corresponding to a single poe.
	- Binning is a perpetual problem on non-HPCs. Keeping magnitude bin to 0.1, distance bin to 20 km, and num_epsilon_bins to 12 works for me.
1. Keep the truncation_level to 3. This would match the end brackets to (-∞, -2.5] and (2.5, +∞). For deaggregation (at least at longer periods) is sensitive to truncation limits.
1. 
