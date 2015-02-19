#!/usr/bin/pythonw
from math import sqrt

path = '/Users/silviagdiez/Desktop/minimax/Resultats Minimax/Tic Tac Toe/'
jaunes = ['10','5','1','07','05','03','01']
rouges = ['02','05','1','2','5','10']

for j in jaunes:
	print j + ', ',
print ' '
for r in rouges:
	for j in jaunes:
		
		file1 = '100resultTicTacToeJ' + j + '_R' + r + '.txt' 
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

