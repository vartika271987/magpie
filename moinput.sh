#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=moinput
#SBATCH --output=molog-%j.out
#SBATCH --mail-type=END
#SBATCH --mem=32000
#SBATCH --partition=standard,broadwell

Rscript moinput.R
