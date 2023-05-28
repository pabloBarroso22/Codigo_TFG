#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 22 12:12:48 2023

@author: pablo
"""

from Bio import SeqIO
import pandas as pd



duplication=range(1293337,1312468)

gene_list = []
product_list = []
ID_list = []
Protein_sequence_list = []

for record in SeqIO.parse("/home/pablo/Downloads/CF12.gbk","genbank"):
    #print(record.features)
    for feature in record.features:
        #print(feature.type)
        #print(feature)
        if feature.type == "CDS":
            if "join" not in str(feature.location):
                #print(feature.type)
                #print(feature)
                gene_position = str(feature.location)
                #for location in feature.location == "location":
                #print(feature.type)
                gene_P1 = gene_position.strip("[")
                #print(gene_P1)
                gene_P2 = gene_P1.split("]")
                #print(gene_P2)
                gene_P3 = gene_P2.pop(0)
                #print(gene_P3)
                #Begin & End Genes
                gene_P4 = gene_P3.split(":")
                #print(gene_P4)
                b_gene = int(gene_P4[0])
                e_gene = int(gene_P4[1])
                #print(b_gene)
                #print(e_gene)
                if b_gene in duplication and e_gene in duplication:
                    #print(feature.qualifiers)
                    if "gene" in feature.qualifiers:
                        print(feature.qualifiers["gene"])
                        gene_list.append(feature.qualifiers["gene"][0])
                    else:
                        print(" ")
                        gene_list.append(" ")
                    if "locus_tag" in feature.qualifiers:
                        print(feature.qualifiers["locus_tag"])
                        ID_list.append(feature.qualifiers["locus_tag"][0])
                        #print(ID_list)
                    if "product" in feature.qualifiers:
                        print(feature.qualifiers["product"])
                        product_list.append(feature.qualifiers["product"][0])
                    Protein_sequence_list.append(feature.qualifiers["translation"][0])

gene_dict = {"Gene":gene_list,"ID":ID_list,"Product":product_list,"Protein_Sequence":Protein_sequence_list}
print(gene_dict)

print(ID_list)

print(product_list)
                    
print(gene_list)

print(Protein_sequence_list)

print(len(ID_list), len(product_list), len(gene_list), len(Protein_sequence_list))

DF_minregion13 = pd.DataFrame(gene_dict)
print(DF_minregion13)

DF_minregion13.to_excel("/home/pablo/TFG/results/Duplication_regions_CF/CF13/Duplication_minCF13.xlsx")
                      


                    
            
            