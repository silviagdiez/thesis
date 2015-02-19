#!/usr/bin/pythonw
from math import sqrt

files = ['07','01','10','001']
path = '/Users/silviagdiez/Desktop/minimax/Resultats Minimax/Puissance 4/Resultats Puissance 4 Rouge 5/'

for file in files:

	file1 = 'resultP4_' + file + '_5.txt' 
        #print file
        fin1 = open(path+file1, 'r')
	res = 0
	Nline = 0
	#for line in fin1:
        for line in fin1:
		line = line.rstrip()
		Nline = Nline+1
		if Nline < 100:
			if line=='R':
				res = res-1;
			elif line=='J':
				res = res+1;
	print res		
	fin1.close()
