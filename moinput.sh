#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=moinput
#SBATCH --output=molog-%j.out
#SBATCH --mail-type=END
#SBATCH --mem-per-cpu=32000

Rscript moinput.R
