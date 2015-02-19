#!/usr/bin/pythonw
from math import sqrt

path = '/Users/silviagdiez/Desktop/Rminmax/minimax/Resultats Alpha Beta/Puissance 4/'
jaunes = ['10','07','01','001']
rouges = ['01','02','05','1','2','5','10']
dirs = ['Puissance 4 Rouge theta 01/','Puissance 4 Rouge theta 02/','Puissance 4 Rouge theta 05/','Puissance 4 Rouge theta 1/','Puissance 4 Rouge theta 2/','Puissance 4 Rouge theta 5/','Puissance 4 Rouge theta 10/']

for j in jaunes:
	print j + ', ',
print ' '
for i in range(0,7):
	for j in jaunes:
		r = rouges[i]
		file1 = dirs[i]+'ABresultP4_' + j + '_' + r + '.txt' 
        	#print file1
		try:
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
			print 'y_'+str(r)+'_'+str(j)+' = [ repmat(1,1,'+str(resJ)+') repmat(0,1,'+str(resN)+') repmat(-1,1,'+str(resR)+') ];'
			fin1.close()
		except IOError:
			print 'no file '+j+' '+r

	print ' '

