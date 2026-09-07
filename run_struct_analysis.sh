#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=48        # match parallel workers your NProc script actually uses
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out
#SBATCH --time=04:00:00              # set a realistic wall-time estimate
#SBATCH --partition=small         # change to hm/gpu if needed
#SBATCH --job-name=ida-spo-msa

# ---------- 1. Set up paths ----------
PROJECT_NAME=ida-spo-msa
HOME_DIR=/home/ce24d033/${PROJECT_NAME}
SCRATCH_DIR=/scratch/ce24d033/${PROJECT_NAME}

# ---------- 2. Copy project from HOME to SCRATCH ----------
mkdir -p /scratch/ce24d033
rm -rf ${SCRATCH_DIR}                # clean slate, avoid stale files from previous runs
cp -r ${HOME_DIR} ${SCRATCH_DIR}

# ---------- 3. Activate OpenSees (conda) ----------
source /home/apps/MLDL/DL-CondaPy3/bin/activate opensees
export PATH="/home/apps/MLDL/DL-CondaPy3/envs/opensees/bin:$PATH"

# Sanity check — confirms OpenSees is callable
which OpenSees
OpenSees -v 2>&1 || true

# ---------- 4. Move into scratch working directory and run MATLAB ----------
cd ${SCRATCH_DIR}
mkdir -p Output

# Clean stale MATLAB Service Host state
rm -rf ~/.MathWorks/ServiceHost

# Clean corrupted MATLAB preferences (fixes "Transport stopped" fatal error)
mv ~/.matlab ~/.matlab_backup_$(date +%s) 2>/dev/null

# Provide missing X11 libs to MATLAB's Service Host installer via conda-installed libs
export LD_LIBRARY_PATH=/home/ce24d033/envs/x11libs/lib:$LD_LIBRARY_PATH

/home/apps/iitms/matlabr2025a/bin/matlab -nodisplay -nosplash -nodesktop -noFigureWindows \
    -r "addpath(genpath(pwd)); run('psb_MasterDriver_RunNProcDynAna_46053v02.m'); exit;"

# ---------- 5. Copy results back to HOME (scratch is not backed up / gets purged) ----------
mkdir -p ${HOME_DIR}/Output
if [ -d "${SCRATCH_DIR}/Output" ]; then
    cp -r ${SCRATCH_DIR}/Output/. ${HOME_DIR}/Output/
fi

echo "Job finished. Results copied back to ${HOME_DIR}/Output"