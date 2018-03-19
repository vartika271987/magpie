#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=mag-preprocessing
#SBATCH --output=log-%j.out
#SBATCH --mail-type=END
#SBATCH --mem-per-cpu=32000

Rscript inms.R
