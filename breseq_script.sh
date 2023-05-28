#!/bin/bash

for folder in /home/jorgesd/TFG_pablo/data/reads_experimental_evolution/*
do
	strain=$( basename $folder )
	
	for reads1 in /home/jorgesd/TFG_pablo/data/reads_experimental_evolution/$strain/*_1.fq.gz
	do
		reads2=${reads1%%_1.fq.gz}"_2.fq.gz"
		sample=$( echo ${reads1%%_val_1.fq.gz} )
		result_folder=$(basename $sample)

		breseq -r /home/jorgesd/TFG_pablo/data/reference/closed_genomes/$strain.gbk -j 5 -n $result_folder -o /home/jorgesd/TFG_pablo/results/breseq/$strain/$result_folder -p $reads1 $reads2
	done
done
