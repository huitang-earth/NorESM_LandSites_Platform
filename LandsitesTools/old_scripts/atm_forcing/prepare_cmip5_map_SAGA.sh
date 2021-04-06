#/bin/bash

VARS="cddETCCDI csdiETCCDI cwdETCCDI dtrETCCDI fdETCCDI gslETCCDI idETCCDI prcptotETCCDI r1mmETCCDI r10mmETCCDI r20mmETCCDI r95pETCCDI r99pETCCDI rx1dayETCCDI rx5dayETCCDI sdiiETCCDI suETCCDI tn10pETCCDI tn90pETCCDI tnnETCCDI tnxETCCDI trETCCDI tx10pETCCDI tx90pETCCDI txnETCCDI txxETCCDI wsdiETCCDI"

MODELS="bcc-csm1-1 CCSM4 CNRM-CM5 HadGEM2-ES IPSL-CM5A-LR MIROC-ESM-CHEM MIROC-ESM MIROC5 MPI-ESM-LR MRI-CGCM3 NorESM1-M"
modelb="bc cc cn gf gs he ip mc mg mi mp mr no"
RCPS="26 45 85"
years="50 70"

module load ESMF/8.0.0-intel-2019b

#for model in $MODELS
#do

#/cluster/software/ESMF/8.0.0-intel-2019b/bin/ESMF_RegridWeightGen --ignore_unmapped -s /cluster/home/huit/SCRIPgrid_data/SCRIPgrid_${model}_nomask.nc -d /cluster/home/huit/SCRIPgrid_data/SCRIPgrid_worldclim2_mask.nc -m conserve -w /cluster/home/huit/SCRIPgrid_data/map_${model}_nomask_to_1080x2160_mask_aave_da_c200319.nc --64bit_offset

#done 

/cluster/software/ESMF/8.0.0-intel-2019b/bin/ESMF_RegridWeightGen --ignore_unmapped -s /cluster/home/huit/SCRIPgrid_data/SCRIPgrid_worldclim1.4_nomask.nc -d /cluster/home/huit/SCRIPgrid_data/SCRIPgrid_worldclim2_mask.nc -m conserve -w /cluster/home/huit/SCRIPgrid_data/map_worldclim1.4_nomask_to_1080x2160_mask_aave_da_c200319.nc --64bit_offset
