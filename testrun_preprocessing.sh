#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=test-prep
#SBATCH --output=testprep-%j.out
#SBATCH --mail-type=END
#SBATCH --mem-per-cpu=32000

Rscript testrun_preprocessing.R
