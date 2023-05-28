#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 20 15:34:47 2022

@author: jorge
"""

import pandas as pd
import seaborn as sb
from matplotlib import pyplot

NJ_dataframe = pd.read_excel("/home/pablo/TFG/data/BRESEQ/HEATMAP.xlsx", sheet_name= "Hoja4")
print(NJ_dataframe)
NJ_dataframe.index = NJ_dataframe["New_Junctions_Breseq"]
NJ_dataframe = NJ_dataframe.drop("New_Junctions_Breseq", axis = 1)

#print(snps_dataframe)

pyplot.figure(figsize=(28, 4)) # dimensions of plot may vary depending on the number of genes mutated
heatmap = sb.heatmap(NJ_dataframe, cmap="Blues", xticklabels=True, yticklabels=True, linewidths=0.0)
heatmap.set_xticklabels(heatmap.get_xticklabels(),rotation = 60, horizontalalignment='center', fontsize = 22)
heatmap.set_yticklabels(heatmap.get_ymajorticklabels(), rotation = 0, fontsize = 22)
pyplot.savefig("/home/pablo/TFG/results/HEATMAP/NJss.svg",dpi=350)
               
snps_dataframe = pd.read_excel("/home/pablo/TFG/data/BRESEQ/HEATMAP.xlsx", sheet_name= "Hoja3")
print(snps_dataframe)
snps_dataframe.index = snps_dataframe["SNPs_Breseq"]
snps_dataframe = snps_dataframe.drop("SNPs_Breseq", axis = 1)

#print(snps_dataframe)

pyplot.figure(figsize=(28, 4)) # dimensions of plot may vary depending on the number of genes mutated
heatmap = sb.heatmap(snps_dataframe, cmap="Blues", xticklabels=True, yticklabels=True, linewidths=0.0)
heatmap.set_xticklabels(heatmap.get_xticklabels(),rotation = 60, horizontalalignment='center', fontsize = 22)
heatmap.set_yticklabels(heatmap.get_ymajorticklabels(), rotation = 0, fontsize = 22)
pyplot.savefig("/home/pablo/TFG/results/HEATMAP/SNPss.svg",dpi=350)