#!/bin/bash

for folder in /home/jorgesd/TFG_pablo/data/reads_experimental_evolution/*
do
	strain=$(basename $folder)
	#echo $strain
	for reads1 in /home/jorgesd/TFG_pablo/data/reads_experimental_evolution/$strain/*_1.fq.gz

	do

		#echo $reads1
		reads2=${reads1%%_1.fq.gz}"_2.fq.gz"
		#echo $reads2
		sample=$( echo ${reads1%%_val_1.fq.gz} )
		#echo $sample
		result_folder=$(basename $sample)
		bwa mem $strain $reads1 $reads2 > /home/jorgesd/TFG_pablo/results/bwa/$strain/$result_folder.sam
		

	done
done
