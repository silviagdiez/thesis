import sys
from decimal import *
from math import *


#Script servant uniquement a compter le nombre de parties gagnantes, nulles ou perdantes dun fichier
DicoResult = {}
#listFile = ["001_10","01_10","03_10","05_10","06_10","07_10","085_10","1_10","5_10","10_10"]
listFile = ["J01","J03","J05","J07","J1","J5","J10"]

for file in listFile:

    textfile = "resultTicTacToe.txt"
    resultat=0
    file1 = open(textfile,'r')
    line = file1.readline()
    Nline = 0
    while line:
        line = line.rstrip()
        Nline = Nline+1
        if Nline<100:
            if line=='R':
                resultat=resultat-1
            elif line=='N':
                resultat=resultat+0
            elif line=='J':
                resultat=resultat+1
        line = file1.readline()
    DicoResult[str(file).split('_')[0]]=resultat
    file1.close()
    
    
for elt in DicoResult:
    print elt, DicoResult[elt],"\n"