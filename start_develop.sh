#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=test-prep
#SBATCH --output=testprep-%j.out
#SBATCH --mail-type=END
#SBATCH --mem=32000

Rscript start_develop.R
