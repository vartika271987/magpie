#!/bin/bash

#SBATCH --qos=short
#SBATCH --job-name=mag-preprocessing
#SBATCH --output=log-%j.out
#SBATCH --mail-type=END
#SBATCH --mem=32000
#SBATCH --partition=standard,broadwell

Rscript general_runs_preprocessing.R
