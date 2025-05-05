#!/bin/bash
#SBATCH -p spcom                  # Partition to submit to
SBATCH --mem=5G                  # Max CPU Memory
#SBATCH --gres=gpu:1
matlab -batch SignalYmain_phases_smoothed
