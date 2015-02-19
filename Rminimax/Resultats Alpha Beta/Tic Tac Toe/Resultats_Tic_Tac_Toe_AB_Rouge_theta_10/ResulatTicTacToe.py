import sys
from decimal import *
from math import *

DicoResult = {}
#listFile = ["001_10","01_10","03_10","05_10","06_10","07_10","085_10","1_10","5_10","10_10"]
listFile = ["J01","J03","J05","J07","J1","J0000001","J11","J12","J2","J3","J10","J001"]

for file in listFile:

    textfile = "100resultTicTacToeAB_"+str(file)+"_R10.txt"
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