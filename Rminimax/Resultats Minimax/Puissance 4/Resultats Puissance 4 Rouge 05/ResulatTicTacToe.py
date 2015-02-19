import sys
from decimal import *
from math import *

DicoResult = {}
#listFile = ["001_10","01_10","03_10","05_10","06_10","07_10","085_10","1_10","5_10","10_10"]
listFile = ["07","01","10","001"]

for file in listFile:

    textfile = "resultP4_"+str(file)+"_05.txt"
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