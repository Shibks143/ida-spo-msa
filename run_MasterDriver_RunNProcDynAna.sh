#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4            # = parallel MATLAB workers (one OpenSees run each). Max 48 on 'small'.
                                     #   setTest: 4 records -> 4 ; SetCS_30: 60 records -> 48
#SBATCH --time=12:00:00              # wall time (small partition allows up to 2-00:00:00)
#SBATCH --partition=small
#SBATCH --job-name=ida-spo-msa
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

# =====================================================================================
#  Paramshakti job: psb_MasterDriver_RunNProcDynAna.m (IDA / MSA with OpenSees + MATLAB)
#  Submit from the project folder:   cd ~/ida-spo-msa && sbatch run_MasterDriver_RunNProcDynAna.sh
# =====================================================================================

# ---------- 0. Settings you may change ----------
PROJECT_NAME=ida-spo-msa
DRIVER=psb_MasterDriver_RunNProcDynAna.m
MATLAB_TIMEOUT=705m                  # minutes, single unit only (705m = 11h45m); keep ~15 min below --time

HOME_DIR=$HOME/${PROJECT_NAME}
SCRATCH_DIR=/scratch/$USER/${PROJECT_NAME}
MATLAB_BIN=/home/apps/iitms/matlabr2026a/bin/matlab
NWORKERS=${SLURM_CPUS_PER_TASK:-1}

echo "[$(date +%T)] Job ${SLURM_JOB_ID} on $(hostname), ${NWORKERS} worker(s)"

# ---------- 1. Copy project HOME -> SCRATCH (skip git history and old job logs) ----------
mkdir -p /scratch/$USER
rm -rf ${SCRATCH_DIR}
mkdir -p ${SCRATCH_DIR}
if command -v rsync >/dev/null 2>&1; then
    rsync -a --exclude='.git' --exclude='job.*.out' --exclude='job.*.err' ${HOME_DIR}/ ${SCRATCH_DIR}/
else
    cp -r ${HOME_DIR}/. ${SCRATCH_DIR}/
fi
mkdir -p ${SCRATCH_DIR}/Output

# ---------- 2. OpenSees (shared conda env) ----------
source /home/apps/MLDL/DL-CondaPy3/bin/activate opensees
export PATH="/home/apps/MLDL/DL-CondaPy3/envs/opensees/bin:$PATH"
which OpenSees
OpenSees -v 2>&1 || true

# ---------- 3. MATLAB environment (headless) ----------
cd ${SCRATCH_DIR}
export LD_LIBRARY_PATH=$HOME/envs/minx11:$LD_LIBRARY_PATH   # libatomic workaround; remove once all nodes have it
unset DISPLAY
mkdir -p ~/Documents/MATLAB
export MATLAB_JOBDIR=${SCRATCH_DIR}/.matlab_jobs_${SLURM_JOB_ID}   # private parpool storage per job
mkdir -p ${MATLAB_JOBDIR}

# Private MATLAB home per job: avoids cross-node ServiceHost conflicts in the shared ~/.MathWorks
MATLAB_HOME=${SCRATCH_DIR}/.mlhome_${SLURM_JOB_ID}
mkdir -p ${MATLAB_HOME}/Documents/MATLAB

# Small wrapper: start a parallel pool sized to the Slurm allocation, then run the driver
cat > ${SCRATCH_DIR}/hpc_runDriver.m << EOF
disp('[MATLAB] script starting');
nW = ${NWORKERS};
if nW > 1 && license('test','Distrib_Computing_Toolbox')
    try
        c = parcluster('Processes');
        c.NumWorkers = nW;
        c.JobStorageLocation = getenv('MATLAB_JOBDIR');
        parpool(c, nW);
        fprintf('[MATLAB] parpool started with %d workers\n', nW);
    catch ME
        warning('parpool failed (%s); parfor will run serially', ME.message);
    end
else
    disp('[MATLAB] running serially (1 worker or no Parallel Computing Toolbox)');
end
run('${DRIVER}');
delete(gcp('nocreate'));
EOF

echo "[$(date +%T)] Starting MATLAB: ${DRIVER}"
# (no addpath(genpath(pwd)) here: the driver adds its own folders, and genpath would also pull in _superseded/)
HOME=${MATLAB_HOME} timeout ${MATLAB_TIMEOUT} ${MATLAB_BIN} -batch "hpc_runDriver"
MATLAB_STATUS=$?
echo "[$(date +%T)] MATLAB finished, exit code: ${MATLAB_STATUS}   (124 = hit MATLAB_TIMEOUT)"

# ---------- 4. Copy results SCRATCH -> HOME ----------
mkdir -p ${HOME_DIR}/Output
cp -r ${SCRATCH_DIR}/Output/. ${HOME_DIR}/Output/
cp ${SCRATCH_DIR}/CheckFile*.mat ${HOME_DIR}/ 2>/dev/null

echo "[$(date +%T)] Job finished. Results are in ${HOME_DIR}/Output"
exit ${MATLAB_STATUS}
