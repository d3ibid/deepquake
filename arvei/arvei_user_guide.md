Computer Architecture Department							R. Tous
Universitat Politecnica de Catalunya. BarcelonaTech (UPC)                                                                       
                                                              
															  
															  
					Arvei User Guide

0. (only for OXS users) Configure OSX's SSH client:

	- Preferences/Advanced disable set locale on startup
	- https://wiki.rc.ucl.ac.uk/wiki/FAQ#Unable_to_run_job:_JSV_stderr:_perl:_warning:_Setting_locale_failed.

1. Enter the gateway (replace 'rtous' with your username)

	ssh rtous@gw.ac.upc.edu 

2. Enter an interactive execution node 

	qrsh 

3. Move to your scratch zone (use the proper path for your user)

	cd /scratch/nas/4/rtous

4. Create and activate a Python virtualenv

	virtualenv deepquake_virtualenv
	source deepquake_virtualenv/bin/activate

5. Download and enter the repository
 
	git clone https://github.com/rtous/deepquake.git
	cd deepquake

6. Install the dependencies (can take around 30 mins.)

WARNING: Arvei required more complex installation steps. In addition, some of the dependencies stop working at different times during the project development (e.g. "pip install tensorflow==0.12.0" and "pip install lxml"). I fixed them, but it's an unstable environment (python packages within machines which you don't control). Cross your fingers.

	xargs -L 1 pip install < arvei/requirements_arvei.txt 

7. Prepare the submission script

Let's use the example one within arvei/example_experiment_arvei.sh.

8. Try a local version of the script first (to detect premature errors)

	./test.sh

Abort the execution if everything seems to be ok.

9. Submit a "special" version of the script to tue queue

NOTE: Ensure that the virtualenv activated within the script is the correct one (deepquake_virtualenv).

	qsub -S /bin/bash -l big ./arvei/test_arvei.sh

Once finished, it should have created an output directory within /scratch/nas/4/rtous/deepquake with the results.

10. Debugging

In order to check the stdout/stderr output:

	#Check in which node the job is executing)
	qstat -u rtous

	#Enter the node in which the job is executing to see the error logs
	qrsh -l h='arvei-145' (el node que ens dona qstat)

NOTE: You would not be able to access the node if the node is too busy (which is ok as means your job is still running and has not crashed).

11. Troubleshooting

- missing dependency: pip install tensorflow==0.12.0 -> https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.0-cp27-none-linux_x86_64.whl

- missing dependency: openquake.hazardlib==0.22.0 -> https://github.com/gem/oq-hazardlib/releases

- missing dependency: OSError: Could not find library geos_c -> see missing dependency: shapely

- missing dependency: shapely -> https://pypi.org/project/Shapely/#files

	- Downloaded from https://pypi.org/project/Shapely/#files
	- Changed whl name to Shapely-1.6.4.post2-cp27-none-linux_x86_64.whl
	- pip install Shapely-1.6.4.post2-cp27-none-linux_x86_64.whl

- "Attempting to use uninitialized value conv1/..." -> you are not using the right version of tensorflow (check pip show tensorflow == 0.12.0)

- Error when "virtualenv deepquake_virtualenv" -> Try freeing some disk space and/or change to another interactive node.

- AttributeError: 'module' object has no attribute 'station' -> obspy was not correctly installed (version should be 1.0.2). pip uninstall obspy, pip install obspy.




  