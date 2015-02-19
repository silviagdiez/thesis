#!/usr/bin/pythonw
from math import sqrt

path = '/Users/silviagdiez/Desktop/minimax/Resultats Alpha Beta/Puissance 4/'
jaunes = ['10','07','03','01','001']
#rouges = ['01','02','05','1','2','5','10']
rouges = ['10']

for j in jaunes:
	print j + ', ',
print ' '
for r in rouges:
	for j in jaunes:
		
		file1 = 'Puissance 4 Rouge theta ' + r + '/ABresultP4_' + j + '_' + r + '.txt' 
        	#print file1
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
		print res,		
		print ', ',
		fin1.close()
	print ' '

