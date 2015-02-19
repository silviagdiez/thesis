#! /bin/env python

from Tkinter import *


import time
from games import * 
from copy import deepcopy
from Puissance4Display import *
from P4Representation import *
import datetime
import time
from math import *






class Puissance4AI(Game):
    def make_move( self, action, state ):
        '''
        Renvoi l etat qui resulte d un mouvement valide a partir d un etat courant
        ''' 
        rep=state
        P4_rep=rep.clone()
        P4_rep.play_action(action)
        return P4_rep

    
    
    def successors(self, state):
        '''
        Renvoi la liste des successeurs pour letat courant state
        '''
        ok=True
        caseUtilisee_rep=state.getState()
        succ=[]
        if (len(caseUtilisee_rep)-1)%2==0:
            player = 'red'
        else:
            player = '#FFCC00'

        for n in range(41,34,-1):
        #for n in range(41,34,-1):
            ok=True
            for s in range(n,n-42,-7):
            #for s in range(n,n-8,-7):
                if len(caseUtilisee_rep)==0:
                    action = s
                    succ.append((s, self.make_move(action,state)))
                    break
                else:
                    dedans=False
                    for l in range(0, len(caseUtilisee_rep)):
                        if s == caseUtilisee_rep[l]:
                            dedans=True
                    if dedans != True:
        #                    print s
                            action = s
                            succ.append((s, self.make_move(action,state)))
                            break

        return succ
                
    
    def utility(self, state, player):
        '''
        Renvoi la valeur dutilite pour le joueur player pour letat state
        '''
        caseUtilisee_rep=state.getState()
        caseUtilisee=caseUtilisee_rep
        liste=[]
        n = caseUtilisee_rep[len(caseUtilisee_rep)-1] #derniere case utilisee
        listerouge=[]
        listejaune=[]
        for index in range(0,len(caseUtilisee_rep)):
            if index%2==0:
                listejaune.append(caseUtilisee_rep[index]) 
            if index%2==1:
                listerouge.append(caseUtilisee_rep[index])
        
        #nbrdelignespossiblevide
        countLignes=0
        
        #couleurPlayer = caseUtilisee_rep[len(caseUtilisee_rep)-1] #derniere case utilisee
        
        if (len(caseUtilisee_rep)-1)%2==0:
           # caseUtilisee_rep=listejaune
            couleurPlayer='#FFCC00'
        else:
            #caseUtilisee_rep=listerouge
            couleurPlayer='red'
        #Compte nbre de lignes dispos
        #Lignes verticales
        if n in caseUtilisee_rep and n+7 not in caseUtilisee_rep and n+14 not in caseUtilisee_rep and n+21 not in caseUtilisee_rep:
            countLignes=countLignes+1
        
        #Lignes horizontales 
        if n in caseUtilisee_rep and n+1 not in caseUtilisee_rep and n+2 not in caseUtilisee_rep and n+3 not in caseUtilisee_rep:
            countLignes=countLignes+1
            
        if n in caseUtilisee_rep and n-1 not in caseUtilisee_rep and n-2 not in caseUtilisee_rep and n-3 not in caseUtilisee_rep:
            countLignes=countLignes+1    
            
        if n in caseUtilisee_rep and n+1 not in caseUtilisee_rep and n-1 not in caseUtilisee_rep and n-2 not in caseUtilisee_rep:
            countLignes=countLignes+1 
            
        if n  in caseUtilisee_rep and n-1 not in caseUtilisee_rep and n+1 not in caseUtilisee_rep and n+2 not in caseUtilisee_rep:
            countLignes=countLignes+1     
        
        #Lignes Diagonales
        if n  in caseUtilisee_rep and n-6 not in caseUtilisee_rep and n-12 not in caseUtilisee_rep and n-18 not in caseUtilisee_rep:
            countLignes=countLignes+1
            
        if n  in caseUtilisee_rep and n-8 not in caseUtilisee_rep and n-16 not in caseUtilisee_rep and n-24 not in caseUtilisee_rep:
            countLignes=countLignes+1
        
        if n in caseUtilisee_rep and n+8 not in caseUtilisee_rep and n-8 not in caseUtilisee_rep and n-16 not in caseUtilisee_rep:
            countLignes=countLignes+1
            
        if n in caseUtilisee_rep and n+6 not in caseUtilisee_rep and n-6 not in caseUtilisee_rep and n-12 not in caseUtilisee_rep:
            countLignes=countLignes+1
        
        if n  in caseUtilisee_rep and n+6 not in caseUtilisee_rep and n+12 not in caseUtilisee_rep and n-6 not in caseUtilisee_rep:
            countLignes=countLignes+1
        
        if n in caseUtilisee_rep and n+8 not in caseUtilisee_rep and n+16 not in caseUtilisee_rep and n-8 not in caseUtilisee_rep:
            countLignes=countLignes+1

        
        countLignes=self.weightCase(n,countLignes)
        
        
        #Nbre de cases qui se suivent de la meme couleur ou vide
        countNbrCaseAdjacent=0
        if n-1 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n-1,countNbrCaseAdjacent+1)
            if n-2 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n-2,countNbrCaseAdjacent+1)
        
        if n-8 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n-8,countNbrCaseAdjacent+1)
            if n-16 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n-16,countNbrCaseAdjacent+1)
                
        if n-7 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n-7,countNbrCaseAdjacent+1)
            if n-14 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n-14,countNbrCaseAdjacent+1)
                
        if n-6 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n-6,countNbrCaseAdjacent+1)
            if n-12 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n-12,countNbrCaseAdjacent+1)        
        
        if n+1 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n+1,countNbrCaseAdjacent+1)
            if n+2 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n+2,countNbrCaseAdjacent+1)
                
                
        if n+8 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n+8,countNbrCaseAdjacent+1)
            if n+16 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n+16,countNbrCaseAdjacent+1)       
       
        if n+7 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n+7,countNbrCaseAdjacent+1)
            if n+14 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n+14,countNbrCaseAdjacent+1)
                
        if n+6 in caseUtilisee_rep:
            countNbrCaseAdjacent=self.weightCase(n+6,countNbrCaseAdjacent+1)
            if n+12 in caseUtilisee_rep:
                countNbrCaseAdjacent=self.weightCase(n+12,countNbrCaseAdjacent+1)
                
        
        total = countNbrCaseAdjacent+ countLignes                         
        #Si le joueur gagne +1000
        t = self.terminal_test(state)
        if t[0] and t[1]!='N':
            if couleurPlayer!=player:
                total=total+1000
            else:
                total=total+1000
                
                
        if player==couleurPlayer:
            return total
        else:
            return -total
        
        
        
        
    def weightCase(self,n,countLines):
        '''
        Renvoi le nombre de ligne en fonction du poids de celles ci
        '''
        if n== 0:
                countLines=countLines*3
        if n==1:
                countLines=countLines*4
        if n== 2:
                countLines=countLines*5
        if n==3:
                countLines=countLines*7
        if n== 4:
                countLines=countLines*5
        if n==5:
                countLines=countLines*4
        if n== 6:
                countLines=countLines*3
        if n==7:
                countLines=countLines*4
        if n== 8:
                countLines=countLines*6
        if n==9:
                countLines=countLines*8
        if n== 10:
                countLines=countLines*10
        if n==11:
                countLines=countLines*8
        if n== 12:
                countLines=countLines*6
        if n==13:
                countLines=countLines*4
        if n== 14:
                countLines=countLines*5
        if n==15:
                countLines=countLines*8
        if n== 16:
                countLines=countLines*11
        if n==17:
                countLines=countLines*13
        if n== 18:
                countLines=countLines*11
        if n==19:
                countLines=countLines*8
        if n== 20:
                countLines=countLines*5
        if n==21:
                countLines=countLines*5
        if n== 22:
                countLines=countLines*8
        if n==23:
                countLines=countLines*11
        if n== 24:
                countLines=countLines*13
        if n==25:
                countLines=countLines*11
        if n== 26:
                countLines=countLines*8
        if n==27:
                countLines=countLines*5
        if n== 28:
                countLines=countLines*4
        if n==29:
                countLines=countLines*6
        if n== 30:
                countLines=countLines*8
        if n==31:
                countLines=countLines*10
        if n==32:
                countLines=countLines*8
        if n== 33:
                countLines=countLines*6
        if n==34:
                countLines=countLines*4
        if n== 35:
                countLines=countLines*3
        if n==36:
                countLines=countLines*4
        if n== 37:
                countLines=countLines*5
        if n==38:
                countLines=countLines*7
        if n== 39:
                countLines=countLines*5
        if n==40:
                countLines=countLines*4
        if n== 41:
                countLines=countLines*3
                
        return countLines
    
    
    def terminal_test(self, stateR):
        '''
        Renvoi true si letat stateR est terminal et false sinon
        '''
        listerouge=[]
        listejaune=[]
        state=stateR.getState()
        n = state[len(state)-1]
        for index in range(0,len(state)):
            if index%2==0:
                listejaune.append(state[index])
            if index%2==1:
                listerouge.append(state[index])
                     
        if len(state) == 42 : 
             return (True,'N') 
         
        if n in listerouge and n+7 in listerouge and n+14 in listerouge and n+21 in listerouge: 
             # D'abbord a la verticale,
             # separement car proximite d'un bord ininteressante
             liste=[n, n+7, n+14, n+21] # Pour gerer les parties "plurigagnantes"
             return (True,'R')
    
     #idem pour jaunes
    
        if n in listejaune and n+7 in listejaune and n+14 in listejaune and n+21 in listejaune:
             liste=[n, n+7, n+14, n+21]
             return (True,'J')
    
        for x in (1,-6,8):
        
             if n in listerouge: # en s'assurant qu'elles ne sont trop pres des bords (pour ne pas arriver de l'autre cote du plateau)
                 if n % 7 != 6 and n+x in listerouge:
                     if n % 7 != 5 and n+2*x in listerouge:
                         if n % 7 != 4 and n + 3*x in listerouge:
                             liste = [n, n+x, n+2*x, n+3*x]
                             #print "Rouge gagne"
                             return (True,'R')
                         if n%7 > 0 and (n-x) in listerouge:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Rouge gagne"
                             return (True,'R')
                         if n%7 > 1 and (n-x) in listerouge:
                             if n%7 > 2 and n-(2*x) in listerouge:
                                 liste = [n-2*x, n-x,n, n+x]
                                 #print "Rouge gagne"
                                 return (True,'R')
        
         #Pareil pour les jaune
             if n in listejaune:
                 if n % 7 != 6 and n+x in listejaune:
                     if n % 7 != 5 and n+ 2*x in listejaune:
                         if n % 7 != 4 and n + 3*x in listejaune:
                             liste = [n, n+x, n+2*x, n+3*x]
                             #print "Jaune gagne"
                             return (True,'J') 
                         if n%7 > 0 and (n-x) in listejaune:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Jaune gagne"
                             return (True,'J') 
                         if n%7 > 1 and (n-x) in listejaune:
                             if n%7 > 2 and n-(2*x) in listejaune:
                                 liste = [n-2*x, n-x,n, n+x]
                                 #print "Jaune gagne"
                                 return (True,'J') 
        
        
        for x in (-1,6,-8):
             if n in listejaune:
                 if n % 7 != 0 and (n+x) in listejaune:
                     if n % 7 != 1 and n+(2*x) in listejaune:
                         if n % 7 != 2 and n + (3*x) in listejaune:
                             liste = [n, n+x, n+2*x, n+3*x]
                            # print "Jaune gagne"
                             return (True,'J') 
                         if n%7 <6 and (n-x) in listejaune:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Jaune gagne"
                             return (True,'J') 
                         if n%7 < 5 and (n-x) in listejaune:
                             if n%7 < 4 and n-(2*x) in listejaune:
                                 liste = [n-2*x, n-x,n, n+x]
                                 print "Jaune gagne"
                                 return (True,'J') 
        
             if n in listerouge:
                 if n % 7 != 0 and (n+x) in listerouge:
                     if n % 7 != 1 and n+(2*x) in listerouge:
                         if n % 7 != 2 and n + (3*x) in listerouge:
                             liste = [n, n+x, n+2*x, n+3*x]
                            # print "Rouge gagne"
                             return (True,'R') 
                         if n%7 <6 and (n-x) in listerouge:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Rouge gagne"
                             return (True,'R') 
                         if n%7 < 5 and (n-x) in listerouge:
                             if n%7 < 4 and n-(2*x) in listerouge:
                                 liste = [n-2*x, n-x,n, n+x]
                                #print "Rouge gagne"
                                 return (True,'R') 
     
 
        return (False,'n')                   
              

    def to_move(self, stateR):
        '''
        Renvoi qui est le prochain joueur a jouer
        '''
        state1=stateR.getState()
        if len(state1)%2==0:
            return '#FFCC00'
        else:
            return 'red'

        

class AI:
    def __init__( self,game  ):
        print "AI agent started!"
        self.game=game
     

    def dedans2(self, table ,etat1,etat2,dicoEtatsIndices):
        '''
        Regarde si la transition de letat1 a letat2 se trouve deja dans la dictionnaire 
        '''
        ind1=etat1
        ind2=etat2
        indice1=0
        find1=False
        find2=False
        indice2=0
        if table.has_key(str(ind1)+" "+str(ind2)): 
                    indice1=ind1
                    indice2=ind2
                    find2=True 
                    find1=True

        return (find1,find2,indice1,indice2)


    
    
    def dedans1(self, table ,etat1):
        '''
        Regarde si letat1 se trouve deja dans la table et renvoie son indice si il est deja present 
        '''
        list=etat1.split()
        indice1=0
        find1=False
        for s in table:
            ok=True
            listCleTable=s.split()
            if len(listCleTable)==len(list):
                index1=0
                for words in list:
                    trouve=False
                    index2=0
                    if index1%2==0:
                        if words in listCleTable[::2]:
                            trouve=True
                    elif index1%2==1:
                        if words in listCleTable[1::2]:
                                trouve=True
                    index1=index1+1
                    if trouve==False:
                        ok=False
                        break
            else:
                ok=False
            if ok:
                    find1=True
                    return (find1,table[s])
            
        return (find1,0)
    


    
    def w_choice(self,lst):
        '''
        Renvoie le prochain coup a jouer en fonction des probabilites de transition 
        '''
        n = random.uniform(0, 1)
        for item, weight in lst:
            if n < weight:
                break
            n = n - weight
        return item    
    
    def getAction( self, state,joueur,teta ):
        '''   
        Pre : le plateau de jeu courant de la partie, le prochain joueur a jouer,
               et le teta du joueur a jouer
        Return : le prochain coup randomise a jouer pour le joueur a jouer en fonction 
                 de son teta et du plateau courant de jeu.
        La fonction cherche d abord toutes les solutions finales du jeu en cours grace 
        a l algorithme minimax. Elle cree ensuite le graphe acyclique de ces solutions,
        calculs les Z et les probabilites des prochains coups possibles a jouer.
        Et renvoi le prochain coup en fonction de ces probabilites.
        Cette methode implemente l algorithme Rminimax
        '''
        
        # representation de l objet du plateau courant de jeu
        representation1= P4Representation(state)
        t0 = datetime.datetime.now()
        print t0
        #Recherche des solutions terminales du plateau de jeu courant
        #grace a l algorithme alpha beta
        action= minimax_decision(representation1,self.game)
        Solutions=action[1]
        SolState=action[2]
        SolDef=[]
        i=0
        gagnant=""
        if joueur==1:
            gagnant='J'
        else:
            gagnant='R'


        print """Creation du Graphe acyclique a partir des etats terminaux trouves
                    par lalgorithme Minimax ou Alpha beta pruning"""
        
        P={} # Pour les probabilites de transitions
        dicoIndicesEtats={}
        dicoEtatsIndices={}
        tableIndicesEtatsCouts={}
        tableIndicesEtatsCoutsB={}
        tableIndicesEtatsCoutsBListe={}
        listeDerniersElts= [] #Liste des derniers noeuds pour les Zkn
        index=0
        nbrd=0
        print len(Solutions)#Nombre de solutions
        cleCourante=""
        tableIndicesEtatsTour={}
        tableIndicesEtatsTourFirst={}
        maximum=0
        cleArray=[]
        #Trouver la cle courante
        for w in state:
            cleCourante=cleCourante+str(w)+" "
        
        #Construction du graphe dirige    
        for sol in Solutions:
            indAdv=0
            cle=cleCourante
            cle=""
            cle1=""
            cle2=""
            poids=1
            cleArray=[]
            #Calcul du pourcentage deja acheve
            nbrd=nbrd+1
            if nbrd%1000==0:
                print (nbrd*100.0)/len(Solutions)," % acheves"
                
            ancienTupleBoolCle=""
            tupleBoolCle=""
            for i in range(len(state),len(sol.getState())):
               # print cle, len(state), len(sol.getState()) ,  sol.getState()
                if i < len(sol.getState()):

                    #Recuperation du premier indice de transition
                    ancienTupleBoolCle=tupleBoolCle
                    if ancienTupleBoolCle!="":
                        if not ancienTupleBoolCle[0]:
                                ancienTupleBoolCle=(ancienTupleBoolCle[0],index-1)
                    
                    if dicoEtatsIndices.has_key(cle):
                        tupleBoolCle=dicoEtatsIndices[cle]
                        tupleBoolCle=(True,tupleBoolCle)
                    else:
                        #tupleBoolCle=self.dedans1(tableArray,cle)
                        tupleBoolCle=self.dedans1(dicoEtatsIndices,cle)
                            
                    if not tupleBoolCle[0]:
                        dicoIndicesEtats[index]=cle
                        if index < 2:
                            if len(cle)==0:
                               r=5
                            else:
                                q= [-1]*(5-len(cleArray))
                                t=cleArray
                                t.extend(q)
                                cleArray=cleArray[:(5-len(cleArray)+1)]
                        else:
                            q= [-1]*(5-len(cleArray))
                            t=cleArray
                            t.extend(q)
                            t=t[:(5-len(cleArray))]
                            cleArray=cleArray[:(5-len(cleArray)+1)]
                        dicoEtatsIndices[cle]=index
                        index=index+1
            

                if (i > len(state) and i < len(sol.getState())) :
                    #Recuperation de l'indice du noeud suivant
                    ind1=ancienTupleBoolCle[1]
                        
                    if tupleBoolCle[0]:
                            cle2=tupleBoolCle[1]
                    else:
                            cle2=index-1
                            
                    quad=self.dedans2(tableIndicesEtatsCouts ,ind1,cle2,dicoEtatsIndices)
                    if not quad[0] and not quad[1]:

                        repTest= P4Representation(sol.getState()[:(i)])

                        if tupleBoolCle[0]:
                            ind2=tupleBoolCle[1]
                        else:
                            ind2=index-1

                        P[str(ind1)+" "+str(ind2)]=0

                        tableIndicesEtatsCouts[str(ind1)+" "+str(ind2)]=1
                        tableIndicesEtatsCoutsB[str(ind1)+" "+str(ind2)]=False
                        tableIndicesEtatsTour[str(ind1)+" "+str(ind2)]=indAdv
                        if tableIndicesEtatsTourFirst.has_key(str(ind1)):
                            if tableIndicesEtatsTourFirst[str(ind1)]!=indAdv:
                                print "Erreur" 
                        tableIndicesEtatsTourFirst[str(ind1)]=indAdv   
                        if tableIndicesEtatsCoutsBListe.has_key(str(ind1)):
                            t = tableIndicesEtatsCoutsBListe[str(ind1)]
                            t[len(t):]=[str(ind2)]
                            tableIndicesEtatsCoutsBListe[str(ind1)]=t
                        else:
                            l=[str(ind2)]
                            tableIndicesEtatsCoutsBListe[str(ind1)]=l             
                          #On stocke tous les noeuds finaux    
                              
                if i+1 == len(sol.getState()): 
                    t = cle+str(sol.getState()[i])+" "
                    cleArray.append(sol.getState()[i])


                    if tupleBoolCle[0]:
                            indP=tupleBoolCle[1]
                    else:
                            indP=index-1


                    #On prend les index des etats qui sont finaux
                    if dicoEtatsIndices.has_key(t):
                        lal=dicoEtatsIndices[t]
                        lal=(True,lal)
                    else:
                        lal=self.dedans1(dicoEtatsIndices,t)
    
                    if not lal[0]:
                        dicoIndicesEtats[index]=t
                        dicoEtatsIndices[t]=index
                        if index < 2:
                            if len(cle)==0:
                                r=5
                            else:
                                q= [-1]*(5-len(cleArray))
                                t=cleArray
                                t.extend(q)
                                cleArray=cleArray[:(5-len(cleArray)+1)]
                        else:
                            q= [-1]*(5-len(cleArray))
                            t=cleArray
                            t.extend(q)
                            t=t[:(5-len(cleArray))]
                            cleArray=cleArray[:(5-len(cleArray)+1)]
                        
                        index=index+1
                    
                    if lal[0]:
                        indF=lal[1]
                    else:
                        indF=index-1

                    if str(indF) not in listeDerniersElts:
                        listeDerniersElts.append(str(indF))
                        #A rajouter dans le tableau des indices etats
  
                    if not tableIndicesEtatsCouts.has_key(str(indP)+" "+str(indF)):
                        repTest= P4Representation(sol.getState()[:(i+1)])
                        tmp = self.game.terminal_test(repTest)
                        if not dicoEtatsIndices.has_key(cle):
                             y = self.dedans1(dicoEtatsIndices,cle)
                             y=y[1]
                        else:
                            y=dicoEtatsIndices[cle]
                        tableIndicesEtatsCoutsB[str(y)+" "+str(indF)]=False
                        tableIndicesEtatsTour[str(y)+" "+str(indF)]=(indAdv+1)%2
    
                        if tableIndicesEtatsTourFirst.has_key(str(y)):
                            if tableIndicesEtatsTourFirst[str(y)]!=(indAdv+1)%2:
                                print "Erreur" 
                        tableIndicesEtatsTourFirst[str(y)]=(indAdv+1)%2
                        
                        if tableIndicesEtatsCoutsBListe.has_key(str(y)):
                            t = tableIndicesEtatsCoutsBListe[str(y)]
                            t[len(t):]=[str(indF)]
                            tableIndicesEtatsCoutsBListe[str(y)]=t
                        else:
                            l=[str(indF)]
                            tableIndicesEtatsCoutsBListe[str(y)]=l                             
                            
                             
                        if tmp[0]==True and tmp[1]!='N':
                            #On met une valeur dutilite a chaque etat terminal
                            if tmp[1]!=gagnant:
                                tableIndicesEtatsCouts[str(y)+" "+str(indF)]=41
                                #etat terminal perdant
                            elif tmp[1]==gagnant:
                                tableIndicesEtatsCouts[str(y)+" "+str(indF)]=1
                                #etat terminal gagnant

                        if tmp[0]==True and tmp[1]=='N':
                            #etat terminal nul
                            tableIndicesEtatsCouts[str(y)+" "+str(indF)]=22
                            
                        if tmp[0]==False:
                            #Lorsque letat nest pas terminal, il faut utiliser la fonction devaluation
                            tableIndicesEtatsCouts[str(y)+" "+str(indF)]=self.game.utility(repTest,self.game.to_move(representation1))/1000000.0
                            #on reduit la valeur devaluation sinon la fonction exp fait un overflow
                            tmpCa = tableIndicesEtatsCouts[str(y)+" "+str(indF)]
                            #Les valeurs dutilite sont en fait des cout ici
                            if tmpCa<0:
                                tmpCa=-tmpCa
                            if maximum < tmpCa:
                                maximum=tmpCa
                            if tableIndicesEtatsCouts[str(y)+" "+str(indF)]<0:
                                tableIndicesEtatsCouts[str(y)+" "+str(indF)]=30-tmpCa
                            else:
                                tableIndicesEtatsCouts[str(y)+" "+str(indF)]=30-tmpCa
                            if tableIndicesEtatsCouts[str(y)+" "+str(indF)]>41:
                                print "l" ,tableIndicesEtatsCouts[str(y)+" "+str(indF)]


                cle=cle+str(sol.getState()[i])+" "
                cleArray.append(sol.getState()[i])
                indAdv=(indAdv+1)%2
       
        
        print "Creation Des Z" 
        Z = {}
        #teta=10.0
        listeP = {}    
        Z[str(-10000)+" "+str(-10000)]=1#tous les znn = 1 

        #Pour tous les etats qui menent a un etat final
        listeIndiceMenantAuFinal = []
        listeIndiceMenantAuFinalFinal = []
        DicoIndiceMenantAuFinal = {}
        for cle in tableIndicesEtatsCouts:
            cle2 = cle.split()[1]
            if cle2 in listeDerniersElts:
                listeIndiceMenantAuFinal.append(cle.split()[0])
                if DicoIndiceMenantAuFinal.has_key(cle.split()[0]):
                    t = DicoIndiceMenantAuFinal[cle.split()[0]]
                    t[len(t):]=[cle]
                    DicoIndiceMenantAuFinal[cle.split()[0]]=t
                else:
                    l=[cle]
                    DicoIndiceMenantAuFinal[cle.split()[0]] = l

        
        while len(listeIndiceMenantAuFinal) != 0:
            tmp = {}
            p=0
            for indice in listeIndiceMenantAuFinal:
                if len(listeP)==0:
                    #Lorsque aucun zxn na encore ete calcule
                    cleZP = DicoIndiceMenantAuFinal[indice].pop(0)
                    tmp[cleZP] = 1.0 * math.exp(-teta*tableIndicesEtatsCouts[cleZP])
                    tableIndicesEtatsCoutsB[cleZP]=True
                    
                    if tableIndicesEtatsTour[cleZP]==1: 
                        #Si le joueur doit faire la somme
                        if Z.has_key(str(indice)+" "+str(-10000)):
                            Z[str(indice)+" "+str(-10000)] = Z[str(indice)+" "+str(-10000)]+tmp[cleZP]
                        else:
                            Z[str(indice)+" "+str(-10000)] = tmp[cleZP]
                    elif tableIndicesEtatsTour[cleZP]==0:
                        #Si le joueur doit prendre le minimum
                        if Z.has_key(str(indice)+" "+str(-10000)):
                            if (tmp[cleZP] < Z[str(indice)+" "+str(-10000)] or Z[str(indice)+" "+str(-10000)]==0) and tmp[cleZP]!=0:
                                Z[str(indice)+" "+str(-10000)] = tmp[cleZP]
                        else:
                            Z[str(indice)+" "+str(-10000)] = tmp[cleZP]

                    
                    tmp[cleZP]=Z[str(indice)+" "+str(-10000)]
                                    
                else:
                     #Si il y a deja des zxn qui ont ete calcule
                    valeurZ = 0
                    cle1=""
                    t=""
                    for elt in tableIndicesEtatsCoutsBListe[str(indice)]:
                        if not tableIndicesEtatsCoutsB[str(indice)+" "+elt]:
                                if tableIndicesEtatsCouts.has_key(str(indice)+" "+elt):
                                    t=elt
                                    if not Z.has_key(elt+" "+str(-10000)):
                                        Z[elt+" "+str(-10000)]=0
                                    else:
                                        tableIndicesEtatsCoutsB[str(indice)+" "+elt]=True
                                        
                                    if tableIndicesEtatsTourFirst[str(indice)]==0:
                                        #Si le joueur doit prendre le minimum
                                        if not Z.has_key(str(indice)+" "+str(-10000)):
                                            Z[str(indice)+" "+str(-10000)]=Z[elt+" "+str(-10000)]*math.exp(-teta*tableIndicesEtatsCouts[str(indice)+" "+elt])
                                        else:
                                            valeurzTmp = Z[elt+" "+str(-10000)]*math.exp(-teta*tableIndicesEtatsCouts[str(indice)+" "+elt])
                                            if (Z[str(indice)+" "+str(-10000)] > valeurzTmp or Z[str(indice)+" "+str(-10000)]==0) and valeurzTmp!=0:
                                                Z[str(indice)+" "+str(-10000)]=valeurzTmp
                                    else:
                                        #Si le joueur doit faire la somme        
                                        valeurZ=valeurZ+(Z[elt+" "+str(-10000)]*math.exp(-teta*tableIndicesEtatsCouts[str(indice)+" "+elt]))
                                        
                                    
                    if tableIndicesEtatsTourFirst[str(indice)]==1: 
                        #Si le joueur doit faire la somme
                        if Z.has_key(str(indice)+" "+str(-10000)):    
                            Z[str(indice)+" "+str(-10000)]= Z[str(indice)+" "+str(-10000)]+valeurZ
                        else:
                            #Si le joueur doit prendre le minimum
                            Z[str(indice)+" "+str(-10000)]=valeurZ
    
                    
                    tmp[str(indice)+" "+cle1]=Z[str(indice)+" "+str(-10000)]
                    
                    
            #Comme on part des etats terminaux, il faut trouver quels sont les etats menant aux etats que lon vient de visiter      
            listeP=tmp
            listeTmp = []
            listeTmp2 = []
            DicoIndiceMenantAuFinal = {}
            for cle in tableIndicesEtatsCouts:
                cle2 = cle.split()[1]
                if cle2 in listeIndiceMenantAuFinal:
                    if cle.split()[0] not in listeTmp:
                        ok=True
                        for te in tableIndicesEtatsCoutsBListe[cle2]:
                            if not tableIndicesEtatsCoutsB[cle2+" "+te]:
                                ok=False
                        if ok:
                            listeTmp.append(cle.split()[0])
                            listeTmp2.append(cle.split()[0])
                            if DicoIndiceMenantAuFinal.has_key(cle.split()[0]):
                                DicoIndiceMenantAuFinal[cle.split()[0]].append(cle)
                            else:
                                DicoIndiceMenantAuFinal[cle.split()[0]]=[]
                                DicoIndiceMenantAuFinal[cle.split()[0]].append(cle)
            #on regarde que le prochain etat dont on va calculer les zxn nest pas encore dans la liste
            liste=[]        
            for elt in listeTmp:
                ok=True
                for elt2 in listeTmp2:
                    if tableIndicesEtatsCouts.has_key(elt+" "+elt2):
                        ok=False
                        break
                    
                if ok:
                    liste.append(elt)
                
            listeIndiceMenantAuFinal = liste 
   
        
        
        #Indice de la sol courante
        cleCourante=""
        indiceCourant=0
        for w in state:
            cleCourante=cleCourante+str(w)+"/"
        if dicoEtatsIndices.has_key(cleCourante):
            indiceCourant=dicoEtatsIndices[cleCourante]
        
        SolutionsSuivantesPossibles= {}
        
        
        
        
        print "Calculs des probabilites de transition" 
        
        
        Z[str(-10000)+" "+str(-10000)]=1
        listWeight=[]
        r = 0
        for final in listeDerniersElts:
            if not Z.has_key(final+" "+str(-10000)):
                r=r+1
                Z[final+" "+str(-10000)]=1
        print "nombre de sans cle ", r/len(listeDerniersElts)
        for cle in tableIndicesEtatsCouts:
            listeCle = cle.split()
            cle1 = listeCle[0]
            cle2 = listeCle[1]
            if cle1!=str(-10000):
                if Z[cle1+" "+str(-10000)]==0:
                    print "cle1==0"
                    P[cle]=1.0**math.exp(-teta*tableIndicesEtatsCouts[cle])
                else:
                    P[cle]= (Z[cle2+" "+str(-10000)]/Z[cle1+" "+str(-10000)])*math.exp(-teta*tableIndicesEtatsCouts[cle])
                    
                if cle.split()[0]==str(indiceCourant):
                    #Affichage des probabilites de transition du prochain coup a jouer
                    print "Proba pour la cle : ", cle , " : " , P[cle], " letat suivant : ", dicoIndicesEtats[int(cle.split()[1])]
                    SolutionsSuivantesPossibles[dicoIndicesEtats[int(cle.split()[1])]]=P[cle]
                    listWeight.append((dicoIndicesEtats[int(cle.split()[1])],P[cle]))
                  
        
        probaTotale=0
        maxProba=-1.0
        res=1
        for all in SolutionsSuivantesPossibles:
            #Verification si la somme des probabilites des prochains coups est egal a 1 
            probaTotale=probaTotale+SolutionsSuivantesPossibles[all]
            if maxProba<SolutionsSuivantesPossibles[all]:
                maxProba=SolutionsSuivantesPossibles[all]
                res=all
        print "Somme des probas : ", probaTotale            
        print len(P)
        print "Max des proba : ", res     
        print "action choisie normalement : ",action[0]
        #calcul du temps pris pour trouver la solution 
        delta_t = datetime.datetime.now() - t0 
        #on choisit la prochaine action en fonction des probabilites de transition
        x = self.w_choice(listWeight)
        print "temps dexecution : ", delta_t     
        print "Etat courant : ",cleCourante
        print x
        return int(x)

   
#############################################################################





