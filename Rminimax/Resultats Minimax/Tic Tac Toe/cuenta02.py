#!/usr/bin/pythonw
from math import sqrt

path = '/Users/silviagdiez/Desktop/Rminmax/minimax/Resultats Minimax/Tic Tac Toe/'
jaunes = ['10','5','1','05','01']
rouges = ['01','05','1','5','10']

for j in jaunes:
	print j + ', ',
print ' '
for r in rouges:
	for j in jaunes:
		
		file1 = '100resultTicTacToeJ' + j + '_R' + r + '.txt' 
        	#print file1
        	fin1 = open(path+file1, 'r')
		resJ = 0
		resN = 0
		resR = 0
		Nline = 0
		#for line in fin1:
        	for line in fin1:
			line = line.rstrip()
			Nline = Nline+1
			if Nline < 101:
				if line=='R':
					resR = resR+1;
				elif line=='J':
					resJ = resJ+1;
				elif line=='N':
					resN = resN+1;
		#print resN,		
		#print resJ,		
		#print resR,		
		resT = (resJ*1) + (resR*(-1)) + (resN*0)
		resT = resT*1.0/100.0
		#print resT
		print 'y_'+str(r)+'_'+str(j)+' = [ repmat(1,1,'+str(resJ)+') repmat(0,1,'+str(resN)+') repmat(-1,1,'+str(resR)+') ]'
		fin1.close()
	print ' '

