#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=test-prep
#SBATCH --output=testprep-%j.out
#SBATCH --mail-type=END
#SBATCH --mem=32000
#SBATCH --partition=standard,broadwell

Rscript start_develop.R
